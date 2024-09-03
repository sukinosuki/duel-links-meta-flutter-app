import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/extension/DateTime.dart';
import 'package:duel_links_meta/pages/articles/type/ArticleCategoryColorMap.dart';
import 'package:duel_links_meta/type/Article.dart';
import 'package:flutter/material.dart';


class ArticleItem extends StatefulWidget {
  const ArticleItem({super.key, required this.article, this.onTap});

  final Article article;
  final Function? onTap;

  @override
  State<ArticleItem> createState() => _ArticleItemState();
}

class _ArticleItemState extends State<ArticleItem> {
  Article get article => super.widget.article;

  String get coverUrl => 'https://wsrv.nl/?url=https://s3.duellinksmeta.com${article.image}&w=520&output=webp&we&n=-1&maxage=7d';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap?.call(widget.article),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              // clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: articleCategoryColorMap[widget.article.category]?.withOpacity(0.3) ?? Colors.grey),
                      imageUrl: coverUrl,
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
                        )),
                        height: 50,
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.article.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              // 'Published ${TimeUtil.format(widget.article.date)}',
                              'Published ${widget.article.date?.format}',
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
          Positioned(
            top: 10,
            left: 0,
            child: CustomPaint(
              painter: _MenuBoxBackground(articleCategoryColorMap[widget.article.category] ?? Colors.grey),
              child: Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: articleCategoryColorMap[widget.article.category] ?? Colors.grey,
                  boxShadow: [
                    BoxShadow(
                      color: (articleCategoryColorMap[widget.article.category] ?? Colors.grey).withOpacity(0.7),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.article.category.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _MenuBoxBackground extends CustomPainter {
  _MenuBoxBackground(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    final double triangleH = 20;
    final double triangleW = 10.0;
    final double width = size.width - 2;
    final double height = size.height;

    final Path trianglePath = Path()
      ..moveTo(width, 0)
      ..lineTo(width + (height / 2.4), height / 2)
      ..lineTo(width, height)
      ..lineTo(width, 0);
    canvas.drawPath(trianglePath, paint);
    // final BorderRadius borderRadius = BorderRadius.circular(4);
    // final Rect rect = Rect.fromLTRB(0, 0, width, height);
    // final RRect outer = borderRadius.toRRect(rect);
    // canvas.drawRRect(outer, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
