import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MdCardItemView extends StatefulWidget {
  const MdCardItemView({required this.mdCard, super.key, this.bottomWidget, this.showBanStatus = true, this.trend, this.onTap});

  final MdCard mdCard;
  final Widget? bottomWidget;
  final bool showBanStatus;
  final String? trend;
  final Function(MdCard data)? onTap;

  @override
  State<MdCardItemView> createState() => _MdCardItemViewState();
}

class _MdCardItemViewState extends State<MdCardItemView> {
  MdCard get mdCard => widget.mdCard;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap?.call(widget.mdCard),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 8,
                child: Image.asset('assets/images/rarity_${mdCard.rarity.toLowerCase()}.webp'),
              ),
            ],
          ),
          Stack(
            children: [
              CachedNetworkImage(
                  // placeholder: (context, url) => Image.asset('assets/images/card_placeholder.webp'),
                  // errorWidget: (context, url, err) => Image.asset('assets/images/card_placeholder.webp'),
                  fadeInDuration: const Duration(milliseconds: 0),
                  fadeOutDuration: null,
                  imageUrl: 'https://s3.duellinksmeta.com/cards/${mdCard.oid}_w100.webp'),
              if (widget.bottomWidget != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: widget.bottomWidget!,
                ),
              if (widget.showBanStatus && mdCard.banStatus != null)
                Positioned(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SvgPicture.asset(
                      'assets/images/icon_${mdCard.banStatus!.toLowerCase()}.svg',
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
