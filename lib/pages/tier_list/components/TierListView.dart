import 'dart:developer';

import 'package:duel_links_meta/api/TierListApi.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/db/PowerRankingsHiveDb.dart';
import 'package:duel_links_meta/hive/db/TierListHiveDb.dart';
import 'package:duel_links_meta/pages/deck_type_detail/index.dart';
import 'package:duel_links_meta/pages/tier_list/components/TierListItemView.dart';
import 'package:duel_links_meta/pages/tier_list/type/TierListGroup.dart';
import 'package:duel_links_meta/pages/tier_list/type/TierListType.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/tier_list_top_tier/TierList_TopTier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class TierListView extends StatefulWidget {
  const TierListView({required this.tierListType, super.key, this.minHeight});

  final TierListType tierListType;
  final double? minHeight;

  @override
  State<TierListView> createState() => _TierListViewState();
}

class _TierListViewState extends State<TierListView> with AutomaticKeepAliveClientMixin {
  List<TierListGroup> _tierListGroup = [];
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  TierListType get _tierListType => widget.tierListType;
  bool _isInit = false;
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
    var list = await TierListHiveDb().get();
    final expireTime = await TierListHiveDb().getExpireTime();
    var reRefreshFlag = false;

    if (list == null || force) {
      final (err, res) = await TierListApi().getTopTiers().toCatch;

      if (err != null || res == null) {
        if (list == null) {
          setState(() {
            _pageStatus = PageStatus.fail;
          });
        }
        return false;
      }

      list = res;
      await TierListHiveDb().set(list);
      await TierListHiveDb().setExpireTime(DateTime.now().add(const Duration(days: 1)));
    } else {
      reRefreshFlag = expireTime == null || expireTime.isBefore(DateTime.now());
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

    setState(() {
      _tierListGroup = _list;
      _pageStatus = PageStatus.success;
    });

    return reRefreshFlag;
  }

  //
  Future<bool> fetchPowerRankings(bool rush, {bool force = false}) async {
    var list = await PowerRankingsHiveDb().get(isRush: rush);
    final expireTime = await PowerRankingsHiveDb().getExpireTime(isRush: rush);

    var reRefreshFlag = false;

    if (list == null || force) {
      final (err, res) = await (rush ? TierListApi().getRushRankings() : TierListApi().getPowerRankings()).toCatch;
      if (err != null || res == null) {
        if (list == null) {
          setState(() {
            _pageStatus = PageStatus.fail;
          });
        }
        return false;
      }

      list = res;

      await PowerRankingsHiveDb().set(list, isRush: rush);
      await PowerRankingsHiveDb().setExpireTime(DateTime.now().add(const Duration(days: 1)), isRush: rush);
    } else {
      reRefreshFlag = expireTime == null || expireTime.isBefore(DateTime.now());
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

  //
  Future<void> fetchData({bool force = false}) async {
    if (_tierListType == TierListType.topTires) {
      final needReRefresh = await fetchTopTiers(force: force);
      if (needReRefresh) {
        await fetchTopTiers(force: true);
      }
    } else {
      final needReRefresh = await fetchPowerRankings(_tierListType == TierListType.rushRankings);
      if (needReRefresh) {
        await fetchPowerRankings(_tierListType == TierListType.rushRankings, force: true);
      }
    }
  }

  Future<void> _handleRefresh() async {
    await fetchData(force: _isInit);

    _isInit = true;
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
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
        child: Stack(
          children: [
            Opacity(
              opacity: _pageStatus == PageStatus.success ? 1 : 0,
              child: ListView.builder(
                  itemCount: _tierListGroup.length,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 102,
                              height: 25,
                              child: Image.asset(
                                'assets/images/tier_${_tierListGroup[index].tier}${Get.isDarkMode ? '' : '_dark'}.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                _tierListGroup[index].desc,
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
                              itemCount: _tierListGroup[index].deckTypes.length,
                              itemBuilder: (BuildContext context, int _index) {
                                return TierListItemView(
                                  deckType: _tierListGroup[index].deckTypes[_index],
                                  showPower: _tierListType != TierListType.topTires,
                                  onTap: () => navigateToDeckTypeDetailPage(_tierListGroup[index].deckTypes[_index]),
                                );
                              },
                            )
                          ],
                        )
                      ],
                    );
                  }),
            ),
            if (_pageStatus == PageStatus.fail)
              const Positioned.fill(
                  child: Center(
                child: Text('Loading failed'),
              ))
          ],
        ));
  }
}
