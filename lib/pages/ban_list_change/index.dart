
import 'package:duel_links_meta/pages/ban_list_change/components/BanListChangeView.dart';
import 'package:duel_links_meta/pages/ban_list_change/components/BanStatusCardView.dart';
import 'package:flutter/material.dart';

class BanListChangePage extends StatefulWidget {
  const BanListChangePage({super.key});

  @override
  State<BanListChangePage> createState() => _BanListChangePageState();
}

class _BanListChangePageState extends State<BanListChangePage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            dividerHeight: 0,
            tabs: [
              Tab(text: 'Changes'),
              Tab(text: 'Cards'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BanListChangeView(),
            BanStatusCardView(),
          ],
        ),
      ),
    );
  }
}
