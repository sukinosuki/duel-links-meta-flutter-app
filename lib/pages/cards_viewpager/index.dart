import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/components/IfElseBox.dart';
import 'package:duel_links_meta/constant/colors.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardsViewpagerPage extends StatefulWidget {
  const CardsViewpagerPage({super.key, required this.mdCards, required this.index});

  final List<MdCard> mdCards;
  final int index;

  @override
  State<CardsViewpagerPage> createState() => _CardsViewpagerPageState();
}

class _CardsViewpagerPageState extends State<CardsViewpagerPage> {
  List<MdCard> get mdCards => widget.mdCards;

  int get index => widget.index;
  late PageController _controller;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: index);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: _controller,
        children: mdCards
            .map((card) => Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(14)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/images/modal_bg.webp'), fit: BoxFit.fitWidth),
                            color: Colors.black87,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 200,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [Image.asset('assets/images/rarity_sr.webp', height: 20)],
                                    ),
                                    Container(
                                      width: 200,
                                      color: Colors.white,
                                      height: 200 * 1.46,
                                      child: Stack(
                                        children: [
                                          CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            imageUrl: 'https://s3.duellinksmeta.com/cards/${card.oid}_w100.webp',
                                          ),
                                          Positioned(
                                              top: 0,
                                              left: 0,
                                              right: 0,
                                              bottom: 0,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: 'https://s3.duellinksmeta.com/cards/${card.oid}_w420.webp',
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.only(top: 12),
                                  height: 160,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                card.name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                if (card.type == 'Monster')
                                                  Row(
                                                    children: [
                                                      Image.asset('assets/images/icon_attribute_${card.attribute!.toLowerCase()}.png', width: 12, height: 12),
                                                      const SizedBox(width: 2),
                                                      Text(card.attribute!, style: const TextStyle(color: Colors.white, fontSize: 10)),
                                                      if (card.level != null)
                                                        Row(
                                                          children: [
                                                            const SizedBox(width: 4),
                                                            if (card.monsterType.contains('Xyz'))
                                                              Image.asset('assets/images/icon_normal_rank.png', width: 12, height: 12)
                                                            else
                                                              Image.asset('assets/images/icon_normal_level.png', width: 12, height: 12),
                                                            const SizedBox(width: 2),
                                                            Text(card.level?.toString() ?? '', style: const TextStyle(color: Colors.white, fontSize: 10))
                                                          ],
                                                        )
                                                    ],
                                                  ),
                                                if (card.type == 'Spell' || card.type == 'Trap')
                                                  Row(
                                                    children: [
                                                      Image.asset('assets/images/icon_card_type_${card.type.toLowerCase()}.png', width: 12, height: 12),
                                                      const SizedBox(width: 2),
                                                      Text(card.type, style: const TextStyle(color: Colors.white, fontSize: 10)),
                                                      const SizedBox(width: 4),
                                                      Image.asset('assets/images/icon_card_race_${card.race.toLowerCase()}.png', width: 12, height: 12),
                                                      const SizedBox(width: 2),
                                                      Text(card.race, style: const TextStyle(color: Colors.white, fontSize: 10))
                                                    ],
                                                  ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text('[Zombie/Effect]', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 4),
                                        Text(card.description, style: const TextStyle(color: Colors.white, fontSize: 11)),
                                        const SizedBox(height: 4),
                                        if (card.atk != null)
                                          Row(
                                            children: [
                                              const Text('ATK', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                                              Text('/${card.atk}', style: const TextStyle(color: Colors.white, fontSize: 11)),
                                              const SizedBox(width: 4),
                                              IfElseBox(
                                                condition: card.monsterType.contains('Link'),
                                                ifTure: Row(
                                                  children: [
                                                    const Text('LINK', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                                                    Text('/${card.linkRating ?? 0}', style: const TextStyle(color: Colors.white, fontSize: 11)),
                                                  ],
                                                ),
                                                elseTrue: Row(children: [
                                                  const Text('DEF', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                                                  Text('/${card.def ?? 0}', style: const TextStyle(color: Colors.white, fontSize: 11)),
                                                ]),
                                              ),
                                            ],
                                          ),
                                        const Text(
                                          'How to Obtain',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              decoration: TextDecoration.underline,
                                              decorationColor: Colors.white,
                                              decorationStyle: TextDecorationStyle.solid),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Released on ${DateFormat.yMMMMd().format(card.release!)}',
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11),
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ))
            .toList());
  }
}
