import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/constant/colors.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/util/time_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/IfElseBox.dart';

class CardView extends StatelessWidget {
  const CardView({super.key, required this.card});

  final MdCard card;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration:  BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/modal_bg.webp'), fit: BoxFit.fitWidth),
          color: Theme.of(context).colorScheme.background,
          // color: BaColors.main,
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
                    children: [Image.asset('assets/images/rarity_${card.rarity.toLowerCase()}.webp', height: 20)],
                  ),
                  Container(
                    width: 200,
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
                              style: const TextStyle( fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Row(
                            children: [
                              if (card.type == 'Monster')
                                Row(
                                  children: [
                                    Image.asset('assets/images/icon_attribute_${card.attribute!.toLowerCase()}.png', width: 12, height: 12),
                                    const SizedBox(width: 2),
                                    Text(card.attribute!, style: const TextStyle( fontSize: 10)),
                                    if (card.level != null)
                                      Row(
                                        children: [
                                          const SizedBox(width: 4),
                                          if (card.monsterType.contains('Xyz'))
                                            Image.asset('assets/images/icon_normal_rank.png', width: 12, height: 12)
                                          else
                                            Image.asset('assets/images/icon_normal_level.png', width: 12, height: 12),
                                          const SizedBox(width: 2),
                                          Text(card.level?.toString() ?? '', style: const TextStyle( fontSize: 10))
                                        ],
                                      )
                                  ],
                                ),
                              if (card.type == 'Spell' || card.type == 'Trap')
                                Row(
                                  children: [
                                    Image.asset('assets/images/icon_card_type_${card.type.toLowerCase()}.png', width: 12, height: 12),
                                    const SizedBox(width: 2),
                                    Text(card.type, style: const TextStyle( fontSize: 10)),
                                    const SizedBox(width: 4),
                                    Image.asset('assets/images/icon_card_race_${card.race.toLowerCase()}.png', width: 12, height: 12),
                                    // Image.asset('assets/images/icon_card_race_ritual.png', width: 12, height: 12),
                                    const SizedBox(width: 2),

                                    Text(card.race.toLowerCase(), style: const TextStyle( fontSize: 10))
                                  ],
                                ),
                            ],
                          )
                        ],
                      ),
                      if (card.monsterType.isNotEmpty) Row(
                        children: [
                          const SizedBox(height: 4),
                          Text('[${card.monsterType.join('/')}]', style: const TextStyle( fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(card.description, style: const TextStyle( fontSize: 12)),
                      const SizedBox(height: 4),

                      if (card.atk != null)
                        Row(
                          children: [
                            const Text('ATK', style: TextStyle( fontSize: 12, fontWeight: FontWeight.w600)),
                            Text('/${card.atk}', style: const TextStyle( fontSize: 12)),
                            const SizedBox(width: 4),
                            IfElseBox(
                              condition: card.monsterType.contains('Link'),
                              ifTure: Row(
                                children: [
                                  const Text('LINK', style: TextStyle( fontSize: 12, fontWeight: FontWeight.w600)),
                                  Text('/${card.linkRating ?? 0}', style: const TextStyle( fontSize: 12)),
                                ],
                              ),
                              elseTrue: Row(children: [
                                const Text('DEF', style: TextStyle( fontSize: 12, fontWeight: FontWeight.w600)),
                                Text('/${card.def ?? 0}', style: const TextStyle( fontSize: 12)),
                              ]),
                            ),
                          ],
                        ),
                      const Text(
                        'How to Obtain',
                        style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.solid),
                      ),
                      const SizedBox(height: 10),
                      if (card.release != null)
                        Text(
                          'Released on ${TimeUtil.format(card.release)}',
                          style: const TextStyle( fontWeight: FontWeight.w600, fontSize: 12),
                        )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
