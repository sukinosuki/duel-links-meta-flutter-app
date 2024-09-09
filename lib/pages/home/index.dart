import 'package:duel_links_meta/api/NavTabApi.dart';
import 'package:duel_links_meta/components/SettingModalView.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/extension/String.dart';
import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/hive/db/DarkModeHiveDb.dart';
import 'package:duel_links_meta/hive/db/NavHiveDb.dart';
import 'package:duel_links_meta/pages/farming_and_event/index.dart';
import 'package:duel_links_meta/pages/home/components/NavItemCard.dart';
import 'package:duel_links_meta/pages/home/type/NavTabType.dart';
import 'package:duel_links_meta/pages/tier_list/index.dart';
import 'package:duel_links_meta/pages/top_decks/index.dart';
import 'package:duel_links_meta/pages/webview/index.dart';
import 'package:duel_links_meta/store/AppStore.dart';
import 'package:duel_links_meta/type/NavTab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

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
    NavTab(id: NavTabType.leaksAndUpdates.value, title: 'LEAKS & UPDATES', url: 'https://www.duellinksmeta.com/leaks-and-updates'),
    NavTab(id: NavTabType.genGuide.value, title: 'GEM GUIDE', url: 'https://www.duellinksmeta.com/gem-guide'),
    NavTab(id: NavTabType.deckBuilder.value, title: 'DECK BUILDER', url: 'https://www.duellinksmeta.com/deck-tester/'),
    NavTab(id: NavTabType.tournaments.value, title: 'TOURNAMENTS', url: 'https://www.duellinksmeta.com/tournaments'),
    NavTab(id: NavTabType.duelAssist.value, title: 'DUEL ASSIST', url: 'https://www.duellinksmeta.com/duel-assist'),
    NavTab(id: NavTabType.packOpener.value, title: 'PACK OPENER', url: 'https://www.duellinksmeta.com/pack-opening-simulator'),
  ];

  List<NavTab> get _showNavTabs {
    if (appStore.showWebviewNavs.value) return _navTabs;

    return _navTabs.where((element) => element.url == null).toList();
  }

  //
  void handleTapNav(NavTab nav) {
    if (nav.id == NavTabType.tierList.value) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => const TierListPage()),
      );
      return;
    }

    if (nav.id == NavTabType.farmingAndEvents.value) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => const FarmingAndEventPage()),
      );
      return;
    }

    if (nav.id == NavTabType.topDecksRush.value) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => const TopDecksPage(isRush: true)),
      );
      return;
    }

    if (nav.id == NavTabType.topDecksSpeed.value) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => const TopDecksPage(isRush: false)),
      );
      return;
    }

    if (nav.url != null) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => WebviewPage(url: nav.url!, title: nav.title!),
        ),
      );

      return;
    }
  }

  //
  Future<bool> fetchData({bool force = false}) async {
    var navTabList = await HomeHiveDb().getNavTabList();
    final navTabListExpireTime = await HomeHiveDb().getNavTabListExpireTime();
    var shouldRefresh = false;

    if (navTabList == null || force) {
      final (err, res) = await NavTabApi().list().toCatch;

      if (err != null || res == null) return false;

      navTabList = res;
      await HomeHiveDb().setNavTabList(navTabList);
      await HomeHiveDb().setNavTabListExpireTime(DateTime.now().add(const Duration(days: 1)));
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
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _refreshIndicatorKey.currentState?.show();
    });
  }

  Future<void> handleOpenSettingDialog() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const SettingModalView();
      },
    );
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
          IconButton(onPressed: handleOpenSettingDialog, icon: const Icon(Icons.settings_rounded)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: handleRefresh,
        key: _refreshIndicatorKey,
        child: Obx(
          () => GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2,
            ),
            itemCount: _showNavTabs.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => handleTapNav(_showNavTabs[index]),
                child: NavItemCard(navTab: _showNavTabs[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}
