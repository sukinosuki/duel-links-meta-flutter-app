import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/type/TierList_TopTier.dart';
import 'package:flutter/material.dart';

class TierListItemView extends StatelessWidget {
  const TierListItemView({super.key, required this.deckType, this.showPower = true, required this.onTap});

  final TierList_TopTier deckType;
  final bool showPower;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(1)),
                border: Border.all(color: const Color(0xff385979), width: 2)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CachedNetworkImage(
                  width: 32,
                  fit: BoxFit.cover,
                  imageUrl:
                      'https://imgserv.duellinksmeta.com/v2/dlm/deck-type/${deckType.name}?portrait=true&width=50',
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xFFa9bcc3),
                    child: Center(
                        child: Text(
                      deckType.name,
                      style: const TextStyle(color: Color(0xff252b2d), fontSize: 12),
                    )),
                  ),
                )
              ],
            ),
          ),
          if (showPower)
            Container(
              child: Row(
                children: [
                  const Text('Power:', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 2),
                  Text(deckType.power.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            )
        ],
      ),
    );
  }
}
