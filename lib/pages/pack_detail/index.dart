import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/components/MdCardItemView.dart';
import 'package:duel_links_meta/components/MdCardsBoxLayout.dart';
import 'package:duel_links_meta/constant/colors.dart';
import 'package:duel_links_meta/http/CardApi.dart';
import 'package:duel_links_meta/pages/cards_viewpager/index.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/pack_set/PackSet.dart';
import 'package:flutter/material.dart';

import '../../type/enum/PageStatus.dart';

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
      builder: (context) => Dialog.fullscreen(backgroundColor: Colors.black87.withOpacity(0.3), child: CardsViewpagerPage(mdCards: cards, index: index)),
    );
  }

  //
  fetchData() async {
    var res = await CardApi().getObtainSourceId(pack.oid);

    var list = res.body!.map((e) => MdCard.fromJson(e)).toList();

    Map<String, List<MdCard>> rarityGroup = {};

    list.forEach((item) {
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
      backgroundColor: BaColors.theme,
      body: Container(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Hero(
                    tag: pack.name,
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: 'https://s3.duellinksmeta.com${pack.bannerImage}',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [BaColors.theme, Colors.transparent],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _pageStatus == PageStatus.success ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: rarity2CardsGroup.keys
                            .map((key) => Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [Image.asset('assets/images/rarity_${key.toLowerCase()}.webp', height: 20)],
                                    ),
                                    MdCardsBoxLayout(
                                      child: GridView.builder(
                                          padding: const EdgeInsets.all(0),
                                          shrinkWrap: true,
                                          itemCount: rarity2CardsGroup[key]!.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, childAspectRatio: 0.58, crossAxisSpacing: 6),
                                          itemBuilder: (context, index) {
                                            return MdCardItemView(
                                              mdCard: rarity2CardsGroup[key]![index],
                                              onTap: (card) => handleTapCardItem(rarity2CardsGroup[key]!, index),
                                            );
                                            // return Container(color: Colors.white,);
                                          }),
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
