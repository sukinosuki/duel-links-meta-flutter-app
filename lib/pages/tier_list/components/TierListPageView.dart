import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/http/TierListApi.dart';
import 'package:duel_links_meta/pages/tier_list/components/TierListItemView.dart';
import 'package:duel_links_meta/pages/tier_list/type/TierListGroup.dart';
import 'package:duel_links_meta/pages/tier_list/type/TierListType.dart';
import 'package:duel_links_meta/type/TierList_TopTier.dart';
import 'package:duel_links_meta/type/deck_type/TierList_PowerRanking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../type/enum/PageStatus.dart';

class TierListView extends StatefulWidget {
  const TierListView({
    super.key,
    required this.tierListType,
  });

  final TierListType tierListType;

  @override
  State<TierListView> createState() => _TierListViewState();
}

class _TierListViewState extends State<TierListView> with AutomaticKeepAliveClientMixin {
  List<TierListGroup> _tierListGroup = [];

  // @override
  get _tierListType => widget.tierListType;

  var _pageStatus = PageStatus.loading;

  fetchTopTiers() async {
    var tierDescMap = {
      0: '',
      1: 'Expected to be a large percentage of the top cut in a competitive tournament.*',
      2: 'Expected to be in the top cut of a competitive tournament, but not a large percentage.*',
      3: 'Expected to be played in a competitive tournament, with the possibility of being in the top cut.*',
    };
    var res = await TierListApi().getTopTiers();
    var list = res.body?.map((e) => TierList_TopTier.fromJson(e)).toList() ?? [];

    var tier2DeckTypesMap = <int, List<TierList_TopTier>>{};
    for (var item in list) {
      if (tier2DeckTypesMap[item.tier] != null) {
        tier2DeckTypesMap[item.tier]?.add(item);
      } else {
        tier2DeckTypesMap[item.tier] = [item];
      }
    }

    List<TierListGroup> _list = [];
    tier2DeckTypesMap.forEach((key, value) {
      _list.add(TierListGroup(tier: key, deckTypes: value, desc: tierDescMap[key] ?? ''));
    });

    _list.sort((a, b) => a.tier.compareTo(b.tier));
    setState(() {
      _tierListGroup = _list;
      _pageStatus = PageStatus.success;
    });
  }

  fetchPowerRankings(bool rush) async {
    var res = await (rush ? TierListApi().getRushRankings() : TierListApi().getPowerRankings());

    var list = res.body?.map((e) => TierList_PowerRanking.fromJson(e)).toList() ?? [];
    TierListGroup tier0 = TierListGroup(
        tier: 0,
        deckTypes: [],
        desc: 'The most successful Tournament Topping Decks, with power levels of at least 37.');
    TierListGroup tier1 = TierListGroup(
        tier: 1,
        deckTypes: [],
        desc: 'The most successful Tournament Topping Decks, with power levels of at least 27.');
    TierListGroup tier2 = TierListGroup(tier: 2, deckTypes: [], desc: 'Decks with power levels between 16 and 27.');
    TierListGroup tier3 = TierListGroup(tier: 3, deckTypes: [], desc: 'Decks with power levels between 6 and 16.');

    for (var item in list) {
      print('${item.name}, power: ${item.tournamentPower}');
      if (item.tournamentPower > 37) {
        tier0.deckTypes.add(TierList_TopTier(name: item.name, tier: 0, oid: item.oid)..power = item.tournamentPower);
        continue;
      }
      if (item.tournamentPower > 27) {
        tier1.deckTypes.add(TierList_TopTier(name: item.name, tier: 1, oid: item.oid)..power = item.tournamentPower);
        continue;
      }
      if (item.tournamentPower > 16) {
        tier2.deckTypes.add(TierList_TopTier(name: item.name, tier: 2, oid: item.oid)..power = item.tournamentPower);
        continue;
      }

      tier3.deckTypes.add(TierList_TopTier(name: item.name, tier: 3, oid: item.oid)..power = item.tournamentPower);
    }

    List<TierListGroup> group = [];
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
  }

  fetchData() async {
    if (_tierListType == TierListType.topTires) return fetchTopTiers();

    if (_tierListType == TierListType.powerRankings) return fetchPowerRankings(false);

    if (_tierListType == TierListType.rushRankings) return fetchPowerRankings(true);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    print('TierListView build');
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _pageStatus == PageStatus.success ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Column(
                  children: _tierListGroup
                      .map((group) => Column(
                            children: [
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 102,
                                    height: 25,
                                    child: Image.asset('assets/images/tier_${group.tier}.webp', fit: BoxFit.cover),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(group.desc??'', style: const TextStyle(color: Colors.white, fontSize: 12),),
                                  ),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        childAspectRatio: 3),
                                    itemCount: group.deckTypes.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return TierListItemView(
                                        deckType: group.deckTypes[index],
                                        showPower: _tierListType != TierListType.topTires,
                                      );
                                    },
                                  )
                                ],
                              )
                            ],
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        if (_pageStatus == PageStatus.loading) const Positioned.fill(child: Center(child: Loading()))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
