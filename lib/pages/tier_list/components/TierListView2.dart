import 'dart:developer';

import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/extension/DateTime.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/extension/String.dart';
import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/http/TierListApi.dart';
import 'package:duel_links_meta/pages/deck_type_detail/index.dart';
import 'package:duel_links_meta/pages/tier_list/components/TierListItemView.dart';
import 'package:duel_links_meta/pages/tier_list/type/TierListGroup.dart';
import 'package:duel_links_meta/pages/tier_list/type/TierListType.dart';
import 'package:duel_links_meta/type/deck_type/TierList_PowerRanking.dart';
import 'package:duel_links_meta/type/deck_type/TierList_PowerRanking_Expire.dart';
import 'package:duel_links_meta/type/tier_list_top_tier/TierList_TopTier.dart';
import 'package:duel_links_meta/type/tier_list_top_tier/TierList_TopTier_Expire.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:duel_links_meta/type/enum/PageStatus.dart';

class TierListView extends StatefulWidget {
  const TierListView({super.key, required this.tierListType, this.minHeight});

  final TierListType tierListType;
  final double? minHeight;

  @override
  State<TierListView> createState() => _TierListViewState();
}

class _TierListViewState extends State<TierListView> with AutomaticKeepAliveClientMixin {
  List<TierListGroup> _tierListGroup = [];
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  TierListType get _tierListType => widget.tierListType;
  bool initFlag = false;
  var _pageStatus = PageStatus.loading;

