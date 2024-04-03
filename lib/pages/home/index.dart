import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/http/NavTabApi.dart';
import 'package:duel_links_meta/pages/farming_and_event/index.dart';
import 'package:duel_links_meta/pages/home/type/NavTabType.dart';
import 'package:duel_links_meta/pages/tier_list/index.dart';
import 'package:duel_links_meta/pages/webview/index.dart';
import 'package:duel_links_meta/store/AppStore.dart';
import 'package:duel_links_meta/type/NavTab.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/util/storage/LocalStorage.dart';
import 'package:flutter/cupertino.dart';
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
  var _pageStatus = PageStatus.loading;

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

    if (nav.id == NavTabType.farmingAndEvents.value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const FarmingAndEventPage()));
      return;
    }

    if (nav.id == NavTabType.leaksAndUpdates.value) {
      var url = 'https://www.duellinksmeta.com/leaks-and-updates';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebviewPage(url: url, title: 'Leaks & Updates'),
        ),
      );
      return;
    }
  }

  toggleDarkMode() async {
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
      _pageStatus = PageStatus.success;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: toggleDarkMode,
            icon: Obx(() => Icon(appStore.themeMode.value == ThemeMode.dark ? Icons.nightlight : Icons.sunny)),
          )
        ],
      ),
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: _pageStatus == PageStatus.success ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                  child: Card(
                    margin: const EdgeInsets.all(0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            fit: BoxFit.cover,
                            fadeOutDuration: null,
                            fadeInDuration: const Duration(milliseconds: 0),
                            imageUrl:
                                'https://wsrv.nl/?url=https://s3.duellinksmeta.com${_navTabs[index].image}&w=360&output=webp&we&n=-1&maxage=7d',
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
          ),
          if (_pageStatus == PageStatus.loading)
            const Positioned.fill(
                child: Center(
              child: Loading(),
            ))
        ],
      ),
    );
  }
}
