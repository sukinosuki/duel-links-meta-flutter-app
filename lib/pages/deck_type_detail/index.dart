import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/components/MdCardItemView.dart';
import 'package:duel_links_meta/components/MdCardItemView2.dart';
import 'package:duel_links_meta/components/SkillModalView.dart';
import 'package:duel_links_meta/constant/colors.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/gen/assets.gen.dart';
import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/http/CardApi.dart';
import 'package:duel_links_meta/http/DeckTypeApi.dart';
import 'package:duel_links_meta/http/TopDeckApi.dart';
import 'package:duel_links_meta/pages/cards_viewpager/index.dart';
import 'package:duel_links_meta/pages/deck_type_detail/components/DeckTypeBreakdownGridView.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/deck_type/DeckType.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/top_deck/TopDeck.dart';
import 'package:duel_links_meta/util/time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeckTypeDetailPage extends StatefulWidget {
  const DeckTypeDetailPage({super.key, required this.name});

  final String name;

  @override
  State<DeckTypeDetailPage> createState() => _DeckTypeDetailPageState();
}

class _DeckTypeDetailPageState extends State<DeckTypeDetailPage> {
  String get _deckTypeName => widget.name;

  bool isExtraCard(List<String> monsterType) {
    if (monsterType.contains('Link')) return true;
    if (monsterType.contains('Xyz')) return true;
    if (monsterType.contains('Fusion')) return true;
    if (monsterType.contains('Synchro')) return true;

    return false;
  }

  String formatToK(int number) {
    if (number >= 1000) {
      return '${(number / 1000).floor()}k';
    }

    return number.toString();
  }

  DeckType? _deckType;
  TopDeck? _topDeck;
  List<MdCard> _mainCards = [];
  List<MdCard> _mainSingularCards = [];
  List<MdCard> _extraCards = [];
  List<MdCard> _extraSingularCards = [];
  var _pageStatus = PageStatus.loading;

  List<DeckType_DeckBreakdownCards> get breakdownCards {
    if (_deckType == null) {
      return [];
    }

    return _deckType!.deckBreakdown.cards.where((item) => !isExtraCard(item.card.monsterType)).toList();
  }

  List<DeckType_DeckBreakdownCards> get breakdownExtraCards {
    if (_deckType == null) {
      return [];
    }

    return _deckType!.deckBreakdown.cards.where((item) => isExtraCard(item.card.monsterType)).toList();
  }

  String get sampleDeckTournamentName {
    if (_topDeck == null) return '';

    if (_topDeck!.tournamentType == null) return '';

    return '${_topDeck!.tournamentType!.shortName} ${_topDeck!.tournamentType!.enumSuffix} ${_topDeck!.tournamentNumber}';
  }

