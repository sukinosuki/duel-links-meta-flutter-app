import 'dart:developer';

import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/http/NavTabApi.dart';
import 'package:duel_links_meta/pages/about/index.dart';
import 'package:duel_links_meta/pages/farming_and_event/index.dart';
import 'package:duel_links_meta/hive/db/NavHiveDb.dart';
import 'package:duel_links_meta/pages/home/components/NavItemCard.dart';
import 'package:duel_links_meta/pages/home/type/NavTabType.dart';
import 'package:duel_links_meta/pages/open_source_licenses/index.dart';
import 'package:duel_links_meta/pages/tier_list/index.dart';
import 'package:duel_links_meta/pages/top_decks/index.dart';
import 'package:duel_links_meta/pages/webview/index.dart';
import 'package:duel_links_meta/store/AppStore.dart';
import 'package:duel_links_meta/type/NavTab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final AppStore appStore = Get.put(AppStore());

  var _isInit = false;

  List<NavTab> _navTabs = [
    NavTab(id: NavTabType.tierList.value, title: 'TIER LIST'),
    NavTab(id: NavTabType.topDecksSpeed.value, title: 'TOP DECK: SPEED'),
    NavTab(id: NavTabType.topDecksRush.value, title: 'TOP DECKS: RUSH'),
    NavTab(id: NavTabType.farmingAndEvents.value, title: 'FARMING & EVENTS'),
    NavTab(id: NavTabType.leaksAndUpdates.value, title: 'LEAKS & UPDATES'),
    NavTab(id: NavTabType.genGuide.value, title: 'GEM GUIDE'),
    NavTab(id: NavTabType.deckBuilder.value, title: 'DECK BUILDER'),
    NavTab(id: NavTabType.tournaments.value, title: 'TOURNAMENTS'),
    NavTab(id: NavTabType.duelAssist.value, title: 'DUEL ASSIST'),
    NavTab(id: NavTabType.packOpener.value, title: 'PACK OPENER'),
  ];

  //
  void handleTapNav(NavTab nav) {
    if (nav.id == NavTabType.tierList.value) {
      Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const TierListPage()));
      return;
    }

    if (nav.id == NavTabType.farmingAndEvents.value) {
      Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const FarmingAndEventPage()));
      return;
    }

    if (nav.id == NavTabType.topDecksRush.value) {
      Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const TopDecksPage(isRush: true)));
      return;
    }

    if (nav.id == NavTabType.topDecksSpeed.value) {
      Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const TopDecksPage(isRush: false)));
      return;
    }

    if (nav.id == NavTabType.leaksAndUpdates.value) {
      const url = 'https://www.duellinksmeta.com/leaks-and-updates';

      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => const WebviewPage(url: url, title: 'Leaks & Updates'),
        ),
      );
      return;
    }
  }

  //
  Future<void> toggleDarkMode() async {
    // TODO
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
      // appStore.changeThemeMode(ThemeMode.light);
      MyHive.box2.put('dark_mode', 'light').ignore();
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      // appStore.changeThemeMode(ThemeMode.dark);
      MyHive.box2.put('dark_mode', 'dark').ignore();
    }
  }

  //
  Future<bool> fetchData({bool force = false}) async {
    var navTabList = await HomeHiveDb.getNavTabList();
    final navTabListExpireTime = await HomeHiveDb.getNavTabListExpireTime();
    var shouldRefresh = false;

    if (navTabList == null || force) {
      final (err, res) = await NavTabApi().list().toCatch;

      if (err != null || res == null) return false;

      navTabList = res;
      await HomeHiveDb.setNavTabList(navTabList);
      // set 1 day expire
      await HomeHiveDb.setNavTabListExpireTime(DateTime.now().add(const Duration(days: 1)));
    } else {
      if (navTabListExpireTime == null || navTabListExpireTime.isBefore(DateTime.now())) {
        shouldRefresh = true;
      }
    }

    final id2NavTabMap = <int, NavTab>{};
    navTabList.forEach((element) {
      id2NavTabMap[element.id] = element;
    });

    _navTabs.forEach((element) {
      element.image = id2NavTabMap[element.id]?.image ?? '';
    });

    setState(() {
      _navTabs = _navTabs;
    });

    return shouldRefresh;
  }

  //
  Future<void> handleRefresh() async {
    final shouldRefresh = await fetchData(force: _isInit);
    _isInit = true;

    if (shouldRefresh) {
      await fetchData(force: true);
    }
  }

  void init() {
    // trigger refresh indicator when page initialized
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _refreshIndicatorKey.currentState?.show();
    });
  }

  void _handleOpenSettingDialog() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    log("packageInfo ${packageInfo.toString()}");

    await showModalBottomSheet<void>(
        context: context,
        // backgroundColor: Theme.of(context).colorScheme.surface,
        // backgroundColor: Colors.orange,
        builder: (context) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            child: Container(
              // height: 300,
              padding: const EdgeInsets.only(top: 30),
              color: Theme.of(context).colorScheme.onPrimary,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 40),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Setting',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Text('Theme mode'),
                          ),
                          Row(
                            children: [
                              IconButton(
                                isSelected: !Get.isDarkMode,
                                onPressed: () {
                                  Get.changeThemeMode(ThemeMode.light);
                                  // TODO
                                  MyHive.box2.put('dark_mode', 'light').ignore();
                                },
                                icon: const Icon(Icons.sunny),
                              ),
                              IconButton(
                                isSelected: Get.isDarkMode,
                                onPressed: () {
                                  Get.changeThemeMode(ThemeMode.dark);
                                  MyHive.box2.put('dark_mode', 'dark').ignore();
                                },
                                icon: const Icon(Icons.nightlight_rounded),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      child: Text(
                        'About',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    // Material(
                    //   color: Colors.transparent,
                    //   child: InkWell(
                    //     onTap: () {
                    //       Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const AboutPage()));
                    //     },
                    //     child: Container(
                    //       height: 50,
                    //       padding: const EdgeInsets.symmetric(horizontal: 12),
                    //       child: const Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //             'About this project',
                    //             overflow: TextOverflow.ellipsis,
                    //           ),
                    //           Icon(Icons.arrow_forward),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [const Text('App version'), Text(packageInfo.version)],
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [const Text('Build signature'), Text(packageInfo.buildSignature.substring(0, 6))],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const OpenSourceLicensePage()));
                        },
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('Github'), Icon(Icons.arrow_forward)],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const OpenSourceLicensePage()));
                        },
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('Open source licenses'), Icon(Icons.arrow_forward)],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Duel Links Meta'),
        actions: [
          // IconButton(
          //   onPressed: toggleDarkMode,
          //   icon: Obx(() => Icon(appStore.themeMode.value == ThemeMode.dark ? Icons.nightlight : Icons.sunny)),
          // ),
          IconButton(onPressed: _handleOpenSettingDialog, icon: const Icon(Icons.settings))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: handleRefresh,
        key: _refreshIndicatorKey,
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
              onTap: () => handleTapNav(_navTabs[index]),
              child: NavItemCard(navTab: _navTabs[index]),
            );
          },
        ),
      ),
    );
  }
}
