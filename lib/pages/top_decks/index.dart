import 'package:duel_links_meta/components/TopDeckItem.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/db/TopDeckHiveDb.dart';
import 'package:duel_links_meta/http/TopDeckApi.dart';
import 'package:duel_links_meta/pages/deck_detail/index.dart';
import 'package:duel_links_meta/pages/top_decks/components/TopDeckListView.dart';
import 'package:duel_links_meta/pages/top_decks/type/Group.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/top_deck/TopDeck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TopDecksPage extends StatefulWidget {
  const TopDecksPage({required this.isRush, super.key});

  final bool isRush;

  @override
  State<TopDecksPage> createState() => _TopDecksPageState();
}

class _TopDecksPageState extends State<TopDecksPage> {
  PageStatus _pageStatus = PageStatus.loading;

  List<Group<TopDeck>> _topDeckGroups = [];
  List<Group<TopDeck>> _tournamentTypeTopDeckGroups = [];
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  var _isInit = false;

  int? selectedTournamentType;

  final DateTime _now = DateTime.now();

  bool get _isRush => widget.isRush;

  final _tier2colorMap = <int, Color>{
    0: const Color(0xff446e96),
    1: const Color(0xff1d3e67),
    2: const Color(0xff446e96),
    3: const Color(0xff7b95b1),
    4: const Color(0xffbd5a44),
  };

  //
  void _handleTapTopDeckItem(Group<TopDeck> group) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => TopDeckListView(
        topDecks: group.data,
        onTap: (topDeck) => {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => DeckDetailPage(topDeck: topDeck)),
          ),
        },
      ),
    );
  }

  //
  Future<bool> fetchData({bool force = false}) async {
    var topDecks = await TopDeckHiveDb().get(isRush: _isRush);
    final expireTime = await TopDeckHiveDb().getExpireTime(isRush: _isRush);
    var refreshFlag = false;

    if (topDecks == null || force) {
      final params = <String, dynamic>{
        r'created[$gte]': '(days-28)',
        'fields': 'rankedType,deckType,created,tournamentType,gemsPrice,dollarsPrice,url,skill',
        'limit': '0',
        'rush': _isRush ? 'true' : 'false',
        // 'fields': '-',
        // r'rush[$ne]': _isRush ? 'true' : 'false',
      };

      final (err, res) = await TopDeckApi().list(params).toCatch;
      if (err != null || res == null) {
        if (topDecks == null) {
          setState(() {
            _pageStatus = PageStatus.fail;
          });
        }

        return false;
      }

      topDecks = res;
      await TopDeckHiveDb().set(topDecks, isRush: _isRush);
      await TopDeckHiveDb().setExpireTime(DateTime.now().add(const Duration(days: 1)), isRush: _isRush);
    } else {
      refreshFlag = expireTime == null || expireTime.isBefore(DateTime.now());
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

    final tournamentTypeMap = <String, List<TopDeck>>{};
    final tournamentTypeGroups = <Group<TopDeck>>[];

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
      tournamentTypeGroups.add(Group(key: key, data: value));
    });
    tournamentTypeGroups.sort((a, b) => a.key.compareTo(b.key));

    setState(() {
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

    final res = _tournamentTypeTopDeckGroups[selectedTournamentType!].data;

    final countMap = <String, List<TopDeck>>{};
    res.forEach((item) {
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
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> _handleRefresh() async {
    final shouldRefresh = await fetchData(force: _isInit);
    _isInit = true;
    if (shouldRefresh) {
      await fetchData(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Decks'),
      ),
      body: Builder(
        builder: (context) {
          return RefreshIndicator(
            onRefresh: _handleRefresh,
            key: _refreshIndicatorKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Stack(
                    children: [
                      AnimatedOpacity(
                        opacity: _pageStatus == PageStatus.success ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Column(
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
                                      style: const TextStyle(fontSize: 9, color: Colors.black54),
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
                                crossAxisCount: 2,
                                childAspectRatio: 4,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                              ),
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
                                          style: const TextStyle(fontSize: 9, color: Colors.black54),
                                        ),
                                      ),
                                      isNew: _now.difference(_showTopDecks[index].data[0].created!.toLocal()).inHours < 72,
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
                      ),
                      Opacity(
                        opacity: _pageStatus == PageStatus.fail ? 1 : 0,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - (Scaffold.of(context).appBarMaxHeight ?? 0),
                          child: const Center(child: Text('Loading failed')),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
