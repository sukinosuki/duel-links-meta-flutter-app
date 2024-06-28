import 'dart:developer';

import 'package:duel_links_meta/db/Table_NavTab.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/http/NavTabApi.dart';
import 'package:duel_links_meta/pages/farming_and_event/index.dart';
import 'package:duel_links_meta/pages/home/components/NavItemCard.dart';
import 'package:duel_links_meta/pages/home/type/NavTabType.dart';
import 'package:duel_links_meta/pages/tier_list/index.dart';
import 'package:duel_links_meta/pages/webview/index.dart';
import 'package:duel_links_meta/store/AppStore.dart';
import 'package:duel_links_meta/type/NavTab.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/util/storage/LocalStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

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
  void handleTapNav(NavTab nav) {
    if (nav.id == NavTabType.tierList.value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const TierListPage()));
      return;
    }

    if (nav.id == NavTabType.farmingAndEvents.value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const FarmingAndEventPage()));
      return;
    }

    if (nav.id == NavTabType.leaksAndUpdates.value) {
      const url = 'https://www.duellinksmeta.com/leaks-and-updates';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WebviewPage(url: url, title: 'Leaks & Updates'),
        ),
      );
      return;
    }
  }

  //
  Future<void> toggleDarkMode() async {
    MyHive.box.clear();
    MyHive.box2.clear();

    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
      appStore.changeThemeMode(ThemeMode.light);
      MyHive.box.put('dark_mode', 'light');
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      appStore.changeThemeMode(ThemeMode.dark);
      MyHive.box.put('dark_mode', 'dark');
    }
  }

  Future<bool> fetchData({bool force = false}) async {
    const navTabKey = 'nav_tab:list';
    const navTabFetchDateKey = 'nav_tab:fetch_date';
    final hiveData = MyHive.box.get(navTabKey) as List?;
    final expireTime = MyHive.box.get(navTabFetchDateKey) as DateTime?;
    var list = <NavTab>[];

    var refreshFlag = false;
    if (hiveData == null || force) {
      log('需要强制刷新');
      final (err, res) = await NavTabApi().list().toCatch;
      if (err != null) {
        setState(() {
          _pageStatus = PageStatus.fail;
        });
        return false;
      }

      list = res!.map(NavTab.fromJson).toList();
      MyHive.box.put(navTabKey, list);
      MyHive.box.put(navTabFetchDateKey, DateTime.now());
    } else {
      log('本地获取到数据');
      try {
        list = hiveData.cast<NavTab>();
        if (expireTime != null && expireTime.add(Duration(hours: 12)).isBefore(DateTime.now())) {
          log('已过期');
          refreshFlag = true;
        }
      } catch (e) {
        log('解析失败');

        MyHive.box.delete(navTabKey);
        MyHive.box.delete(navTabFetchDateKey);
        return true;
      }
    }

    final id2NavTabMap = <int, NavTab>{};
    for (final element in list) {
      id2NavTabMap[element.id] = element;
    }

    _navTabs.forEach((item) {
      item.image = id2NavTabMap[item.id]?.image ?? '';
    });

    setState(() {
      _navTabs = _navTabs;
      _pageStatus = PageStatus.success;
    });

    return refreshFlag;
  }

  Future<void> handleRefresh() async {
    // if (_pageStatus == PageStatus.success) return;

    await fetchData(force: true);
  }

  Future<void> init() async {
    final flag = await fetchData();
    if (flag) {
      _refreshIndicatorKey.currentState?.show(atTop: true);
    }
  }

  @override
  void initState() {
    super.initState();

    init();
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   _refreshIndicatorKey.currentState?.show(atTop: true);
    // });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Duel Link Meta'),
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
        child: AnimatedOpacity(
          // opacity: _pageStatus == PageStatus.success ? 1 : 0,
          opacity: 1,
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
                child: NavItemCard(navTab: _navTabs[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}
