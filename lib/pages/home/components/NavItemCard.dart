import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/type/NavTab.dart';
import 'package:flutter/material.dart';

class NavItemCard extends StatelessWidget {
  const NavItemCard({super.key, required this.navTab});

  final NavTab navTab;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              fit: BoxFit.cover,
              fadeOutDuration: null,
              fadeInDuration: const Duration(milliseconds: 0),
              imageUrl: 'https://wsrv.nl/?url=https://s3.duellinksmeta.com${navTab.image}&w=360&output=webp&we&n=-1&maxage=7d',
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Colors.black12, Colors.black87],
                )),
                height: 30,
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      navTab.title ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
