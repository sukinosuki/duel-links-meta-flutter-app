import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/components/IfElseBox.dart';
import 'package:duel_links_meta/components/MdCardItemView.dart';
import 'package:duel_links_meta/components/MdCardsBoxLayout.dart';
import 'package:duel_links_meta/constant/colors.dart';
import 'package:duel_links_meta/http/CardApi.dart';
import 'package:duel_links_meta/http/SkillApi.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/character/Character.dart';
import 'package:duel_links_meta/type/skill/Skill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../components/SkillModalView.dart';
import '../../type/enum/PageStatus.dart';
import '../cards_viewpager/index.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key, required this.character});

  final Character character;

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Character get character => widget.character;

  var _pageStatus = PageStatus.loading;
  List<Skill> _skills = [];
  List<MdCard> _cards = [];

  List<MdCard> get _dropedCards {
    var list = _cards
        .where((item) => item.obtain.where((obtain) => obtain.source.name == character.name && obtain.type == 'characters' && obtain.subSource == 'Drop').isNotEmpty)
        .toList();

    return list;
  }

  List<MdCard> get _levelUpCards {
    var list = _cards
        .where((item) => item.obtain.where((obtain) => obtain.source.name == character.name && obtain.type == 'characters' && obtain.subSource.contains('Level')).isNotEmpty)
        .toList();

    return list;
  }

  handleTapCardItem(List<MdCard> cards, int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(backgroundColor: Colors.black87.withOpacity(0.3), child: CardsViewpagerPage(cards: cards, index: index)),
    );
  }

  handleTapSkillItem(int index) {
    var skill = _skills[index];

    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black.withOpacity(0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SkillModalView(name: skill.name, skill: skill),
        ),
      ),
    );
  }


  Future _handleRefresh() async {
    if (_pageStatus == PageStatus.success) return;

    var [skillRes, cardsRes] = await Future.wait([
      SkillApi().getByCharacterId(character.oid),
      CardApi().getByObtainSource(character.oid)
    ]);
    if (skillRes.statusCode != 200 || cardsRes.statusCode != 200) {
      setState(() {
        _pageStatus = PageStatus.fail;
      });
      return;
    }

    var skills = skillRes.body!.map((e) => Skill.fromJson(e)).toList();

    var cards = cardsRes.body!.map((e) => MdCard.fromJson(e)).toList();

    setState(() {
      _cards = cards;
      _skills = skills;
      _pageStatus = PageStatus.success;
    });
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show(atTop: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaColors.theme,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: CachedNetworkImage(fit: BoxFit.cover, imageUrl: 'https://s3.duellinksmeta.com${character.victoryImage}'),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [BaColors.theme, BaColors.theme.withOpacity(0)]),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 100,
                      child: Hero(
                        tag: character.name,
                        child: CachedNetworkImage(
                          fit: BoxFit.contain,
                          imageUrl: 'https://s3.duellinksmeta.com${character.thumbnailImage}',
                        ),
                      ),
                    ),
                    Text(
                      character.name,
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    )
                  ],
                ),
              ),

              AnimatedOpacity(
                  opacity: _pageStatus == PageStatus.success ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: IfElseBox(
                    ifTure: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text('Skills', style: TextStyle(color: Colors.white, fontSize: 20)),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(0),
                              itemCount: _skills.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () => handleTapSkillItem(index),
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Image.asset(
                                              _skills[index].archive ? 'assets/images/icon_skill_2.webp' : 'assets/images/icon_skill.webp',
                                              width: 20,
                                              height: 20,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _skills[index].name,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      )),
                                );
                              }),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('Drop Rewards', style: TextStyle(color: Colors.white, fontSize: 20)),
                          ),
                          MdCardsBoxLayout(
                            child: GridView.builder(
                                padding: const EdgeInsets.all(8),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _dropedCards.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 6, childAspectRatio: 0.55),
                                itemBuilder: (context, index) {
                                  return MdCardItemView(
                                    mdCard: _dropedCards[index],
                                    onTap: (card) => handleTapCardItem(_dropedCards, index),
                                  );
                                }),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('Level-Up Rewards', style: TextStyle(color: Colors.white, fontSize: 20)),
                          ),
                          MdCardsBoxLayout(
                            child: GridView.builder(
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _levelUpCards.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 6, childAspectRatio: 0.55),
                                itemBuilder: (context, index) {
                                  return MdCardItemView(
                                    mdCard: _levelUpCards[index],
                                    onTap: (card) => handleTapCardItem(_levelUpCards, index),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                    condition: _pageStatus == PageStatus.success,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
