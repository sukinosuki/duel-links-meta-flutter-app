import 'dart:developer';

import 'package:duel_links_meta/components/IfElseBox.dart';
import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/http/PackSetApi.dart';
import 'package:duel_links_meta/pages/packs/components/PackListView.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/pack_set/ExpireData.dart';
import 'package:duel_links_meta/type/pack_set/PackSet.dart';
import 'package:flutter/material.dart';

class PacksPage extends StatefulWidget {
  const PacksPage({super.key});

  @override
  State<PacksPage> createState() => _PacksPageState();
}

class _PacksPageState extends State<PacksPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? _tabController;
  String hiveBoxKey = 'pack_set:list';
  String packSetListLastFetchDateKey = 'pack_set:list_last_fetch_date';

  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  var _pageStatus = PageStatus.loading;
  Map<String, List<PackSet>> _tabsMap = {};

  //
  Future<bool> fetchData({bool force = false}) async {
    var reRefreshFlag = false;

    final hiveValue = MyHive.box.get(hiveBoxKey) as List?;
    final lastFetchDate = MyHive.box.get(packSetListLastFetchDateKey);
    late List<PackSet> list;

    if (hiveValue == null || force) {
      log('无本地数据或者强制刷新');
      final (err, res) = await PackSetApi().list().toCatch;

      if (err != null) {
        setState(() {
          _pageStatus = PageStatus.fail;
        });
        return false;
      }
      list = res!.map(PackSet.fromJson).toList();

      MyHive.box.put(hiveBoxKey, list);
      MyHive.box.put(packSetListLastFetchDateKey, DateTime.now());
    } else {
      log('本地获取到数据');
      try {
        list = hiveValue.map((e) => e as PackSet).toList();

        if (lastFetchDate != null) {
          // 超过刷新时间
          if ((lastFetchDate as DateTime).add(const Duration(seconds: 10)).isBefore(DateTime.now())) {
            log('超过默认的数据有效时间，需要刷新');

            reRefreshFlag = true;
          }
        }
        log('转换成功');
      } catch (e) {
        log('[fetchTopTiers] 转换失败: $e');
        await MyHive.box.delete(hiveBoxKey);
        await MyHive.box.delete(packSetListLastFetchDateKey);
        return true;
      }
    }

    final tabsMap = <String, List<PackSet>>{};

    for (final item in list) {
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

  Future<void> init() async {
    final needRefresh = await fetchData();
    if (needRefresh) {
      await _refreshIndicatorKey.currentState?.show(atTop: true);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> _handleRefresh() async {
    await fetchData(force: true);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      notificationPredicate: (_) => _pageStatus != PageStatus.loading,
      onRefresh: _handleRefresh,
      child: Stack(
        children: [
          if (_pageStatus == PageStatus.success)
            Scaffold(
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
              body: IfElseBox(
                condition: _tabController != null,
                ifTure: TabBarView(
                  controller: _tabController,
                  children: _tabsMap.values.map((packs) => PackListView(packs: packs)).toList(),
                ),
              ),
            ),
          if (_pageStatus == PageStatus.loading) const Positioned.fill(child: Center(child: Loading())),
          if (_pageStatus == PageStatus.fail)
            Positioned.fill(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('加载失败'),
                  ElevatedButton(onPressed: _refreshIndicatorKey.currentState?.show, child: const Text('刷新')),
                ],
              ),
            )
          // Positioned.fill(child: Container(color: Colors.orange, child: Center(child: Text('失败'))))
        ],
      ),
    );
  }
}
