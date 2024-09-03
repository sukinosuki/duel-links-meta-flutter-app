import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/type/ban_list_change/BanListChange.dart';
import 'package:flutter/material.dart';

class BanListChangeCardView extends StatelessWidget {
  const BanListChangeCardView({required this.change, required this.onTap, super.key});

  final BanListChange_Change change;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              width: 45,
              height: 45 * 1.46,
              fit: BoxFit.cover,
              imageUrl: 'https://s3.duellinksmeta.com/cards/${change.card?.oid}_w100.webp',
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    change.card?.name ?? '',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      const Text('From: ', style: TextStyle(fontSize: 11)),
                      Text(change.from ?? '—'),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('To: ', style: TextStyle(fontSize: 11)),
                      Text(change.to ?? '—'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
