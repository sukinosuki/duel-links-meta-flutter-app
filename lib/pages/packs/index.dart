import 'dart:developer';

import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/db/PacksHiveDb.dart';
import 'package:duel_links_meta/http/PackSetApi.dart';
import 'package:duel_links_meta/pages/packs/components/PackListView.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/pack_set/PackSet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class PacksPage extends StatefulWidget {
  const PacksPage({super.key});

  @override
  State<PacksPage> createState() => _PacksPageState();
}

class _PacksPageState extends State<PacksPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? _tabController;
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var _pageStatus = PageStatus.loading;
  var _isInit = false;
  Map<String, List<PackSet>> _tabsMap = {};

  //
  Future<bool> fetchData({bool force = false}) async {
    var reRefreshFlag = false;

    var packs = await PackHiveDb.get();
    final expireTime = await PackHiveDb.getExpireTime();

    if (packs == null || force) {
      if (packs == null) {
        log('无本地数据');
      }
      if (force) {
        log('强制刷新');
      }
      final (err, res) = await PackSetApi().list().toCatch;

      if (err != null || res == null) {
        setState(() {
          _pageStatus = PageStatus.fail;
        });
        return false;
      }
      packs = res;
      PackHiveDb.set(packs).ignore();
      PackHiveDb.setExpireTime(DateTime.now().add(const Duration(days: 1))).ignore();
    } else {
      log('本地获取到数据');
      reRefreshFlag = expireTime == null || expireTime.isBefore(DateTime.now());
    }

    final tabsMap = <String, List<PackSet>>{};

    for (final item in packs) {
      if (tabsMap[item.type] == null) {
        tabsMap[item.type] = [item];
      } else {
        tabsMap[item.type]!.add(item);
      }
    }

    if (_tabController == null) {
      setState(() {
        _tabController = TabController(length: tabsMap.length, vsync: this);
      });
    }
    setState(() {
      _tabsMap = tabsMap;
      _pageStatus = PageStatus.success;
    });

    return reRefreshFlag;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  Future<void> _handleRefresh() async {
    final needRefresh = await fetchData(force: _isInit);

    _isInit = true;

    if (needRefresh) {
      await fetchData(force: true);
    }
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      // 如果子控件是可滚动的, 需要声明notificationPredicate
      notificationPredicate: (_) => _pageStatus != PageStatus.loading,
      onRefresh: _handleRefresh,
      child: Scaffold(
        appBar: AppBar(
          title: _tabController != null
              ? TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  dividerHeight: 0,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: _tabsMap.keys.map((key) => Tab(text: key)).toList(),
                )
              : null,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (_tabController != null)
              TabBarView(
                controller: _tabController,
                children: _tabsMap.values.map((packs) => PackListView(packs: packs)).toList(),
              ),
            if (_pageStatus == PageStatus.fail)
              const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
              ),
            if (_pageStatus == PageStatus.fail)
              const Center(
                child: Text('Loading failed'),
              ),
          ],
        ),
      ),
    );
  }
}
