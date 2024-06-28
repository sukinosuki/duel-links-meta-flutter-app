import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/gen/assets.gen.dart';
import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/http/CardApi.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

  MdCard? _mdCard = null;

  init() async {
    // await Future.delayed(Duration(milliseconds: 100));
    // if (widget.mdCard != null) return;

    var hiveData = MyHive.box.get('card:$cardId');
    MdCard? card = null;
    if (hiveData == null) {
      var (err, res) = await CardApi().getById(cardId).toCatch;
      if (err != null) return;
      if (res!.length == 0) return;

      card = MdCard.fromJson(res[0]);
      MyHive.box.put('card:$cardId', card);
    } else {
      log('本地获取到数据');
      try {
        card = hiveData as MdCard;
      } catch (e) {
        MyHive.box.delete('card:$cardId');
        return;
      }
    }
    setState(() {
      _mdCard = card as MdCard;
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
                child: mdCard?.rarity != "" ? Image.asset('assets/images/rarity_${mdCard?.rarity.toLowerCase()}.webp') : null,
              ),
            ],
          ),
          Stack(
            children: [
              CachedNetworkImage(
                  placeholder: (context, url) => Image.asset('assets/images/card_placeholder.webp'),
                  // placeholder: (context, url) => Assets.images.cardPlaceholder,
                  errorWidget: (context, url, err) => Image.asset('assets/images/card_placeholder.webp'),
                  fadeInDuration: const Duration(milliseconds: 0),
                  fadeOutDuration: null,
                  imageUrl: 'https://s3.duellinksmeta.com/cards/${cardId}_w100.webp'),
              if (widget.bottomWidget != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: widget.bottomWidget!,
                ),
              if (widget.showBanStatus && mdCard?.banStatus != null)
                Positioned(
                    child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: SvgPicture.asset(
                    'assets/images/icon_${mdCard?.banStatus?.toLowerCase()}.svg',
                    width: 20,
                    height: 20,
                  ),
                )),
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
