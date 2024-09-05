import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/components/MdCardItemView.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/db/CardHiveDb.dart';
import 'package:duel_links_meta/hive/db/PackHiveDb.dart';
import 'package:duel_links_meta/http/CardApi.dart';
import 'package:duel_links_meta/pages/cards_viewpager/index.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/pack_set/PackSet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class PackDetailPage extends StatefulWidget {
  const PackDetailPage({required this.pack, super.key});

  final PackSet pack;

  @override
  State<PackDetailPage> createState() => _PackDetailPageState();
}

class _PackDetailPageState extends State<PackDetailPage> {
  PackSet get pack => widget.pack;
  Map<String, List<MdCard>> rarity2CardsGroup = {};
  var _pageStatus = PageStatus.loading;
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  void handleTapCardItem(List<MdCard> cards, int index) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black87.withOpacity(0.3),
        child: CardsViewpagerPage(cards: cards, index: index),
      ),
    );
  }

  //
  Future<void> fetchData({bool force = false}) async {
    final cardsIds = await PackHiveDb().getIds(pack.oid);
    var cards = <MdCard>[];

    if (cardsIds != null) {
      for (var i = 0; i < cardsIds.length; i++) {
        final card = await CardHiveDb().get(cardsIds[i]);

        cards.add(card ?? MdCard()
          ..oid = cardsIds[i]);
      }
    } else {
      final (err, list) = await CardApi().getByObtainSource(pack.oid).toCatch;
      if (err != null || list == null) {
        setState(() {
          _pageStatus = PageStatus.fail;
        });
        return;
      }

      cards = list;
      PackHiveDb().setIds(pack.oid, list.map((e) => e.oid).toList()).ignore();
    }

    final rarityGroup = <String, List<MdCard>>{};

    cards.forEach((element) {
      if (cardsIds == null && element.rarity != '') {
        CardHiveDb().set(element);
      }

      if (rarityGroup[element.rarity] == null) {
        rarityGroup[element.rarity] = [element];
      } else {
        rarityGroup[element.rarity]!.add(element);
      }
    });

    setState(() {
      rarity2CardsGroup = rarityGroup;
      _pageStatus = PageStatus.success;
    });
  }

  var _isInit = false;

  Future<void> _handleRefresh() async {
    await fetchData(force: _isInit);
    _isInit = true;
  }

  void _triggerRefresh() {
    _refreshIndicatorKey.currentState?.show();
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _triggerRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: 'https://s3.duellinksmeta.com${pack.bannerImage}',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          bottom: -1,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                                colors: [
                                  Theme.of(context).scaffoldBackgroundColor,
                                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _pageStatus == PageStatus.success ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Column(
                        children: rarity2CardsGroup.keys
                            .map(
                              (key) => Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.asset('assets/images/rarity_${key.toLowerCase()}.webp', height: 20),
                                    ],
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    margin: EdgeInsets.zero,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 6, right: 6, top: 6),
                                      child: GridView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: rarity2CardsGroup[key]!.length,
                                        physics: const NeverScrollableScrollPhysics(),
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 5,
                                          childAspectRatio: 0.58,
                                          crossAxisSpacing: 6,
                                        ),
                                        itemBuilder: (context, index) {
                                          return MdCardItemView(
                                            mdCard: rarity2CardsGroup[key]![index],
                                            onTap: (card) => handleTapCardItem(rarity2CardsGroup[key]!, index),
                                          );
                                          // return Container(color: Colors.white,);
                                        },
                                      ),
                                    ),
                                  ),
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
            if (_pageStatus == PageStatus.fail)
              const Positioned(
                child: Center(
                  child: Text('Loading failed'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
