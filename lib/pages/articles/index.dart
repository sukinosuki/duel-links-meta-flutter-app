import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001b35),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001427),
        automaticallyImplyLeading: false,
        title: const Text(
          "Articles",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.only(top: 8),
          itemCount: 100,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    height: 120,
                    // decoration: BoxDecoration(boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black12.withOpacity(0.2),
                    //     spreadRadius: 1,
                    //     blurRadius: 10,
                    //     offset: const Offset(1, 1), //
                    //   )
                    // ]),
                    // color: Colors.redAccent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.purple,
                              ),
                              errorWidget: (context, url, error) => Container(
                                  decoration: const BoxDecoration(
                                color: Colors.yellow,
                              )),
                              imageUrl:
                                  "https://wsrv.nl/?url=https://s3.duellinksmeta.com/img/content/tournaments/suisen-weekly/suisen-weekly-thumb.webp&w=520&output=webp&we&n=-1&maxage=7d",
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 8),
                                child: const Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Suisen Weekly #90',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    Text(
                                      'Published March 22nd, 2024 by hanamihanamihanamihanamihanamihanami & miiro',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            );
          }),
    );
  }
}
