import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/components/MdCardItemView.dart';
import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/http/CardApi.dart';
import 'package:duel_links_meta/pages/cards_viewpager/index.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/pack_set/PackSet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PackDetailPage extends StatefulWidget {
  const PackDetailPage({super.key, required this.pack});

  final PackSet pack;

  @override
  State<PackDetailPage> createState() => _PackDetailPageState();
}

class _PackDetailPageState extends State<PackDetailPage> {
  PackSet get pack => widget.pack;
  List<MdCard> _cards = [];
  Map<String, List<MdCard>> rarity2CardsGroup = {};
  var _pageStatus = PageStatus.loading;

  handleTapCardItem(List<MdCard> cards, int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black87.withOpacity(0.3),
        child: CardsViewpagerPage(cards: cards, index: index),
      ),
    );
  }

  //
  fetchData() async {
    var sourceKey = 'pack_card_ids:${pack.oid}';
    var cardsIds = await MyHive.box2.get(sourceKey) as List<String>?;
    if (cardsIds != null) {
      // await Future.delayed(Duration(milliseconds: 300));
      log('从本地获取到card, sourceKey: ${sourceKey}');
      final cards = <MdCard>[];
      for (var i=0; i<cardsIds.length;i++) {
          var card = await MyHive.box2.get('card:${cardsIds[i]}') as MdCard?;

          cards.add(card?? MdCard()..oid= cardsIds[i]);
      }
      // var cards = cardsIds.map((id) {
      //   var card = MyHive.box2.get('card:${id}') as MdCard;
      //
      //   return card;
      // }).toList();

      log('从本地获取到card, length: ${cards.length}');

      final rarityGroup = <String, List<MdCard>>{};

      cards.forEach((item) {
        // MyHive.box2.put('card:${item.oid}', item);

        if (rarityGroup[item.rarity] == null) {
          rarityGroup[item.rarity] = [item];
        } else {
          rarityGroup[item.rarity]!.add(item);
        }
      });

      setState(() {
        rarity2CardsGroup = rarityGroup;
        _cards = cards;
        _pageStatus = PageStatus.success;
      });

      return;
    }

    var res = await CardApi().getObtainSourceId(pack.oid);

    var list = res.body!.map((e) => MdCard.fromJson(e)).toList();
    MyHive.box2.put(sourceKey, list.map((e) => e.oid).toList());
    Map<String, List<MdCard>> rarityGroup = {};

    list.forEach((item) {
      MyHive.box2.put('card:${item.oid}', item);

      if (rarityGroup[item.rarity] == null) {
        rarityGroup[item.rarity] = [item];
      } else {
        rarityGroup[item.rarity]!.add(item);
      }
    });

    setState(() {
      rarity2CardsGroup = rarityGroup;
      _cards = list;
      _pageStatus = PageStatus.success;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Hero(
                    tag: pack.name,
                    child: SizedBox(
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
                            // top: 100,
                            bottom: -1,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Theme.of(context).colorScheme.background, Colors.transparent],
                                  // colors: [Colors.white, Colors.transparent],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _pageStatus == PageStatus.success ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Column(
                        children: rarity2CardsGroup.keys
                            .map((key) => Column(
                                  children: [
                                    // const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [Image.asset('assets/images/rarity_${key.toLowerCase()}.webp', height: 20)],
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                      margin: const EdgeInsets.all(0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 6, right: 6, top: 6),
                                        child: GridView.builder(
                                            padding: const EdgeInsets.all(0),
                                            shrinkWrap: true,
                                            itemCount: rarity2CardsGroup[key]!.length,
                                            physics: const NeverScrollableScrollPhysics(),
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 5, childAspectRatio: 0.58, crossAxisSpacing: 6),
                                            itemBuilder: (context, index) {
                                              return MdCardItemView(
                                                mdCard: rarity2CardsGroup[key]![index],
                                                onTap: (card) => handleTapCardItem(rarity2CardsGroup[key]!, index),
                                              );
                                              // return Container(color: Colors.white,);
                                            }),
                                      ),
                                    )
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (_pageStatus == PageStatus.loading) const Positioned(child: Center(child: Loading()))
          ],
        ),
      ),
    );
  }
}
