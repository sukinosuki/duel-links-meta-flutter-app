import 'package:duel_links_meta/components/MdCardItemView2.dart';
import 'package:duel_links_meta/components/cards_viewpager/index.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/deck_type/DeckType.dart';
import 'package:flutter/material.dart';

class DeckTypeBreakdownGridView extends StatefulWidget {
  const DeckTypeBreakdownGridView({required this.cards, required this.crossAxisCount, super.key});

  final List<DeckType_DeckBreakdownCards> cards;
  final int crossAxisCount;

  @override
  State<DeckTypeBreakdownGridView> createState() => _DeckTypeBreakdownGridViewState();
}

class _DeckTypeBreakdownGridViewState extends State<DeckTypeBreakdownGridView> {
  List<DeckType_DeckBreakdownCards> get cards => widget.cards;

  int get crossAxisCount => widget.crossAxisCount;

  List<MdCard> get _cards {
    return cards.map((e) => e.card).toList();
  }

  void handleTapCardItem(int index) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black87.withOpacity(0.3),
        child: CardsViewpagerPage(cards: _cards, index: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, mainAxisSpacing: 0, crossAxisSpacing: 6, childAspectRatio: 0.55),
          itemBuilder: (BuildContext context, int index) {
            return MdCardItemView2(
              mdCard: cards[index].card,
              trend: cards[index].trend,
              onTap: (card) => handleTapCardItem(index),
              bottomWidget: Container(
                height: 18,
                decoration: const BoxDecoration(color: Color(0xFF2a3650)),
                child: Center(
                  child: Text(
                    '${cards[index].at.toStringAsFixed(0)}x in ${cards[index].per.toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 7, color: Colors.white),
                  ),
                ),
              ),
              id: cards[index].card.oid,
            );
          },
        ),
      ),
    );
  }
}
