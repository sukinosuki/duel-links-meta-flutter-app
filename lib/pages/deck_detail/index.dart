import 'dart:developer';

import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/pages/deck_detail/components/DeckInfo.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/top_deck/TopDeck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../http/TopDeckApi.dart';

class DeckDetailPage extends StatefulWidget {
  const DeckDetailPage({required this.topDeck, super.key});

  final TopDeck topDeck;

  @override
  State<DeckDetailPage> createState() => _DeckDetailPageState();
}

class _DeckDetailPageState extends State<DeckDetailPage> {
  TopDeck get _topDeck => widget.topDeck;
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  PageStatus _pageStatus = PageStatus.loading;

  TopDeck? __topDeck;

  //
  Future<void> fetchData({bool force = false}) async {
    final params = <String, String>{
      'limit': '1',
      'url': _topDeck.url!,
    };

    final (topDeckErr, topDeck) = await TopDeckApi().getBreakdownSample(params).toCatch;

    if (topDeckErr != null || topDeck == null) {
      setState(() {
        _pageStatus = PageStatus.fail;
      });
      return;
    }

    setState(() {
      _pageStatus = PageStatus.success;
      __topDeck = topDeck;
    });
  }

  Future<void> _handleRefresh() async {
    await fetchData();
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_topDeck.deckType.name),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              child: _pageStatus == PageStatus.success
                  ? DeckInfo(
                      topDeck: __topDeck,
                      loadingVisible: false,
                    )
                  : null,
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
