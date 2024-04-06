import 'dart:developer';

import 'package:duel_links_meta/db/Table_NavTab.dart';
import 'package:duel_links_meta/db/index.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/http/NavTabApi.dart';
import 'package:duel_links_meta/pages/farming_and_event/index.dart';
import 'package:duel_links_meta/pages/home/components/NavItemCard.dart';
import 'package:duel_links_meta/pages/home/type/NavTabType.dart';
import 'package:duel_links_meta/pages/tier_list/index.dart';
import 'package:duel_links_meta/pages/webview/index.dart';
import 'package:duel_links_meta/store/AppStore.dart';
import 'package:duel_links_meta/type/NavTab.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/util/index.dart';
import 'package:duel_links_meta/util/storage/LocalStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  var _pageStatus = PageStatus.loading;

  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final AppStore appStore = Get.put(AppStore());

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

  //
  toggleDarkMode() async {
    log('Table_NavTab.instance ${Table_NavTab.instance.hashCode}, is equal: ${Table_NavTab.instance == Table_NavTab.instance}');
    // Db.deleteDatabase();

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

  Future<void> fetchData() async {
    Table_NavTab.instance.query().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          _pageStatus = PageStatus.success;
          _navTabs = value.map((e) => NavTab.fromJson(e)).toList();
        });
      }
    });

    var (err, res) = await NavTabApi().list().toCatch;
    if (err != null) {
      setState(() {
        _pageStatus = PageStatus.fail;
      });
      return;
    }

    var list = res!.map((e) => NavTab.fromJson(e)).toList();

    var id2NavTabMap = {};
    for (var element in list) {
      id2NavTabMap[element.id] = element;
    }

    _navTabs.forEach((item) {
      item.image = id2NavTabMap[item.id].image ?? '';
    });

    setState(() {
      _navTabs = _navTabs;
      _pageStatus = PageStatus.success;
    });

    //
    await Table_NavTab.instance.delete();

    _navTabs.forEach((element) async {
      await Table_NavTab.instance.insert(element.toJson());
    });
  }

  Future handleRefresh() async {
    if (_pageStatus == PageStatus.success) return;

    await fetchData();
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show(atTop: true);
    });
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
      body: RefreshIndicator(
        onRefresh: handleRefresh,
        key: _refreshIndicatorKey,
        child: Stack(
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
                      child: NavItemCard(navTab: _navTabs[index]));
                },
              ),
            ),
            // if (_pageStatus == PageStatus.loading)
            //   const Positioned.fill(
            //     child: Center(
            //       child: Loading(),
            //     ),
            //   )
          ],
        ),
      ),
    );
  }
}