  void handleTapSkill(DeckType_DeckBreakdown_Skill skill) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black.withOpacity(0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SkillModalView(name: skill.name),
        ),
      ),
    );
  }

  void handleTapSampleDeckCard(int index) {
    final id = _mainCards[index].oid;

    final index0 = _mainSingularCards.indexWhere((element) => element.oid == id);

    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black87.withOpacity(0.3),
        child: CardsViewpagerPage(cards: _mainSingularCards, index: index0),
      ),
    );
  }

  void handleTapSampleDeckExtraCard(int index) {
    final id = _extraCards[index].oid;

    final cardIndex = _extraSingularCards.indexWhere((element) => element.oid == id);

    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black87.withOpacity(0.3),
        child: CardsViewpagerPage(cards: _extraSingularCards, index: cardIndex),
      ),
    );
  }

  Future<void> fetchDeckType({bool force = false}) async {
    // setState(() {
    //   _deckType = null;
    //   _pageStatus = PageStatus.loading;
    // });

    var deckTypeKey = 'deck_type:$_deckTypeName';
    var deckTypeFetchDateKey = 'deck_type_fetch_date:${_deckTypeName}';
    var hiveData = await MyHive.box2.get(deckTypeKey) as DeckType?;
    var hiveDataExpire = await MyHive.box2.get(deckTypeFetchDateKey) as DateTime?;

    DeckType? deckType;
    if (hiveData == null || force) {
      log('本地没数据，请求获取 ${hiveData}');
      final (err, __deckType) = await DeckTypeApi().getDetailByName(_deckTypeName).toCatch;
      if (err != null) {
        setState(() {
          _pageStatus = PageStatus.fail;
        });

        return;
      }
      deckType = __deckType;
      MyHive.box2.put(deckTypeKey, __deckType);
    } else {
      log('从本地获取数据');
      try {
        deckType = hiveData as DeckType;
        log('deckType.toJson(): ${deckType.toJson()}');
      } catch (e) {
        log('转换失败');
        MyHive.box2.delete(deckTypeKey);
        MyHive.box2.delete(deckTypeFetchDateKey);
      }
    }
    // final deckTpe = res.body!;

    final topDeckRes = await TopDeckApi().getBreakdownSample(deckType!.oid);
    final topDeck = topDeckRes.body!;

    final mainCardIds = topDeck.main.map((e) => e.card.oid).toList();
    final extraCardIds = topDeck.extra.map((e) => e.card.oid).toList();
    mainCardIds.addAll(extraCardIds);
    final idStrings = mainCardIds.join(',');

    // 从本地获取card

    // final cardsRes = await CardApi().getById(idStrings);
    // final cards = cardsRes.body!.map(MdCard.fromJson);
    List<MdCard> cards = [];
    for (var i = 0; i < mainCardIds.length; i++) {
      var hiveData = await MyHive.box2.get('card:${mainCardIds[i]}') as MdCard?;
      if (hiveData == null) {}
      cards.add(hiveData ?? MdCard()
        ..oid = mainCardIds[i]);
    }

    final id2CardMap = <String, MdCard>{};
    cards.forEach((item) {
      id2CardMap[item.oid] = item;
    });
    final mainCards = <MdCard>[];
    final mainSingularCards = <MdCard>[];
    final extraCards = <MdCard>[];
    final extraSingularCards = <MdCard>[];

    topDeck.main.forEach((item) {
      final card = id2CardMap[item.card.oid]!;
      mainSingularCards.add(card);

      var amount = item.amount;
      while (amount > 0) {
        mainCards.add(card);
        amount--;
      }
    });
    topDeck.extra.forEach((item) {
      final card = id2CardMap[item.card.oid]!;
      extraSingularCards.add(card);

      var amount = item.amount;
      while (amount > 0) {
        extraCards.add(id2CardMap[item.card.oid]!);
        amount--;
      }
    });

    setState(() {
      _deckType = deckType;
      _topDeck = topDeck;
      _pageStatus = PageStatus.success;
      _mainCards = mainCards;
      _mainSingularCards = mainSingularCards;
      _extraCards = extraCards;
      _extraSingularCards = extraSingularCards;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDeckType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            // padding: EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                Stack(
                  children: [
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: CachedNetworkImage(
                                width: double.infinity,
                                imageUrl: 'https://imgserv.duellinksmeta.com/v2/dlm/deck-type/$_deckTypeName?portrait=true&width=50',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  // colors: [Theme.of(context).colorScheme.background, BaColors.theme.withOpacity(0)]),
                                  colors: [Colors.white, Colors.white.withOpacity(0)]),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 200,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_deckTypeName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                                AnimatedOpacity(
                                  opacity: _pageStatus == PageStatus.success ? 1 : 0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Row(
                                    children: [
                                      const Text('Average size: ', style: TextStyle(fontSize: 12)),
                                      Text(_deckType?.deckBreakdown.avgMainSize.toString() ?? '',
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                      const SizedBox(width: 3),
                                      const Text('cards', style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    AnimatedOpacity(
                      opacity: _pageStatus == PageStatus.success ? 1 : 0,
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: _pageStatus == PageStatus.success
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 140,),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Text('Top Main Deck', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                  ),
                                  const SizedBox(height: 10),
                                  DeckTypeBreakdownGridView(cards: breakdownCards, crossAxisCount: 6),
                                  if (breakdownExtraCards.isNotEmpty)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        const Text('Top Extra Deck', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 10),
                                        DeckTypeBreakdownGridView(cards: breakdownExtraCards, crossAxisCount: 6),
                                      ],
                                    ),
                                  const SizedBox(height: 10),
                                  const Text('Popular Skills', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                  Column(
                                    children: _deckType?.deckBreakdown.skills
                                            .where((item) => ((item.count) / _deckType!.deckBreakdown.total).round() > 0)
                                            .map((skill) => InkWell(
                                                  onTap: () => handleTapSkill(skill),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                                    child: Row(
                                                      children: [
                                                        Text(skill.name, style: const TextStyle(color: Color(0xff0a87bb))),
                                                        Text(
                                                            ': ${(skill.count * 100 / _deckType!.deckBreakdown.total).toStringAsFixed(0)}%',
                                                            style: const TextStyle(fontSize: 12))
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                            .toList() ??
                                        [],
                                  ),
                                  const SizedBox(height: 20),
                                  const Text('Sample Deck', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                  Wrap(
                                    children: [
                                      Text(_topDeck?.tournamentPlacement.toString() ?? '', style: const TextStyle(fontSize: 12)),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 4), child: Text('—', style: TextStyle(fontSize: 12))),
                                      Text(sampleDeckTournamentName, style: const TextStyle(color: Color(0xff0a87bb), fontSize: 12)),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 4), child: Text('—', style: TextStyle(fontSize: 12))),
                                      if (_topDeck != null) Text(TimeUtil.format(_topDeck?.created), style: const TextStyle(fontSize: 12)),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 4), child: Text('—', style: TextStyle(fontSize: 12))),
                                      if (_topDeck != null)
                                        Text(_topDeck!.author is String ? _topDeck!.author.toString() : '',
                                            style: const TextStyle(fontSize: 12))
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Row(
                                          children: [
                                            Assets.images.iconGem.image(width: 13, height: 13),
                                            const SizedBox(width: 4),
                                            Text(formatToK(_topDeck?.gemsPrice ?? 0), style: const TextStyle(fontSize: 11)),
                                            const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 4),
                                                child: Text('+', style: TextStyle(fontSize: 11))),
                                            Text('\$${_topDeck?.dollarsPrice.toString() ?? '0'}', style: const TextStyle(fontSize: 11)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Assets.images.iconSkill2.image(width: 15, height: 15),
                                            const SizedBox(width: 2),
                                            Text(_topDeck?.skill.name ?? '',
                                                style: const TextStyle(color: Color(0xff0a87bb), fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          width: 80,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                _topDeck?.main.map((e) => e.amount).reduce((a, b) => a + b).toString() ?? '',
                                                style: const TextStyle(fontSize: 11),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    margin: const EdgeInsets.all(0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                                      child: GridView.builder(
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 5, mainAxisSpacing: 0, crossAxisSpacing: 8, childAspectRatio: 0.57),
                                        padding: const EdgeInsets.all(0),
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: _mainCards.length,
                                        itemBuilder: (context, index) {
                                          return MdCardItemView2(
                                            onTap: (card) => handleTapSampleDeckCard(index),
                                            mdCard: _mainCards[index],
                                            id: _mainCards[index].oid,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  if (_extraCards.isNotEmpty)
                                    Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        Card(
                                          margin: const EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                                            child: GridView.builder(
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 8, mainAxisSpacing: 0, crossAxisSpacing: 8, childAspectRatio: 0.53),
                                              padding: const EdgeInsets.all(0),
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: _extraCards.length,
                                              itemBuilder: (context, index) {
                                                return MdCardItemView2(
                                                  onTap: (card) => handleTapSampleDeckExtraCard(index),
                                                  mdCard: _extraCards[index],
                                                  id: _extraCards[index].oid,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ],
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_pageStatus == PageStatus.loading) const Positioned.fill(child: Center(child: Loading()))
        ],
      ),
    );
  }
}
