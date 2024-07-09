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
import 'package:duel_links_meta/pages/deck_detail/components/DeckInfo.dart';
import 'package:duel_links_meta/pages/deck_type_detail/components/DeckTypeBreakdownGridView.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/deck_type/DeckType.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/top_deck/TopDeck.dart';
import 'package:duel_links_meta/util/time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

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

  DeckType? _deckType;

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

  //
  Future<bool> fetchDeckType({bool force = false}) async {
    final hiveDeckTypeKey = 'deck_type:$_deckTypeName';
    final hiveDeckTypeFetchDateKey = 'deck_type_fetch_date:$_deckTypeName';
    var deckType = await MyHive.box2.get(hiveDeckTypeKey) as DeckType?;
    final hiveDataExpire = await MyHive.box2.get(hiveDeckTypeFetchDateKey) as DateTime?;
    Exception? err;

    var refreshFlag = false;

    if (deckType == null || force) {
      (err, deckType) = await DeckTypeApi().getDetailByName(_deckTypeName).toCatch;

      if (err != null) {
        setState(() {
          _pageStatus = PageStatus.fail;
        });

        return false;
      }
      MyHive.box2.put(hiveDeckTypeKey, deckType);
      MyHive.box2.put(hiveDeckTypeFetchDateKey, DateTime.now());
    } else {
      log('从本地获取数据');
      try {
        if (hiveDataExpire != null && hiveDataExpire.add(const Duration(hours: 12)).isBefore(DateTime.now())) {
          refreshFlag = true;
        }
      } catch (e) {
        log('转换失败');
        MyHive.box2.delete(hiveDeckTypeKey);
        MyHive.box2.delete(hiveDeckTypeFetchDateKey);
        return true;
      }
    }

    setState(() {
      _deckType = deckType;
      _pageStatus = PageStatus.success;
    });

    return refreshFlag;
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
                                  const SizedBox(
                                    height: 140,
                                  ),
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

                                  DeckInfo(deckTypeId: _deckType?.oid,)
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
          if (_pageStatus == PageStatus.loading)
            const Positioned.fill(
              child: Center(
                child: Loading(),
              ),
            )
        ],
      ),
    );
  }
}
