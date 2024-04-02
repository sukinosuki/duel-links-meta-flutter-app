import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/pages/pack_detail/index.dart';
import 'package:duel_links_meta/type/pack_set/PackSet.dart';
import 'package:duel_links_meta/util/time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class PackListView extends StatefulWidget {
  const PackListView({super.key, required this.packs});

  final List<PackSet> packs;

  @override
  State<PackListView> createState() => _PackListViewState();
}

class _PackListViewState extends State<PackListView> with AutomaticKeepAliveClientMixin {
  List<PackSet> get _packs => widget.packs;

  handleTapPackItem(PackSet pack) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PackDetailPage(pack: pack)));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        itemCount: _packs.length,
        itemExtent: 118,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => handleTapPackItem(_packs[index]),
            child: Column(
              children: [
                Container(
                  height: 110,
                  child: Card(
                    margin: EdgeInsets.all(0),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: Container(
                        color: Colors.pink,
                        // height: 120,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Hero(
                                  tag: _packs[index].name,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(color: Colors.white70),
                                    fadeInDuration: const Duration(milliseconds: 0),
                                    imageUrl: 'https://s3.duellinksmeta.com${_packs[index].bannerImage}',
                                    fit: BoxFit.cover,
                                    height: 110,
                                    width: double.infinity,
                                  ),
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
                                          colors: [Colors.black12, Colors.black87],
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                                      child: Container(
                                        // color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(_packs[index].name, style: const TextStyle(color: Colors.white, fontSize: 18)),
                                            if (_packs[index].release != null)
                                              Text('Released on ${TimeUtil.format(_packs[index].release)}', style: const TextStyle(color: Colors.white))
                                          ],
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
