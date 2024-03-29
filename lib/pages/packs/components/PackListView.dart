import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/type/pack_set/PackSet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PackListView extends StatefulWidget {
  const PackListView({super.key, required this.packs});

  final List<PackSet> packs;

  @override
  State<PackListView> createState() => _PackListViewState();
}

class _PackListViewState extends State<PackListView> with AutomaticKeepAliveClientMixin {
  List<PackSet> get _packs => widget.packs;
  final format = DateFormat.yMMMMd();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _packs.length,
        // separatorBuilder: (BuildContext context, int index) {
        //   return const SizedBox(height: 10);
        // },
        itemExtent: 130,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            child: Column(
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      placeholder: (context, url) => Container(color: Colors.white70),
                      fadeInDuration: const Duration(milliseconds: 0),
                      imageUrl: 'https://s3.duellinksmeta.com${_packs[index].bannerImage}',
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Colors.black12,
                              Colors.black87,
                            ],
                          )),
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _packs[index].name,
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              if (_packs[index].release != null)
                                Text(
                                  'Released on ${format.format(_packs[index].release!)}',
                                  style: const TextStyle(color: Colors.white),
                                )
                            ],
                          ),
                        ))
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
