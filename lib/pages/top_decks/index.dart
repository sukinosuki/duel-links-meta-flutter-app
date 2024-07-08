import 'dart:developer';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/components/TopDeckItem.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/http/TopDeckApi.dart';
import 'package:duel_links_meta/pages/top_decks/components/TopDeckListView.dart';
import 'package:duel_links_meta/pages/top_decks/type/Group.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/top_deck/TopDeck.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TopDecksPage extends StatefulWidget {
  const TopDecksPage({super.key, required this.isRush});

  final bool isRush;

  @override
  State<TopDecksPage> createState() => _TopDecksPageState();
}

class _TopDecksPageState extends State<TopDecksPage> {
  PageStatus _pageStatus = PageStatus.loading;

  List<Group<TopDeck>> _topDeckGroups = [];
  List<Group<TopDeck>> _tournamentTypeTopDeckGroups = [];
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  var _init  = false;

  int? selectedTournamentType;

  DateTime now = DateTime.now();

  bool get _isRush => widget.isRush;

  final _tier2colorMap = <int, Color>{
    0: const Color(0xff446e96),
    1: const Color(0xff1d3e67),
    2: const Color(0xff446e96),
    3: const Color(0xff7b95b1),
  };

  void _handleTapTopDeckItem(Group<TopDeck> group) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
      ),
      // backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => TopDeckListView(topDecks: group.data),
    );
  }

  //
  Future<bool> fetchData({bool force = false}) async {
    final hiveDataKey = 'top_deck:list:${_isRush ? 'rush' : 'speed'}';
    final hiveRefreshKey = 'top_deck:list:${_isRush ? 'rush' : 'speed'}:refresh';

    final hiveData = await MyHive.box2.get(hiveDataKey) as List<dynamic>?;
    final hiveRefreshDate = await MyHive.box2.get(hiveRefreshKey) as DateTime?;
    var refreshFlag = false;

    var topDecks = <TopDeck>[];

    if (hiveData == null || force) {
      final params = <String, dynamic>{
        r'created[$gte]': '(days-28)',
        'fields': 'rankedType,deckType,created,tournamentType,gemsPrice,dollarsPrice',
        // 'fields': '-',
        'limit': '0',
        // r'rush[$ne]': _isRush ? 'true' : 'false',
        'rush': _isRush ? 'true' : 'false',
      };

      final (err, res) = await TopDeckApi().list(params).toCatch;
      if (err != null) {
        setState(() {
          _pageStatus = PageStatus.fail;
        });

        return false;
      }
      topDecks = res!;
      MyHive.box2.put(hiveDataKey, topDecks);
      MyHive.box2.put(hiveRefreshKey, DateTime.now());
    } else {
      await Future.delayed(const Duration(milliseconds: 200));
      try {
        topDecks = hiveData.map((e) => e as TopDeck).toList();
        if (hiveRefreshDate != null && hiveRefreshDate.add(const Duration(hours: 12)).isBefore(DateTime.now())) {
          refreshFlag = true;
        }
      } catch (e) {
        MyHive.box2.delete(hiveDataKey);
        MyHive.box2.delete(hiveRefreshKey);
      }
    }

    final countMap = <String, List<TopDeck>>{};
    topDecks.forEach((item) {
      if (countMap.containsKey(item.deckType.name)) {
        countMap[item.deckType.name]?.add(item);
      } else {
        countMap[item.deckType.name] = [item];
      }
    });

    final groups = <Group<TopDeck>>[];
    countMap.forEach((key, value) {
      value.sort((a, b) => b.created!.compareTo(a.created!));
      groups.add(Group(key: key, data: value));
    });

    groups.sort((a, b) {
      if (b.data.length == a.data.length) {
        return b.data[0].created!.compareTo(a.data[0].created!);
      }

      return b.data.length - a.data.length;
    });

    var tournamentTypeMap = <String, List<TopDeck>>{};
    List<Group<TopDeck>> tournamentTypeGroups = [];
    //
    topDecks.forEach((element) {
      if (element.rankedType != null) {
        if (tournamentTypeMap.containsKey(element.rankedType!.name)) {
          tournamentTypeMap[element.rankedType!.name]?.add(element);
        } else {
          tournamentTypeMap[element.rankedType!.name] = [element];
        }
      }

      if (element.tournamentType != null) {
        if (tournamentTypeMap.containsKey(element.tournamentType!.name)) {
          tournamentTypeMap[element.tournamentType!.name]?.add(element);
        } else {
          tournamentTypeMap[element.tournamentType!.name] = [element];
        }
      }
    });
    tournamentTypeMap.forEach((key, value) {
      log('key: $key, count: ${value.length}');

      tournamentTypeGroups.add(Group(key: key, data: value));
    });
    tournamentTypeGroups.sort((a, b) => a.key.compareTo(b.key));

    setState(() {
      // _topDecks = topDecks;
      _pageStatus = PageStatus.success;
      _topDeckGroups = groups;
      _tournamentTypeTopDeckGroups = tournamentTypeGroups;
    });

    return refreshFlag;
  }

  List<Group<TopDeck>> get _showTopDecks {
    if (selectedTournamentType == null) {
      return _topDeckGroups;
    }

    var res = _tournamentTypeTopDeckGroups[selectedTournamentType!].data;

    final countMap = <String, List<TopDeck>>{};
    res!.forEach((item) {
      if (countMap.containsKey(item.deckType.name)) {
        countMap[item.deckType.name]?.add(item);
      } else {
        countMap[item.deckType.name] = [item];
      }
    });

    final groups = <Group<TopDeck>>[];
    countMap.forEach((key, value) {
      value.sort((a, b) => b.created!.compareTo(a.created!));
      groups.add(Group(key: key, data: value));
    });

    groups.sort((a, b) {
      if (b.data.length == a.data.length) {
        return b.data[0].created!.compareTo(a.data[0].created!);
      }

      return b.data.length - a.data.length;
    });

    return groups;
  }

  void _handleFilter(int index) {
    setState(() {
      selectedTournamentType = selectedTournamentType == index ? null : index;
    });
  }

  Future<void> init() async {
    log('init ${_refreshIndicatorKey.currentState}');
    await Future.delayed(Duration(milliseconds: 10));

    _refreshIndicatorKey.currentState?.show(atTop: true);
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> _handleRefresh() async {
    log('触发下拉刷新');

    await fetchData(force: _init);
    _init = true;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Decks'),
        actions: [
          IconButton(onPressed: fetchData, icon: const Icon(Icons.refresh)),
          // IconButton(onPressed: _showFilterPopup, icon: const Icon(Icons.filter_list))
        ],
      ),
      body: Builder(builder: (context) {
       return RefreshIndicator(
          onRefresh: _handleRefresh,
          key: _refreshIndicatorKey,
          // notificationPredicate: (_) => _pageStatus != PageStatus.loading,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 4),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 8, left: 4, right: 4, bottom: 4),
                          itemCount: _tournamentTypeTopDeckGroups.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TopDeckItem(
                              topDeck: TopDeck()..deckType.name = _tournamentTypeTopDeckGroups[index].key,
                              isActive: index == selectedTournamentType,
                              bottomRight: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: const BoxDecoration(
                                  color: Color(0xc5dbe2dc),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                  ),
                                  border: BorderDirectional(
                                    top: BorderSide(color: Colors.white, width: 0.5),
                                    start: BorderSide(color: Colors.white, width: 0.5),
                                  ),
                                ),
                                child: Text(
                                  _tournamentTypeTopDeckGroups[index].data.length.toString(),
                                  // _topDeckGroups[index].data[0].created!.toLocal().format,
                                  style: const TextStyle(fontSize: 9),
                                ),
                              ),
                              coverUrl:
                              'https://wsrv.nl/?url=https://s3.duellinksmeta.com${_tournamentTypeTopDeckGroups[index].data[0].tournamentType?.icon ?? _tournamentTypeTopDeckGroups[index].data[0].rankedType?.icon}&w=100&output=webp&we&n=-1&maxage=7d',
                              onTap: () => _handleFilter(index),
                            );
                          },
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 8, left: 4, right: 4, bottom: 4),
                          itemCount: _showTopDecks.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 4, crossAxisSpacing: 0, mainAxisSpacing: 0),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                TopDeckItem(
                                  onTap: () => _handleTapTopDeckItem(_showTopDecks[index]),
                                  topDeck: _showTopDecks[index].data[0],
                                  bottomRight: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    decoration: const BoxDecoration(
                                      color: Color(0xc5dbe2dc),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                      ),
                                      border: BorderDirectional(
                                        top: BorderSide(color: Colors.white, width: 0.5),
                                        start: BorderSide(color: Colors.white, width: 0.5),
                                      ),
                                    ),
                                    child: Text(
                                      _showTopDecks[index].data.length.toString(),
                                      style: const TextStyle(fontSize: 9),
                                    ),
                                  ),
                                  isNew: now.difference(_showTopDecks[index].data[0].created!.toLocal()).inHours < 72,
                                  topLeft: _showTopDecks[index].data[0].deckType.tier != null
                                      ? Container(
                                    width: 20,
                                    height: 19,
                                    decoration: BoxDecoration(
                                      color: _tier2colorMap[_showTopDecks[index].data[0].deckType.tier!] ?? Colors.white,
                                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(4)),
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        width: 13,
                                        child: Image.asset(
                                          'assets/images/tier_m_${_showTopDecks[index].data[0].deckType.tier}.webp',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  )
                                      : null,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    Opacity(
                      opacity: _pageStatus == PageStatus.fail ? 1 : 0,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - (Scaffold.of(context)?.appBarMaxHeight ?? 0),
                        child: const Center(child: Text('加载失败')),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
