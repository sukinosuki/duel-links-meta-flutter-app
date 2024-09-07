import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/api/SkillApi.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/db/SkillHiveDb.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/skill/Skill.dart';
import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

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
    var skill = await SkillHiveDb().get(_name);
    final expireTime = await SkillHiveDb().getExpireTime(_name);
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

      SkillHiveDb().set(skill).ignore();
      SkillHiveDb().setExpireTime(skill.name, DateTime.now().add(const Duration(days: 1))).ignore();
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
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: Scrollbar(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              Column(
                children: [
                  Text(_skill.description, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  if (_skill.relatedCards.isNotEmpty)
                    SizedBox(
                      height: 65,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _skill.relatedCards.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              CachedNetworkImage(
                                fit: BoxFit.fitWidth,
                                width: 45,
                                imageUrl: 'https://s3.duellinksmeta.com/cards/${_skill.relatedCards[index].oid}_w100.webp',
                                placeholder: (context, url) => Assets.images.cardPlaceholder.image(),
                                errorWidget: (context, url, obj) => Assets.images.cardPlaceholder.image(),
                              ),
                              const SizedBox(width: 4),
                            ],
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 5),
                  if (_skill.characters.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Characters',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: _skill.characters.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40 * 1.16,
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
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                      Text(
                                        _skill.characters[index].how,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
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
                const Positioned(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
