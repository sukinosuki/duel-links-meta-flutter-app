import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/constant/colors.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/http/CardApi.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/util/time_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/IfElseBox.dart';

class CardView extends StatefulWidget {
  const CardView({super.key, required this.card});

  final MdCard card;

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  MdCard? _card = null;

  @override
  void dispose() {
    super.dispose();

    log('destroy');
  }

  init() async {
    log('_init: ${_card == null}');

    if (_card != null) return;
    setState(() {
      _card = widget.card;
    });

    if (widget.card.rarity != '') {
    } else {
      var hiveData = await MyHive.box2.get('card:${widget.card.oid}');

      if (hiveData != null) {
        log('本地获取到card111');

        setState(() {
          _card = hiveData as MdCard;
        });
      } else {
        var (err, res) = await CardApi().getById(_card!.oid).toCatch;
        if (err != null) {
          return;
        }

        // var card = MdCard.fromJson(res![0]);
        var card = res![0];
        setState(() {
          _card = card;
        });
        MyHive.box2.put('card:${card.oid}', card);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    if (_card == null) return const SizedBox();

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          image: const DecorationImage(image: AssetImage('assets/images/modal_bg.webp'), fit: BoxFit.fitWidth),
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
                  SizedBox(
                    height: 20,
                    child: _card?.rarity != ''
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset('assets/images/rarity_${_card?.rarity.toLowerCase()}.webp'),
                            ],
                          )
                        : null,
                  ),
                  Container(
                    width: 200,
                    height: 200 * 1.46,
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: double.infinity,
                          imageUrl: 'https://s3.duellinksmeta.com/cards/${_card?.oid}_w100.webp',
                        ),
                        Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: 'https://s3.duellinksmeta.com/cards/${_card?.oid}_w420.webp',
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
                              _card!.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Row(
                            children: [
                              if (_card!.type == 'Monster')
                                Row(
                                  children: [
                                    Image.asset('assets/images/icon_attribute_${_card!.attribute!.toLowerCase()}.png',
                                        width: 12, height: 12),
                                    const SizedBox(width: 2),
                                    Text(_card!.attribute!, style: const TextStyle(fontSize: 10)),
                                    if (_card!.level != null)
                                      Row(
                                        children: [
                                          const SizedBox(width: 4),
                                          if (_card!.monsterType.contains('Xyz'))
                                            Image.asset('assets/images/icon_normal_rank.png', width: 12, height: 12)
                                          else
                                            Image.asset('assets/images/icon_normal_level.png', width: 12, height: 12),
                                          const SizedBox(width: 2),
                                          Text(_card!.level?.toString() ?? '', style: const TextStyle(fontSize: 10))
                                        ],
                                      )
                                  ],
                                ),
                              if (_card!.type == 'Spell' || _card!.type == 'Trap')
                                Row(
                                  children: [
                                    Image.asset('assets/images/icon_card_type_${_card!.type.toLowerCase()}.png', width: 12, height: 12),
                                    const SizedBox(width: 2),
                                    Text(_card!.type, style: const TextStyle(fontSize: 10)),
                                    const SizedBox(width: 4),
                                    Image.asset('assets/images/icon_card_race_${_card!.race.toLowerCase()}.png', width: 12, height: 12),
                                    // Image.asset('assets/images/icon_card_race_ritual.png', width: 12, height: 12),
                                    const SizedBox(width: 2),

                                    Text(_card!.race.toLowerCase(), style: const TextStyle(fontSize: 10))
                                  ],
                                ),
                            ],
                          )
                        ],
                      ),
                      if (_card!.monsterType.isNotEmpty)
                        Row(
                          children: [
                            const SizedBox(height: 4),
                            Text('[${_card!.monsterType.join('/')}]', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      const SizedBox(height: 4),
                      Text(_card!.description, style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      if (_card!.atk != null)
                        Row(
                          children: [
                            const Text('ATK', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            Text('/${_card!.atk}', style: const TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            IfElseBox(
                              condition: _card!.monsterType.contains('Link'),
                              ifTure: Row(
                                children: [
                                  const Text('LINK', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  Text('/${_card!.linkRating ?? 0}', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              elseTrue: Row(children: [
                                const Text('DEF', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                Text('/${_card!.def ?? 0}', style: const TextStyle(fontSize: 12)),
                              ]),
                            ),
                          ],
                        ),
                      const Text(
                        'How to Obtain',
                        style: TextStyle(fontSize: 12, decoration: TextDecoration.underline, decorationStyle: TextDecorationStyle.solid),
                      ),
                      const SizedBox(height: 10),
                      if (_card!.release != null)
                        Text(
                          'Released on ${TimeUtil.format(_card!.release)}',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
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
