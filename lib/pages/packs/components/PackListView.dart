import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/extension/DateTime.dart';
import 'package:duel_links_meta/pages/pack_detail/index.dart';
import 'package:duel_links_meta/type/pack_set/PackSet.dart';
import 'package:flutter/material.dart';

class PackListView extends StatefulWidget {
  const PackListView({required this.packs, super.key});

  final List<PackSet> packs;

  @override
  State<PackListView> createState() => _PackListViewState();
}

class _PackListViewState extends State<PackListView> with AutomaticKeepAliveClientMixin {
  List<PackSet> get _packs => widget.packs;

  Future<void> handleTapPackItem(PackSet pack) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => PackDetailPage(pack: pack)),
    );
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
        return Column(
          children: [
            SizedBox(
              height: 110,
              child: OpenContainer(
                openColor: Colors.transparent,
                closedColor: Colors.transparent,
                openElevation: 0,
                closedElevation: 0,
                closedBuilder: (BuildContext context, void Function() action) {
                  return Card(
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                    clipBehavior: Clip.hardEdge,
                    shadowColor: Colors.transparent,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: 'https://s3.duellinksmeta.com${_packs[index].bannerImage}',
                          fit: BoxFit.cover,
                          height: 110,
                          width: double.infinity,
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
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_packs[index].name, style: const TextStyle(color: Colors.white, fontSize: 18)),
                                if (_packs[index].release != null)
                                  Text(
                                    'Released on ${_packs[index].release?.format}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                openBuilder: (BuildContext context, void Function({Object? returnValue}) action) {
                  return PackDetailPage(pack: _packs[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
