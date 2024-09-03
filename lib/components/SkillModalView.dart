import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/gen/assets.gen.dart';
import 'package:duel_links_meta/hive/db/SkillHiveDb.dart';
import 'package:duel_links_meta/http/SkillApi.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/skill/Skill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SkillModalView extends StatefulWidget {
  const SkillModalView({required this.name, super.key, this.skill});

  final String name;
  final Skill? skill;

  @override
  State<SkillModalView> createState() => _SkillModalViewState();
}

class _SkillModalViewState extends State<SkillModalView> {
  String get _name => widget.name;
  Skill _skill = Skill();

  var _pageStatus = PageStatus.loading;

  //
  Future<bool> fetchData({bool force = false}) async {
    // await Future.delayed(Duration(seconds: 1));
    // return false;
    var skill = await SkillHiveDb.get(_name);
    final expireTime = await SkillHiveDb.getExpireTime(_name);
    Exception? err;
    var shouldRefresh = false;

    if (skill == null || force) {
      (err, skill) = await SkillApi().getByName(_name).toCatch;
      if (err != null || skill == null) {
        setState(() {
          _pageStatus = PageStatus.fail;
        });
        return false;
      }

      SkillHiveDb.set(skill).ignore();
      SkillHiveDb.setExpireTime(skill.name, DateTime.now().add(const Duration(days: 1))).ignore();
    } else {
      shouldRefresh = expireTime == null || expireTime.isBefore(DateTime.now());
    }

    setState(() {
      _skill = skill!;
      _pageStatus = PageStatus.success;
    });

    return shouldRefresh;
  }

  Future<void> init() async {
    if (widget.skill != null) {
      setState(() {
        _skill = widget.skill!;
        _pageStatus = PageStatus.success;
      });
      return;
    }

    final shouldRefresh = await fetchData();
    if (shouldRefresh) {
      await fetchData(force: true);
    }
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        child: Container(
          // constraints: const BoxConstraints(maxHeight: 400),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            // color: Colors.white,
            image: DecorationImage(image: Assets.images.modalBg.image().image, fit: BoxFit.fitWidth),
            color: Theme.of(context).cardColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Stack(
            children: [
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Text(
                          widget.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_skill.description, style: const TextStyle(fontSize: 12)),
                                const SizedBox(height: 4),
                                if (_skill.relatedCards.isNotEmpty)
                                  SizedBox(
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
                                            const SizedBox(width: 4),
                                          ],
                                        );
                                      },
                                    ),
                                  )
                              ],
                            ),
                            const SizedBox(height: 5),
                            if (_skill.characters.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Characters', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  Container(
                                    height: 42,
                                    child: Scrollbar(
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
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
                                                  imageUrl:
                                                      'https://s3.duellinksmeta.com${_skill.characters[index].character.thumbnailImage}',
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(_skill.characters[index].character.name,
                                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                                  Text(
                                                    _skill.characters[index].how,
                                                    style: const TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 4),
                                            ],
                                          );
                                        },
                                      ),
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
                      ),
                    ),
                  ],
                ),
              ),
              if (_pageStatus == PageStatus.loading)
                const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
