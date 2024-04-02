import 'dart:developer';

import 'package:duel_links_meta/pages/ban_list_change/components/BanListChangeView.dart';
import 'package:duel_links_meta/pages/ban_list_change/components/BanStatusCardView.dart';
import 'package:flutter/material.dart';

class BanListChangePage extends StatefulWidget {
  const BanListChangePage({super.key});

  @override
  State<BanListChangePage> createState() => _BanListChangePageState();
}

class _BanListChangePageState extends State<BanListChangePage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      log('listen: index: ${_tabController.index}, indexIsChanging: ${_tabController.indexIsChanging}, previousIndex: ${_tabController.previousIndex}');
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          controller: _tabController,
          dividerHeight: 0,
          tabs: const [
            Tab(text: 'Changes'),
            Tab(text: 'Cards'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          BanListChangeView(),
          BanStatusCardView(),
        ],
      ),
    );
  }
}
