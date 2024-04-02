import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/http/NavTabApi.dart';
import 'package:duel_links_meta/pages/home/type/NavTabType.dart';
import 'package:duel_links_meta/pages/tier_list/index.dart';
import 'package:duel_links_meta/store/AppStore.dart';
import 'package:duel_links_meta/type/NavTab.dart';
import 'package:duel_links_meta/util/storage/LocalStorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../constant/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  int? activeIndex;

  final AppStore appStore = Get.put(AppStore());

  var id2TitleMap = {
    0: 'TIER LIST',
    1: 'TOP DECKS: SPEED',
    2: 'TOP DECKS: RUSH',
    3: 'FRAMING & EVENTS',
    4: 'LEAKS & UPDATES',
    5: 'GEM GUIDE',
    6: 'DECK BUILDER',
    7: 'TOURNAMENTS',
    8: 'DUEL ASSIST',
    9: 'PACK OPENER',
    10: 'DLM SHOP',
  };

  List<NavTab> _navTabs = [];

  handleTapNav(NavTab nav) {
    if (nav.id == NavTabType.tierList.value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const TierListPage()));
      return;
    }
  }

  showSettingModal() async {

    var mode = await LocalStorage_DarkMode.get();

    if (Get.isDarkMode) {
      LocalStorage_DarkMode.save('light');
      Get.changeThemeMode(ThemeMode.light);
      appStore.changeThemeMode(ThemeMode.light);
    } else {
      LocalStorage_DarkMode.save('dark');
      Get.changeThemeMode(ThemeMode.dark);
      appStore.changeThemeMode(ThemeMode.dark);
    }
  }

  void fetchData() async {
    var res = await NavTabApi().list();
    var list = res.body?.map((e) => NavTab.fromJson(e)).toList() ?? [];

    var id2NavTabMap = {};
    for (var element in list) {
      id2NavTabMap[element.id] = element;
    }
    list.sort((a, b) => a.id.compareTo(b.id));

    list.forEach((element) {
      element.title = id2TitleMap[element.id] ?? '';
    });

    setState(() {
      _navTabs = list;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    log('home build');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: showSettingModal,
            icon: Obx(() => Icon(appStore.themeMode.value == ThemeMode.dark ? Icons.nightlight : Icons.sunny)),
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2,
        ),
        itemCount: _navTabs.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              handleTapNav(_navTabs[index]);
            },
            onTapDown: (e) {
              setState(() {
                activeIndex = index;
              });
            },
            onTapCancel: () {
              setState(() {
                activeIndex = null;
              });
            },
            // onTapUp: (e) {
            //   setState(() {
            //     activeIndex = null;
            //   });
            // },
            child: AnimatedScale(
              scale: activeIndex == index ? 0.97 : 1,
              duration: const Duration(milliseconds: 200),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedScale(
                      scale: activeIndex == index ? 1.1 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:
                            'https://wsrv.nl/?url=https://s3.duellinksmeta.com${_navTabs[index].image}&w=360&output=webp&we&n=-1&maxage=7d',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [Colors.black12, Colors.black87],
                        )),
                        height: 30,
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _navTabs[index].title,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
