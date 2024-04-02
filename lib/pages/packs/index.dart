import 'dart:developer';

import 'package:duel_links_meta/components/IfElseBox.dart';
import 'package:duel_links_meta/constant/colors.dart';
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
  var _pageStatus = PageStatus.loading;
  TabController? _tabController = null;

  Map<String, List<PackSet>> tabsMap = {};

  fetchData() async {
    var res = await PackSetApi().list();
    var list = res.body!.map((e) => PackSet.fromJson(e)).toList();

    Map<String, List<PackSet>> m = {};

    for (var item in list) {
      if (m[item.type] == null) {
        m[item.type] = [item];
      } else {
        m[item.type]!.add(item);
      }
    }

    setState(() {
      _tabController = TabController(length: m.length, vsync: this);
      tabsMap = m;
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
    return Scaffold(
        appBar: AppBar(
          // title: const Text('Packs'),
          title: _tabController != null
              ? TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  dividerHeight: 0,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: tabsMap.keys.map((key) => Tab(text: key)).toList(),
                )
              : null,
        ),
        body: IfElseBox(
          condition: _tabController != null,
          ifTure: TabBarView(
            controller: _tabController,
            children: tabsMap.values.map((packs) => PackListView(packs: packs)).toList(),
          ),
        ));
  }
}
