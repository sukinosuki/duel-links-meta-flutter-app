import 'package:duel_links_meta/pages/farming_and_event/components/EventListView.dart';
import 'package:duel_links_meta/pages/farming_and_event/type/TabType.dart';
import 'package:flutter/material.dart';

class FarmingAndEventPage extends StatefulWidget {
  const FarmingAndEventPage({super.key});

  @override
  State<FarmingAndEventPage> createState() => _FarmingAndEventPageState();
}

class _FarmingAndEventPageState extends State<FarmingAndEventPage> {
  @override
  Widget build(BuildContext context) {

    final tabs = <Widget>[
      Tab(text: TabType.active.value),
      Tab(text: TabType.general.value),
      Tab(text: TabType.past.value),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Farming & Event'),
          bottom: TabBar(
            dividerHeight: 0,
            tabs: tabs,
          ),
        ),
        body: const TabBarView(
          children: [
            EventListView(type: TabType.active),
            EventListView(type: TabType.general),
            EventListView(type: TabType.past),
          ],
        ),
      ),
    );
  }
}