  Future<void> navigateToDeckTypeDetailPage(TierList_TopTier deckType) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => DeckTypeDetailPage(
          name: deckType.name,
        ),
      ),
    );
  }

  final tierDescMap = {
    0: '',
    1: 'Expected to be a large percentage of the top cut in a competitive tournament.*',
    2: 'Expected to be in the top cut of a competitive tournament, but not a large percentage.*',
    3: 'Expected to be played in a competitive tournament, with the possibility of being in the top cut.*',
    4: 'Decks acknowledged by the Top Player Council as having potential for being on the Tier List and which should be further explored. Without established results, it is not recommended to invest in these decks.',
  };

  //
  Future<bool> fetchTopTiers({bool force = false}) async {
    var list = <TierList_TopTier>[];

    const hiveBoxKey = 'tier_list:top_tier';

    var reRefreshFlag = false;

    final hiveValue = MyHive.box.get(hiveBoxKey);
    log('[fetchTopTiers] box取值，value: $hiveValue, value == null ${hiveValue == null}, value type: ${hiveValue.runtimeType}');

    if (hiveValue == null || force) {
      if (hiveValue == null) {
        log('[fetchTopTiers] box值为空');
      } else {
        log('需要强制刷新');
      }

      final (err, res) = await TierListApi().getTopTiers().toCatch;

      if (err != null) {
        setState(() {
          _pageStatus = PageStatus.fail;
        });
        return false;
      }

      list = res?.map(TierList_TopTier.fromJson).toList() ?? [];
      await MyHive.box.put(hiveBoxKey, TierList_TopTier_Expire(data: list, expire: DateTime.now().add(const Duration(hours: 6))));
    } else {
      try {
        final value = hiveValue as TierList_TopTier_Expire;

        log('相差ms: ${DateTime.now().difference(value.expire).inSeconds}');

        if (value.expire.isBefore(DateTime.now())) {
          log('已过期， 需要渲染本地数据后再重新请求数据');
          reRefreshFlag = true;
        }

        list = hiveValue.data;
        log('转换成功');
      } catch (e) {
        log('[fetchTopTiers] 转换失败: $e');
        await MyHive.box.delete(hiveBoxKey);
        return true;
      }
    }

    final tier2DeckTypesMap = <int, List<TierList_TopTier>>{};

    for (final item in list) {
      if (tier2DeckTypesMap[item.tier] != null) {
        tier2DeckTypesMap[item.tier]?.add(item);
      } else {
        tier2DeckTypesMap[item.tier] = [item];
      }
    }

    final _list = <TierListGroup>[];
    tier2DeckTypesMap.forEach((key, value) {
      _list.add(TierListGroup(tier: key, deckTypes: value, desc: tierDescMap[key] ?? ''));
    });

    _list.sort((a, b) => a.tier.compareTo(b.tier));
    _list.forEach((element) {
      log(element.desc);
    });

    setState(() {
      _tierListGroup = _list;
      _pageStatus = PageStatus.success;
    });

    return reRefreshFlag;
  }

  Future<bool> fetchPowerRankings(bool rush, {bool force = false}) async {
    var list = <TierList_PowerRanking>[];
    final boxKey = 'tier_list:power_ranking:${rush ? 'rush' : ''}';
    var reRefreshFlag = false;

    final  hiveValue = MyHive.box.get(boxKey);

    if (hiveValue == null || force) {
      final (err, res) = await (rush ? TierListApi().getRushRankings() : TierListApi().getPowerRankings()).toCatch;
      if (err != null) {
        setState(() {
          _pageStatus = PageStatus.fail;
        });
        return false;
      }

      list = res?.map(TierList_PowerRanking.fromJson).toList() ?? [];
      await MyHive.box.put(boxKey, TierList_PowerRanking_Expire(data: list, expire: DateTime.now().add(const Duration(hours: 6))));

      await Future<void>.delayed(const Duration(milliseconds: 300)).then((value) {
        '已刷新'.toast;
      });
    } else {
      try {
        final _value = hiveValue as TierList_PowerRanking_Expire;
        if (_value.expire.isBefore(DateTime.now())) {
          reRefreshFlag = true;
        }

        list = hiveValue.data ;
      } catch (e) {
        await MyHive.box.delete(boxKey);
        return true;
      }
    }

    final tier0 =
        TierListGroup(tier: 0, deckTypes: [], desc: 'The most successful Tournament Topping Decks, with power levels of at least 37.');
    final tier1 =
        TierListGroup(tier: 1, deckTypes: [], desc: 'The most successful Tournament Topping Decks, with power levels of at least 27.');
    final tier2 = TierListGroup(tier: 2, deckTypes: [], desc: 'Decks with power levels between 16 and 27.');
    final tier3 = TierListGroup(tier: 3, deckTypes: [], desc: 'Decks with power levels between 6 and 16.');

    for (var item in list) {
      if (item.tournamentPower >= 45) {
        tier0.deckTypes.add(TierList_TopTier(name: item.name, tier: 0, oid: item.oid)..power = item.tournamentPower);
        continue;
      }
      if (item.tournamentPower >= 27) {
        tier1.deckTypes.add(TierList_TopTier(name: item.name, tier: 1, oid: item.oid)..power = item.tournamentPower);
        continue;
      }
      if (item.tournamentPower >= 16) {
        tier2.deckTypes.add(TierList_TopTier(name: item.name, tier: 2, oid: item.oid)..power = item.tournamentPower);
        continue;
      }

      tier3.deckTypes.add(TierList_TopTier(name: item.name, tier: 3, oid: item.oid)..power = item.tournamentPower);
    }

    final List<TierListGroup> group = [];
    if (tier0.deckTypes.isNotEmpty) {
      group.add(tier0);
    }
    if (tier1.deckTypes.isNotEmpty) {
      group.add(tier1);
    }
    if (tier2.deckTypes.isNotEmpty) {
      group.add(tier2);
    }
    if (tier3.deckTypes.isNotEmpty) {
      group.add(tier3);
    }
    setState(() {
      _tierListGroup = group;
      _pageStatus = PageStatus.success;
    });

    return reRefreshFlag;
  }

  Future<void> fetchData({bool force = false}) async {
    if (_tierListType == TierListType.topTires) {
      final needReRefresh = await fetchTopTiers(force: force);
      if (needReRefresh) {
        await fetchTopTiers(force: true);
        return;
      }

      return;
    }

    var needReRefresh = await fetchPowerRankings(_tierListType == TierListType.rushRankings);
    if (needReRefresh) {
      await fetchPowerRankings(_tierListType == TierListType.rushRankings, force: true);
    }
  }

  Future<void> _handleRefresh() async {
    print('[_handleRefresh] 开始 $initFlag');
    await fetchData(force: initFlag);

    print('[_handleRefresh] 完成');

    if (!initFlag) {
      initFlag = true;
    }
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show(atTop: true);
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      notificationPredicate: (_) => _pageStatus != PageStatus.loading,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: _pageStatus == PageStatus.success ? 1 : 0,
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: _tierListGroup
                      .map(
                        (group) => Column(
                          children: [
                            const SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 102,
                                  height: 25,
                                  child: Image.asset(
                                    'assets/images/tier_${group.tier}${Get.isDarkMode ? '' : '_dark'}.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    group.desc,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: _tierListType != TierListType.topTires ? 3 : 4,
                                  ),
                                  itemCount: group.deckTypes.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return TierListItemView(
                                      deckType: group.deckTypes[index],
                                      showPower: _tierListType != TierListType.topTires,
                                      onTap: () => navigateToDeckTypeDetailPage(group.deckTypes[index]),
                                    );
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
