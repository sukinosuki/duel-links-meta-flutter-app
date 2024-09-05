import 'dart:developer';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/components/SkillModalView.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/db/DeckTypeDetailHiveDb.dart';
import 'package:duel_links_meta/http/DeckTypeApi.dart';
import 'package:duel_links_meta/pages/deck_detail/components/DeckInfo.dart';
import 'package:duel_links_meta/pages/deck_type_detail/components/DeckTypeBreakdownGridView.dart';
import 'package:duel_links_meta/store/AppStore.dart';
import 'package:duel_links_meta/type/deck_type/DeckType.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class DeckTypeDetailPage extends StatefulWidget {
  const DeckTypeDetailPage({required this.name, super.key});

  final String name;

  @override
  State<DeckTypeDetailPage> createState() => _DeckTypeDetailPageState();
}

class _DeckTypeDetailPageState extends State<DeckTypeDetailPage> {
  String get _deckTypeName => widget.name;
  final _refreshIndicator = GlobalKey<RefreshIndicatorState>();

  final AppStore appStore = Get.put(AppStore());

  bool isExtraCard(List<String> monsterType) {
    if (monsterType.contains('Link')) return true;
    if (monsterType.contains('Xyz')) return true;
    if (monsterType.contains('Fusion')) return true;
    if (monsterType.contains('Synchro')) return true;

    return false;
  }

  DeckType? _deckType;

  var _pageStatus = PageStatus.loading;

  List<DeckType_DeckBreakdownCards> get _breakdownCards {
    if (_deckType == null) {
      return [];
    }

    return _deckType!.deckBreakdown.cards.where((item) => !isExtraCard(item.card.monsterType)).toList();
  }

  List<DeckType_DeckBreakdownCards> get _breakdownExtraCards {
    if (_deckType == null) {
      return [];
    }

    return _deckType!.deckBreakdown.cards.where((item) => isExtraCard(item.card.monsterType)).toList();
  }

  Future<void> handleTapSkill(DeckType_DeckBreakdown_Skill skill) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(skill.name),
        content: SkillModalView(name: skill.name),
        surfaceTintColor: Colors.transparent,
      ),
    );

    // await showGeneralDialog<void>(
    //   context: context,
    //   barrierDismissible: true,
    //   barrierLabel: '',
    //   pageBuilder: (context, anim1, anim2) {
    //     // return SkillModalView(name: skill.name);
    //     return SkillModalView(name: skill.name);
    //   },
    //   transitionDuration: Duration(milliseconds: 400),
    //   transitionBuilder: (context, anim1, anim2, child) {
    //     return Transform.scale(
    //       scale: anim1.value,
    //       child: Opacity(
    //         opacity: anim1.value,
    //         child: child,
    //       ),
    //     );
    //   },
    // );
  }

  //
  Future<bool> fetchDeckType({bool force = false}) async {
    var deckType = await DeckTypeDetailHiveDb().get(_deckTypeName);
    final hiveDataExpire = await DeckTypeDetailHiveDb().getExpireTime(_deckTypeName);
    Exception? err;

    var refreshFlag = false;

    if (deckType == null || force) {
      (err, deckType) = await DeckTypeApi().getDetailByName(_deckTypeName).toCatch;

      if (err != null || deckType == null) {
        setState(() {
          _pageStatus = PageStatus.fail;
        });

        return false;
      }
      await DeckTypeDetailHiveDb().set(deckType);
      await DeckTypeDetailHiveDb().setExpireTime(deckType, DateTime.now().add(const Duration(days: 1)));
    } else {
      refreshFlag = hiveDataExpire == null || hiveDataExpire.isBefore(DateTime.now());
    }

    setState(() {
      _deckType = deckType;
      _pageStatus = PageStatus.success;
    });

    return refreshFlag;
  }

  Future<void> init() async {
    final shouldRefresh = await fetchDeckType();
    if (shouldRefresh) {
      await fetchDeckType(force: true);
    }
  }

  var _isInit = false;

  Future<void> _handleRefresh() async {
    final shouldRefresh = await fetchDeckType(force: _isInit);
    _isInit = true;
    if (shouldRefresh) {
      await fetchDeckType(force: true);
    }
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshIndicator.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        key: _refreshIndicator,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                            bottom: -1,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  // colors: [Theme.of(context).colorScheme.background, BaColors.theme.withOpacity(0)]),
                                  colors: [
                                    Theme.of(context).scaffoldBackgroundColor,
                                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Positioned(
                          //   bottom: 200,
                          //   left: 0,
                          //   right: 0,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(left: 8, bottom: 18),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Text(_deckTypeName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                          //         AnimatedOpacity(
                          //           opacity: _pageStatus == PageStatus.success ? 1 : 0,
                          //           duration: const Duration(milliseconds: 300),
                          //           child: Row(
                          //             children: [
                          //               const Text('Average size: ', style: TextStyle(fontSize: 12)),
                          //               Text(_deckType?.deckBreakdown.avgMainSize.toString() ?? '',
                          //                   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                          //               const SizedBox(width: 3),
                          //               const Text('cards', style: TextStyle(fontSize: 12)),
                          //             ],
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // )
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
                                    const SizedBox(height: 140),
                                    Text(_deckTypeName, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
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
                                    const SizedBox(height: 20),
                                    const Text('Top Main Deck', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 10),
                                    DeckTypeBreakdownGridView(cards: _breakdownCards, crossAxisCount: 6),
                                    if (_breakdownExtraCards.isNotEmpty)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),
                                          const Text('Top Extra Deck', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 10),
                                          DeckTypeBreakdownGridView(cards: _breakdownExtraCards, crossAxisCount: 6),
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
                                                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              skill.name + skill.name,
                                                              style: const TextStyle(color: Color(0xff0a87bb)),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 4),
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
                                    DeckInfo(
                                      deckTypeId: _deckType?.oid,
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
            if (_pageStatus == PageStatus.fail)
              const Center(
                child: Text('Loading failed'),
              )
          ],
        ),
      ),
    );
  }
}
