import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/extension/DateTime.dart';
import 'package:duel_links_meta/gen/assets.gen.dart';
import 'package:duel_links_meta/type/top_deck/TopDeck.dart';
import 'package:flutter/material.dart';

class TopDeckListView extends StatefulWidget {
  const TopDeckListView({required this.topDecks, super.key, this.onTap});

  final List<TopDeck> topDecks;

  final void Function(TopDeck topDeck)? onTap;

  @override
  State<TopDeckListView> createState() => _TopDeckListViewState();
}

class _TopDeckListViewState extends State<TopDeckListView> {
  List<TopDeck> get _topDecks => widget.topDecks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black12,
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 42),
                  child: const Text('Skill', style: TextStyle(fontSize: 13),),
                ),
              ),
              Container(
                width: 40,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: const Text('Top',style: TextStyle(fontSize: 13),),
              ),
              Container(
                width: 90,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: const Text('Price', style: TextStyle(fontSize: 13),),
              ),
              Container(
                width: 80,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: const Text('Date', style: TextStyle(fontSize: 13),),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _topDecks.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: ()=> widget.onTap?.call(_topDecks[index]),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: SizedBox(
                          height: 32,
                          width: 32,
                          child: CachedNetworkImage(
                            width: 32,
                            fit: BoxFit.cover,
                            imageUrl:
                            'https://imgserv.duellinksmeta.com/v2/dlm/deck-type/${Uri.encodeComponent(_topDecks[index].deckType.name)}?portrait=true&width=50',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            _topDecks[index].skill?.name ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Center(
                          child: CachedNetworkImage(
                            width: 28,
                            fit: BoxFit.cover,
                            imageUrl:
                            'https://wsrv.nl/?url=https://s3.duellinksmeta.com${_topDecks[index].tournamentType?.icon ?? _topDecks[index].rankedType?.icon}&w=100&output=webp&we&n=-1&maxage=7d',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: Row(
                          children: [
                            Assets.images.iconGem.image(width: 16),
                            SizedBox(width: 2,),
                            Text(
                              '${(_topDecks[index].gemsPrice / 1000).toStringAsFixed(0)}k',
                              style: const TextStyle(fontSize: 12),
                            ),
                            if (_topDecks[index].dollarsPrice > 0)
                              Text(
                                '+ \$${_topDecks[index].dollarsPrice}',
                                style: const TextStyle(fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 2),
                        width: 80,
                        child: Text(
                          _topDecks[index].created?.toLocal().format ?? '',
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.right,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
