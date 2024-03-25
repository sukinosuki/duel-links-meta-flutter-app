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
        backgroundColor: BaColors.theme,
        appBar: AppBar(
          backgroundColor: BaColors.main,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: const Text('Tier List', style: TextStyle(color: Colors.white)),

          bottom: TabBar(
            indicatorColor: Colors.transparent,
            controller: _tabController,
            dividerHeight: 0,
            tabs: const [
              Tab(text: 'TOP TIERS'),
              Tab(text: 'POWER RANKINGS'),
              Tab(text: 'RUSH RANKINGS'),
            ],
          ),
        ),
        body: TabBarView(controller: _tabController, children: const [
          TierListView(tierListType: TierListType.topTires),
          TierListView(tierListType: TierListType.powerRankings),
          TierListView(tierListType: TierListType.rushRankings),
        ]));
  }
}
