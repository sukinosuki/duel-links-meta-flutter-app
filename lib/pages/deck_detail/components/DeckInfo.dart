import 'dart:developer';

import 'package:duel_links_meta/components/MdCardItemView2.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/gen/assets.gen.dart';
import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/http/TopDeckApi.dart';
import 'package:duel_links_meta/pages/cards_viewpager/index.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/top_deck/TopDeck.dart';
import 'package:duel_links_meta/util/time_util.dart';
import 'package:flutter/material.dart';

import '../../../http/CardApi.dart';

class DeckInfo extends StatefulWidget {
  const DeckInfo({super.key, this.deckTypeId, this.topDeck, this.loadingVisible});

  final TopDeck? topDeck;
  final String? deckTypeId;
  final bool? loadingVisible;

  @override
  State<DeckInfo> createState() => _DeckInfoState();
}

class _DeckInfoState extends State<DeckInfo> {
  var _pageStatus = PageStatus.loading;

  bool get _loadingVisible => widget.loadingVisible ?? true;

  String? get deckTypeId => widget.deckTypeId;

  List<MdCard> _mainCards = [];
  List<MdCard> _mainSingularCards = [];
  List<MdCard> _extraCards = [];
  List<MdCard> _extraSingularCards = [];
  TopDeck? _topDeck;

  String formatToK(int number) {
    if (number >= 1000) {
      return '${(number / 1000).floor()}k';
    }

    return number.toString();
  }

  String get sampleDeckTournamentName {
    if (_topDeck == null) return '';

    if (_topDeck!.tournamentType == null) return '';

    return '${_topDeck!.tournamentType!.shortName} ${_topDeck!.tournamentType!.enumSuffix} ${_topDeck!.tournamentNumber}';
  }

  //
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

  //
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

  //
  Future<bool> init() async {
    final params = <String, String>{'limit': '1'};
    if (deckTypeId != null) {
      params['deckType'] = deckTypeId!;
      params['sort'] = '-tournamentType,-created';
      params[r'created[$gte'] = '(days-60)';
    }

    if (widget.topDeck != null) {
      params['url'] = widget.topDeck!.url ?? '';
    }

    final (topDeckErr, topDeck) = await TopDeckApi().getBreakdownSample(params).toCatch;

    if (topDeckErr != null || topDeck == null) {
      setState(() {
        _pageStatus = PageStatus.fail;
      });

      return false;
    }

    final mainCardIds = topDeck.main.map((e) => e.card.oid).toList();
    final extraCardIds = topDeck.extra.map((e) => e.card.oid).toList();
    mainCardIds.addAll(extraCardIds);

    // TODO: 第一次时可以批量获取card再存到本地，第二次时可以减少单独请求card次数
    // final idStrings = mainCardIds.join(',');

    // 从本地获取card

    // final cardsRes = await CardApi().getById(idStrings);
    // final cards = cardsRes.body!.map(MdCard.fromJson);

    log('mainCardIds length: ${mainCardIds.length}');
    final needFetchCardIds = <String>[];
    final cards = <MdCard>[];
    for (var i = 0; i < mainCardIds.length; i++) {
      final hiveData = await MyHive.box2.get('card:${mainCardIds[i]}') as MdCard?;
      if (hiveData == null) {
        log('hiveData为null, ${mainCardIds[i]}');
        needFetchCardIds.add(mainCardIds[i]);
      } else {
        cards.add(hiveData);
      }
    }
    if (needFetchCardIds.length > 0) {
      log('需要请求获取card ${needFetchCardIds}, length: ${needFetchCardIds.length}');
      final (cardsErr, cardsRes) = await CardApi().getById(needFetchCardIds.join(',')).toCatch;
      if (cardsRes != null) {
        cards.addAll(cardsRes);
        cardsRes.forEach((element) {
          MyHive.box2.put('card:${element.oid}', element);
        });
      }
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
      final card = id2CardMap[item.card.oid] ?? MdCard()
        ..oid = item.card.oid;
      mainSingularCards.add(card);

      var amount = item.amount;
      while (amount > 0) {
        mainCards.add(card);
        amount--;
      }
    });

    topDeck.extra.forEach((item) {
      final card = id2CardMap[item.card.oid] ?? MdCard()..oid = item.card.oid;
      extraSingularCards.add(card);

      var amount = item.amount;
      while (amount > 0) {
        extraCards.add(id2CardMap[item.card.oid] ?? MdCard()..oid = item.card.oid);
        amount--;
      }
    });

    setState(() {
      _pageStatus = PageStatus.success;
      _mainCards = mainCards;
      _topDeck = topDeck;
      _mainSingularCards = mainSingularCards;
      _extraCards = extraCards;
      _extraSingularCards = extraSingularCards;
    });

    return false;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _pageStatus == PageStatus.success ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: Column(
            children: [
              Wrap(
                children: [
                  Text(_topDeck?.tournamentPlacement.toString() ?? '', style: const TextStyle(fontSize: 12)),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('—', style: TextStyle(fontSize: 12))),
                  Text(sampleDeckTournamentName, style: const TextStyle(color: Color(0xff0a87bb), fontSize: 12)),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('—', style: TextStyle(fontSize: 12))),
                  if (_topDeck != null) Text(TimeUtil.format(_topDeck?.created), style: const TextStyle(fontSize: 12)),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('—', style: TextStyle(fontSize: 12))),
                  if (_topDeck != null)
                    Text(_topDeck!.author is String ? _topDeck!.author.toString() : '', style: const TextStyle(fontSize: 12))
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
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('+', style: TextStyle(fontSize: 11))),
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
                        Text(_topDeck?.skill?.name ?? '', style: const TextStyle(color: Color(0xff0a87bb), fontSize: 12)),
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
                margin: EdgeInsets.zero,
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
                      margin: EdgeInsets.zero,
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
          ),
        ),
        if (_loadingVisible && _pageStatus != PageStatus.success)
          const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}
