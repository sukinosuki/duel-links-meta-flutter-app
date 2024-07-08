import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/gen/assets.gen.dart';
import 'package:duel_links_meta/type/top_deck/TopDeckSimple.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../type/top_deck/TopDeck.dart';

class TopDeckItem extends StatelessWidget {
  const TopDeckItem({super.key, required this.topDeck, this.topLeft, this.bottomRight, this.isNew, this.coverUrl, this.isActive, required this.onTap});

  final String? coverUrl;
  final TopDeck topDeck;
  final Widget? topLeft;
  final Widget? bottomRight;
  final bool? isNew;
  final bool? isActive;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(1)),
                          border: Border.all(color: const Color(0xff385979), width: 2)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            color: const Color(0xff002142),
                            // color: const Color(0xff91c8da),
                            child: CachedNetworkImage(
                              width: 32,
                              fit: BoxFit.cover,
                              // https://wsrv.nl/?url=https://s3.duellinksmeta.com/img/tournaments/logos/kog.webp&w=100&output=webp&we&n=-1&maxage=7d
                              imageUrl: coverUrl ??
                                  'https://imgserv.duellinksmeta.com/v2/dlm/deck-type/${Uri.encodeComponent(topDeck.deckType.name)}?portrait=true&width=50',
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 22),
                                  decoration: BoxDecoration(
                                    color: isActive == true ? Color(0xff91c8da) : Color(0xFFa9bcc3),
                                    // color: Color(0xFFa9bcc3),
                                    boxShadow: [
                                      BoxShadow(color: Colors.pinkAccent),
                                      BoxShadow(
                                        color: Colors.pinkAccent,
                                        blurRadius: 8,
                                        spreadRadius: -12,
                                        // offset: const Offset(-2, -2),
                                      ),
                                    ],
                                  ),
                                  // color: const Color(0xff91c8da),
                                  child: Center(
                                    child: Text(
                                      topDeck.deckType.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        color: Color(0xff252b2d),
                                        fontSize: 12,
                                        height: 1.2,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                if (bottomRight != null)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: bottomRight!,
                                  ),
                                if (topLeft != null)
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: topLeft!,
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  )
                ],
              ),
            ],
          ),
          if (isNew == true)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                child: Assets.images.commonCardNew.image(width: 25),
              ),
            )
        ],
      ),
    );
  }
}
