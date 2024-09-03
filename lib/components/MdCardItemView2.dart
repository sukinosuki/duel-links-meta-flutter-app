import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/gen/assets.gen.dart';
import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/hive/db/CardHiveDb.dart';
import 'package:duel_links_meta/http/CardApi.dart';
import 'package:duel_links_meta/store/BanCardStore.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MdCardItemView2 extends StatefulWidget {
  const MdCardItemView2({super.key, this.mdCard, required this.id, this.bottomWidget, this.showBanStatus = true, this.trend, this.onTap});

  final String id;
  final MdCard? mdCard;
  final Widget? bottomWidget;
  final bool showBanStatus;
  final String? trend;
  final void Function(String id)? onTap;

  @override
  State<MdCardItemView2> createState() => _MdCardItemViewState();
}

class _MdCardItemViewState extends State<MdCardItemView2> {
  MdCard? get mdCard => _mdCard ?? widget.mdCard;

  String get cardId => widget.id;

  MdCard? _mdCard;

  BanCardStore banCardStore = Get.put(BanCardStore());

  String? get banStatus => banCardStore.idToCardMap[cardId]?.banStatus;

  //
  Future<void> init() async {
    if (widget.mdCard != null && widget.mdCard?.type != '') return;

    var card = await CardHiveDb.get(cardId);

    if (card == null) {
      final (err, res) = await CardApi().getById(cardId).toCatch;
      if (err != null || res == null) return;

      card = res;
      await CardHiveDb.setCard(card);
    }

    setState(() {
      _mdCard = card;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap?.call(cardId),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 8,
                child: (mdCard != null && mdCard?.rarity != '')
                    ? Image.asset('assets/images/rarity_${mdCard!.rarity.toLowerCase()}.webp')
                    : null,
              ),
            ],
          ),
          Stack(
            children: [
              CachedNetworkImage(
                  placeholder: (context, url) => Assets.images.cardPlaceholder.image(),
                  errorWidget: (context, url, err) => Assets.images.cardPlaceholder.image(),
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: null,
                  imageUrl: 'https://s3.duellinksmeta.com/cards/${cardId}_w100.webp'),

              if (widget.bottomWidget != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: widget.bottomWidget!,
                ),

              if (banStatus != null)
                Positioned(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SvgPicture.asset(
                      'assets/images/icon_${banStatus!.toLowerCase()}.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),

              if (widget.trend != null && widget.trend != '')
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.trend == 'up' ? const Color(0xff008000) : const Color(0xffd10d0d),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    width: 16,
                    height: 16,
                    child: Center(
                      child: RotationTransition(
                        turns: AlwaysStoppedAnimation((widget.trend == 'up' ? 90 : -90) / 360),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
