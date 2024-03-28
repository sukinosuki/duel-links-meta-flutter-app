import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/constant/colors.dart';
import 'package:duel_links_meta/http/SkillApi.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/skill/Skill.dart';
import 'package:flutter/material.dart';

class SkillModalView extends StatefulWidget {
  const SkillModalView({super.key, required this.name, this.skill});

  final String name;
  final Skill? skill;

  @override
  State<SkillModalView> createState() => _SkillModalViewState();
}

class _SkillModalViewState extends State<SkillModalView> {
  String get name => widget.name;
  Skill _skill = Skill();

  var _pageStatus = PageStatus.loading;

  fetchData() async {
    if (widget.skill != null) {
      _skill = widget.skill!;
      _pageStatus = PageStatus.success;
      return;
    }

    // var _name = 'The Legend of the Heroes';
    // var _name = 'Monster Move';
    var res = await SkillApi().getByName(name);
    log('res ${res.body}, status: ${res.status.code}');

    var skill = res.body!;

    setState(() {
      _skill = skill;
      _pageStatus = PageStatus.success;
    });
  }

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/modal_bg.webp'), fit: BoxFit.fitWidth),
                color: Colors.black,
              ),
              // constraints: BoxConstraints(
              //   minHeight: 200, maxHeight: 400
              // ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Stack(
                children: [
                  if (_pageStatus == PageStatus.success)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.black12,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _skill.name,
                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
                              ),
                              Text(_skill.description, style: const TextStyle(color: Colors.white, fontSize: 12)),
                              const SizedBox(height: 4),
                              if (_skill.relatedCards.isNotEmpty)
                                Container(
                                  height: 60,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _skill.relatedCards.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Container(
                                              color: Colors.white38,
                                              height: 60,
                                              width: 60 / 1.4,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: 'https://s3.duellinksmeta.com/cards/${_skill.relatedCards[index].oid}_w100.webp',
                                              ),
                                            ),
                                            const SizedBox(width: 4)
                                          ],
                                        );
                                      }),
                                )
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        if (_skill.characters.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Characters', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                              Container(
                                height: 42,
                                child: Scrollbar(
                                  child: ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _skill.characters.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Container(
                                              width: 36,
                                              height: 42,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: 'https://s3.duellinksmeta.com${_skill.characters[index].character.thumbnailImage}',
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(_skill.characters[index].character.name,
                                                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                                                Text(_skill.characters[index].how, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                              ],
                                            ),
                                            const SizedBox(width: 8)
                                          ],
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        if (_skill.source != '')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Source', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                              Text(_skill.source, style: const TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          )
                      ],
                    ),
                  if (_pageStatus == PageStatus.loading)
                    const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      ),
                    )
                ],
              )),
        ),
      ),
    );
  }
}
