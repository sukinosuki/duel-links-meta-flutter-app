import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/components/MdCardItemView.dart';
import 'package:duel_links_meta/components/MdCardsBoxLayout.dart';
import 'package:duel_links_meta/constant/colors.dart';
import 'package:duel_links_meta/http/CardApi.dart';
import 'package:duel_links_meta/http/DeckTypeApi.dart';
import 'package:duel_links_meta/http/TopDeckApi.dart';
import 'package:duel_links_meta/pages/deck_type_detail/components/DeckTypeBreakdownGridView.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/deck_type/DeckType.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/top_deck/TopDeck.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class DeckTypeDetailPage extends StatefulWidget {
  const DeckTypeDetailPage({super.key, this.name = 'Shiranui'});

  final String name;

  @override
  State<DeckTypeDetailPage> createState() => _DeckTypeDetailPageState();
}

class _DeckTypeDetailPageState extends State<DeckTypeDetailPage> {
  get _deckTypeName => widget.name;

  bool isExtraCard(List<String> monsterType) {
    if (monsterType.contains('Link')) return true;
    if (monsterType.contains('Xyz')) return true;
    if (monsterType.contains('Fusion')) return true;
    if (monsterType.contains('Synchro')) return true;

    return false;
  }

  String formatToK(int number) {
    if (number >= 1000) {
      return (number / 1000).floor().toString() + 'k';
    }

    return number.toString();
  }

  DeckType? _deckType;
  TopDeck? _topDeck;
  List<MdCard> _mainCards = [];
  List<MdCard> _extraCards = [];
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

