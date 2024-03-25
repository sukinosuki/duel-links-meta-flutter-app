import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/type/Article.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArticleItem extends StatefulWidget {
  const ArticleItem({super.key, required this.article, this.onTap});

  final Article article;
  final Function? onTap;

  @override
  State<ArticleItem> createState() => _ArticleItemState();
}

class _ArticleItemState extends State<ArticleItem> {
  final format = DateFormat.yMMMMd();

  String coverUrl = '';

  Article get article => super.widget.article;

  @override
  void initState() {
    super.initState();

    coverUrl = "https://wsrv.nl/?url=https://s3.duellinksmeta.com${article.image}&w=520&output=webp&we&n=-1&maxage=7d";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.orange,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: SizedBox(
                height: 120,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () => {
                        widget.onTap?.call(widget.article),
                      },
                      child: Container(
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(milliseconds: 300),
                              placeholder: (context, url) => Container(
                                    color: Colors.purple,
                                  ),
                              errorWidget: (context, url, error) => Container(
                                      decoration: const BoxDecoration(
                                    color: Colors.yellow,
                                  )),
                              imageUrl: coverUrl),
                        ),
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
                            colors: [
                              Colors.black12,
                              Colors.black87,
                            ],
                          )),
                          height: 50,
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.article.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white, fontSize: 16)),
                              Text(
                                'Published ${format.format(widget.article.date!)} by hanamihanamihanamihanamihanamihanami & miiro',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: 10,
              left: 0,
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                color: Colors.pink),
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                child: Text('WIN STREAKS', style: TextStyle(color: Colors.white, fontSize: 10),),
              ))
        ],
      ),
    );
  }
}
