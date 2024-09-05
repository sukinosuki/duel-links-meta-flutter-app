import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/type/NavTab.dart';
import 'package:flutter/material.dart';

class NavItemCard extends StatelessWidget {
  const NavItemCard({required this.navTab, super.key});

  final NavTab navTab;

  String get coverUrl => 'https://wsrv.nl/?url=https://s3.duellinksmeta.com${navTab.image}&w=360&output=webp&we&n=-1&maxage=7d';

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      shadowColor: Colors.transparent,
      // elevation: 0,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: navTab.image != ''
                ? CachedNetworkImage(
                    fit: BoxFit.cover,
                    fadeOutDuration: null,
                    imageUrl: coverUrl,
                  )
                : null,
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
                ),
              ),
              height: 30,
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    navTab.title ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          // Positioned(
          //     right: 0,
          //     top: 0,
          //     child: Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(6),
          //         // color: Theme.of(context).colorScheme.onPrimary
          //       ),
          //       child: Icon(Icons.eject, color: Colors.white, size: 12,),
          //     ))
        ],
      ),
    );
  }
}
