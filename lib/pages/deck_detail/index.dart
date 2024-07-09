import 'dart:developer';

import 'package:duel_links_meta/pages/deck_detail/components/DeckInfo.dart';
import 'package:duel_links_meta/type/top_deck/TopDeck.dart';
import 'package:flutter/material.dart';

class DeckDetailPage extends StatefulWidget {
  const DeckDetailPage({super.key, required this.topDeck});

  final TopDeck topDeck;

  @override
  State<DeckDetailPage> createState() => _DeckDetailPageState();
}

class _DeckDetailPageState extends State<DeckDetailPage> {

  TopDeck get _topDeck => widget.topDeck;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_topDeck.deckType.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            DeckInfo(topDeck: _topDeck, loadingVisible: false,),
          ],
        ),
      ),
    );
  }
}
