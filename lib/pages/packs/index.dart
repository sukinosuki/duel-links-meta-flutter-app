import 'dart:developer';

import 'package:duel_links_meta/components/IfElseBox.dart';
import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/http/PackSetApi.dart';
import 'package:duel_links_meta/pages/packs/components/PackListView.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/pack_set/PackSet.dart';
import 'package:flutter/material.dart';

class PacksPage extends StatefulWidget {
  const PacksPage({super.key});

  @override
  State<PacksPage> createState() => _PacksPageState();
}

class _PacksPageState extends State<PacksPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? _tabController;

  var _pageStatus = PageStatus.loading;
  Map<String, List<PackSet>> _tabsMap = {};

  fetchData() async {
    var (err, res) = await PackSetApi().list().toCatch;

    if (err != null) {
      setState(() {
        _pageStatus = PageStatus.fail;
      });
      return;
    }

    var list = res!.map((e) => PackSet.fromJson(e)).toList();

    Map<String, List<PackSet>> tabsMap = {};

    for (var item in list) {
      if (tabsMap[item.type] == null) {
        tabsMap[item.type] = [item];
      } else {
        tabsMap[item.type]!.add(item);
      }
    }

    setState(() {
      _tabController = TabController(length: tabsMap.length, vsync: this);
      _tabsMap = tabsMap;
      _pageStatus = PageStatus.success;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
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
    return Stack(
      children: [
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
            )),
        if (_pageStatus == PageStatus.loading) const Positioned.fill(child: Center(child: Loading()))
      ],
    );
  }
}
