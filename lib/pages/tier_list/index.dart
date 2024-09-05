import 'package:duel_links_meta/pages/tier_list/components/TierListView.dart';
import 'package:duel_links_meta/pages/tier_list/type/TierListType.dart';
import 'package:duel_links_meta/store/AppStore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TierListPage extends StatefulWidget {
  const TierListPage({super.key});

  @override
  State<TierListPage> createState() => _TierListPageState();
}

class _TierListPageState extends State<TierListPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);

  AppStore appStore = Get.put(AppStore());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tier List') ,
        bottom: TabBar(
          controller: _tabController,
          dividerHeight: 0,
          tabs: const [
            Tab(text: 'TOP TIERS'),
            Tab(text: 'POWER RANKINGS'),
            Tab(text: 'RUSH RANKINGS'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    TierListView(
                      tierListType: TierListType.topTires,
                      minHeight: constraints.minHeight,
                    ),
                    TierListView(
                      tierListType: TierListType.powerRankings,
                      minHeight: constraints.minHeight,
                    ),
                    TierListView(
                      tierListType: TierListType.rushRankings,
                      minHeight: constraints.minHeight,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
