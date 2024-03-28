import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/constant/colors.dart';
import 'package:duel_links_meta/http/CharacterApi.dart';
import 'package:duel_links_meta/pages/character/index.dart';
import 'package:duel_links_meta/type/character/Character.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../http/WorldApi.dart';
import '../../type/enum/PageStatus.dart';
import '../../type/world/World.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  List<Character> _characters = [];
  List<World> _worlds = [];
  int? _index;

  List<Character> get _visibleCharacters {
    if (_index == null) return _characters;

    var value = _worlds[_index!].shortName;

    var list = _characters.where((item) => item.worlds.where((world) => world.shortName == value).isNotEmpty).toList();

    return list;
  }

  var _pageStatus = PageStatus.loading;

  navigateToCharacterPage(Character character) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterPage(character: character),
        ));
  }

  //
  fetchData() async {
    setState(() {
      _pageStatus = PageStatus.loading;
      _characters = [];
    });
    var worldsRes = await WorldApi().list();
    var worlds = worldsRes.body!.map((e) => World.fromJson(e)).toList();

    var res = await CharacterApi().list();
    var list = res.body!.map((e) => Character.fromJson(e)).toList();

    setState(() {
      _characters = list;
      _pageStatus = PageStatus.success;
      _worlds = worlds;
    });
  }

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaColors.theme,
      appBar: AppBar(
        backgroundColor: BaColors.main,
        title: Row(
          children: [
            if (_index != null)
              SizedBox(
                width: 80,
                child: CachedNetworkImage(imageUrl: 'https://s3.duellinksmeta.com${_worlds[_index!].bannerImage}', fit: BoxFit.contain),
              ),
            Text(_index != null ? _worlds[_index!].shortName : 'Characters', style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(onPressed: fetchData, icon: const Icon(Icons.refresh, color: Colors.white)),
          PopupMenuButton(
            onSelected: (v) {
              if (v == _index) return;
              setState(() {
                _index = v;
              });
            },
            itemBuilder: (context) {
              return _worlds
                  .asMap()
                  .entries
                  .map((e) => PopupMenuItem(
                        value: e.key,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 90,
                              child: CachedNetworkImage(fit: BoxFit.fitWidth, imageUrl: 'https://s3.duellinksmeta.com${_worlds[e.key].bannerImage}'),
                            ),
                            Text(_worlds[e.key].shortName)
                          ],
                        ),
                      ))
                  .toList();
            },
          )
        ],
      ),
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: _pageStatus == PageStatus.success ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              itemCount: _visibleCharacters.length,
              itemBuilder: (context, index) {
                return Card(
                  color: BaColors.main,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: InkWell(
                    onTap: () => navigateToCharacterPage(_visibleCharacters[index]),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            // width: double.infinity,
                            child: Hero(
                              tag: _visibleCharacters[index].name,
                              child: SizedBox(
                                width: 70,
                                height: 86,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: 'https://s3.duellinksmeta.com${_visibleCharacters[index].thumbnailImage}',
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              _visibleCharacters[index].name,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12, overflow: TextOverflow.ellipsis, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.6),
            ),
          ),
          if (_pageStatus == PageStatus.loading) const Positioned.fill(child: Center(child: Loading()))
        ],
      ),
    );
  }
}
