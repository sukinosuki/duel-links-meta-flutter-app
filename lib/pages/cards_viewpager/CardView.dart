import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/gen/assets.gen.dart';
import 'package:duel_links_meta/hive/db/CardHiveDb.dart';
import 'package:duel_links_meta/http/CardApi.dart';
import 'package:duel_links_meta/store/BanCardStore.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/util/time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../components/IfElseBox.dart';

class CardView extends StatefulWidget {
  const CardView({required this.card, super.key});

  final MdCard card;

  @override
  State<CardView> createState() => _CardViewState();
}

// 如果有传入card，使用传入的card，
// 如果传入的card是只有基础信息(id,name)的card，需要从本地获取完整信息的card
// 如果从本地获取不到card，则请求获取一次再存到本地
class _CardViewState extends State<CardView> {
  // MdCard? _card = MdCard()..oid="60c2b3a9a0e24f2d54a517cf";
  MdCard? _card;

  BanCardStore banCardStore = Get.put(BanCardStore());

  String? get banStatus => banCardStore.idToCardMap[widget.card.oid]?.banStatus;

  @override
  void dispose() {
    super.dispose();
  }

  var banStatusStore = Get.put(BanCardStore());

  Future<void> init() async {
    log('_init, _card == null: ${_card == null}, widget.card: ${widget.card}');

    // _card已经有值
    if (_card != null) return;

    setState(() {
      _card = widget.card;
    });

    // 传入的card是完整信息的card
    if (widget.card.rarity != '') {
      return;
    }

    final card = await CardHiveDb().get(widget.card.oid);

    if (card != null) {
      log('本地获取到card111');
      setState(() {
        _card = card;
      });
    } else {
      log('请求获取card111');
      final (err, res) = await CardApi().getById(_card!.oid).toCatch;
      if (err != null || res == null) return;

      final card = res;
      setState(() {
        _card = card;
      });

      CardHiveDb().set(card).ignore();
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
          image: DecorationImage(image: Assets.images.modalBg.image().image, fit: BoxFit.fitWidth),
          color: Theme.of(context).dialogBackgroundColor,
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
                  AspectRatio(
                    aspectRatio: 0.685,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: double.infinity,
                          imageUrl: 'https://s3.duellinksmeta.com/cards/${_card!.oid}_w100.webp',
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: CachedNetworkImage(
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: 'https://s3.duellinksmeta.com/cards/${_card!.oid}_w420.webp',
                          ),
                        ),
                        if (banStatus != null)
                          Positioned(
                            left: 0,
                            top: 0,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              child: SvgPicture.asset(
                                'assets/images/icon_${banStatus!.toLowerCase()}.svg',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 12),
              height: 160,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _card?.name ?? '',
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
                                      Image.asset(
                                        'assets/images/icon_attribute_${_card!.attribute!.toLowerCase()}.png',
                                        width: 14,
                                        height: 14,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(_card!.attribute!, style: const TextStyle(fontSize: 12)),
                                      if (_card!.level != null)
                                        Row(
                                          children: [
                                            const SizedBox(width: 4),
                                            IfElseBox(
                                              condition: _card!.monsterType.contains('Xyz'),
                                              ifTure: Assets.images.iconNormalRank.image(width: 14, height: 14),
                                              elseTrue: Assets.images.iconNormalLevel.image(width: 14, height: 14),
                                            ),
                                            const SizedBox(width: 2),
                                            Text(_card!.level?.toString() ?? '', style: const TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                    ],
                                  ),
                                if (_card!.type == 'Spell' || _card!.type == 'Trap')
                                  Row(
                                    children: [
                                      Image.asset('assets/images/icon_card_type_${_card!.type.toLowerCase()}.png', width: 14, height: 14),
                                      const SizedBox(width: 2),
                                      Text(_card!.type, style: const TextStyle(fontSize: 12)),
                                      const SizedBox(width: 4),
                                      Image.asset('assets/images/icon_card_race_${_card!.race.toLowerCase()}.png', width: 14, height: 14),
                                      const SizedBox(width: 2),
                                      Text(_card!.race.toLowerCase(), style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                        if (_card!.monsterType.isNotEmpty)
                          Row(
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                '[${_card!.race}/${_card!.monsterType.join('/')}]',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        const SizedBox(height: 4),
                        Text(_card!.description, style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 4),
                        if (_card?.atk != null)
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
                                    Text('-${_card!.linkRating ?? 0}', style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                                elseTrue: Row(
                                  children: [
                                    const Text('DEF', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    Text('/${_card!.def ?? 0}', style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        if (_card?.obtain.isNotEmpty ?? false)
                          const Text(
                            'How to Obtain',
                            style:
                                TextStyle(fontSize: 12, decoration: TextDecoration.underline, decorationStyle: TextDecorationStyle.solid),
                          ),
                        const SizedBox(height: 10),
                        if (_card!.release != null)
                          Text(
                            'Released on ${TimeUtil.format(_card!.release)}',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  if (_card?.rarity == '') const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