  fetchDeckType() async {
    setState(() {
      _deckType = null;
    });

    var res = await DeckTypeApi().getDetailByName(_deckTypeName);
    var deckTpe = res.body!;

    var topDeckRes = await TopDeckApi().getBreakdownSample(deckTpe.oid);
    var topDeck = topDeckRes.body!;

    var mainCardIds = topDeck.main.map((e) => e.card.oid).toList();
    var extraCardIds = topDeck.extra.map((e) => e.card.oid).toList();
    mainCardIds.addAll(extraCardIds);
    var idStrings = mainCardIds.join(',');

    var cardsRes = await CardApi().getById(idStrings);
    var cards = cardsRes.body!.map((e) => MdCard.fromJson(e));

    Map<String, MdCard> id2CardMap = {};
    cards.forEach((item) {
      id2CardMap[item.oid] = item;
    });
    List<MdCard> mainCards = [];
    List<MdCard> extraCards = [];
    topDeck.main.forEach((item) {
      var amount = item.amount;
      while (amount > 0) {
        mainCards.add(id2CardMap[item.card.oid]!);
        amount--;
      }
    });
    topDeck.extra.forEach((item) {
      var amount = item.amount;
      while (amount > 0) {
        extraCards.add(id2CardMap[item.card.oid]!);
        amount--;
      }
    });

    setState(() {
      _deckType = deckTpe;
      _topDeck = topDeck;
      _pageStatus = PageStatus.success;
      _mainCards = mainCards;
      _extraCards = extraCards;
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
      backgroundColor: BaColors.theme,
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: fetchDeckType,
              child: Stack(
                children: [
                  Container(
                    height: 240,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        ClipRRect(
                          child: ImageFiltered(
                            // filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            // enabled: false,
                            child: CachedNetworkImage(
                              width: double.infinity,
                              imageUrl: 'https://imgserv.duellinksmeta.com/v2/dlm/deck-type/$_deckTypeName?portrait=true&width=420',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [BaColors.theme, BaColors.theme.withOpacity(0)]),
                            ),
                          ),
                        ),
                        // Positioned(
                        //     bottom: 100,
                        //     left: 0,
                        //     right: 0,
                        //     child: Container(
                        //       // color: Colors.white10,
                        //       padding: const EdgeInsets.only(left: 8, bottom: 18),
                        //       child: Text(
                        //         _deckTypeName,
                        //         style: const TextStyle(color: Colors.white, fontSize: 26),
                        //       ),
                        //     ))
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AppBar(
                      title: Text('Blue-Eyes'),
                      actions: [IconButton(onPressed: fetchDeckType, icon: Icon(Icons.refresh))],
                    ),
                  )
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(0, -120),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _deckTypeName,
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        const Text('Average size: ', style: TextStyle(color: Colors.white, fontSize: 12)),
                        Text(_deckType?.deckBreakdown.avgMainSize.toString() ?? '', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 3),
                        const Text('cards', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Top Main Deck', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    DeckTypeBreakdownGridView(cards: breakdownCards, crossAxisCount: 6),
                    const SizedBox(height: 20),
                    const Text('Top Extra Deck', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    DeckTypeBreakdownGridView(
                      cards: breakdownExtraCards,
                      crossAxisCount: 6,
                    ),
                    const SizedBox(height: 10),
                    const Text('Popular Skills', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                    Column(
                      children: _deckType?.deckBreakdown.skills
                              .where((item) => ((item.count) / _deckType!.deckBreakdown.total).round() > 0)
                              .map((skill) => InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      child: Row(
                                        children: [
                                          Text(skill.name, style: const TextStyle(color: Color(0xff0a87bb))),
                                          Text(': ${(skill.count * 100 / _deckType!.deckBreakdown.total).toStringAsFixed(0)}%',
                                              style: const TextStyle(color: Colors.white, fontSize: 12))
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList() ??
                          [],
                    ),
                    const SizedBox(height: 20),
                    const Text('Sample Deck', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                    Wrap(
                      children: [
                        Text(_topDeck?.tournamentPlacement.toString() ?? '', style: const TextStyle(color: Colors.white, fontSize: 12)),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('—', style: TextStyle(color: Colors.white, fontSize: 12))),
                        Text(sampleDeckTournamentName, style: const TextStyle(color: Color(0xff0a87bb), fontSize: 12)),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('—', style: TextStyle(color: Colors.white, fontSize: 12))),
                        if (_topDeck != null) Text(DateFormat.yMMMMd().format(_topDeck!.created!), style: const TextStyle(color: Colors.white, fontSize: 12)),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('—', style: TextStyle(color: Colors.white, fontSize: 12))),
                        if (_topDeck != null) Text(_topDeck!.author is String ? _topDeck!.author : '', style: const TextStyle(color: Colors.white, fontSize: 12))
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 80,
                          child: Row(
                            children: [
                              Image.asset('assets/images/icon_gem.webp', width: 12, height: 12),
                              const SizedBox(width: 4),
                              Text(formatToK(_topDeck?.gemsPrice ?? 0), style: const TextStyle(color: Colors.white, fontSize: 11)),
                              const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('+', style: const TextStyle(color: Colors.white, fontSize: 11))),
                              Text('\$${_topDeck?.dollarsPrice.toString() ?? '0'}', style: const TextStyle(color: Colors.white, fontSize: 11)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/images/icon_skill_2.webp', width: 14, height: 14),
                              Text(_topDeck?.skill.name ?? '', style: const TextStyle(color: Color(0xff0a87bb), fontSize: 12)),
                            ],
                          ),
                        ),
                        Container(
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  _topDeck?.main.map((e) => e.amount).reduce((a, b) => a + b).toString() ?? '',
                                  style: TextStyle(color: Colors.white, fontSize: 11),
                                ),
                              ],
                            ))
                      ],
                    ),
                    SizedBox(height: 10),
                    MdCardsBoxLayout(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 0, crossAxisSpacing: 6, childAspectRatio: 0.55),
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _mainCards.length,
                        itemBuilder: (context, index) {
                          return MdCardItemView(
                            mdCard: _mainCards[index],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    MdCardsBoxLayout(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8, mainAxisSpacing: 0, crossAxisSpacing: 6, childAspectRatio: 0.55),
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _extraCards.length,
                        itemBuilder: (context, index) {
                          return MdCardItemView(
                            mdCard: _extraCards[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
