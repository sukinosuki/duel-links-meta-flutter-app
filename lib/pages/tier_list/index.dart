import 'package:duel_links_meta/constant/colors.dart';
import 'package:duel_links_meta/pages/tier_list/components/TierListPageView.dart';
import 'package:duel_links_meta/pages/tier_list/type/TierListType.dart';
import 'package:flutter/material.dart';

class TierListPage extends StatefulWidget {
  const TierListPage({super.key});

  @override
  State<TierListPage> createState() => _TierListPageState();
}

class _TierListPageState extends State<TierListPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // iconTheme: const IconThemeData(opticalSize: 12),
        title: const Text('Tier List'),
        bottom: TabBar(
          // indicatorColor: Colors.transparent,
          controller: _tabController,
          // dividerHeight: 0,
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
