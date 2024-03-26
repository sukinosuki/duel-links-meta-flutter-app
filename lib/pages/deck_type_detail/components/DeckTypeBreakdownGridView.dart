import 'package:duel_links_meta/components/MdCardItemView.dart';
import 'package:duel_links_meta/components/MdCardsBoxLayout.dart';
import 'package:duel_links_meta/type/deck_type/DeckType.dart';
import 'package:flutter/material.dart';

class DeckTypeBreakdownGridView extends StatefulWidget {
  const DeckTypeBreakdownGridView({super.key, required this.cards, cross, required this.crossAxisCount});

  final List<DeckType_DeckBreakdownCards> cards;
  final int crossAxisCount;

  @override
  State<DeckTypeBreakdownGridView> createState() => _DeckTypeBreakdownGridViewState();
}

class _DeckTypeBreakdownGridViewState extends State<DeckTypeBreakdownGridView> {
  List<DeckType_DeckBreakdownCards>  get cards => widget.cards;
  int get  crossAxisCount => widget.crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return MdCardsBoxLayout(
      child: Container(
        child: GridView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, mainAxisSpacing: 0, crossAxisSpacing: 6, childAspectRatio: 0.55),
          itemBuilder: (BuildContext context, int index) {
            return MdCardItemView(
              mdCard: cards[index].card,
              trend: cards[index].trend,
              bottomWidget: Container(
                height: 20,
                decoration: const BoxDecoration(color: Color(0xFF2a3650)),
                child: Center(
                  child: Text(
                    '${cards[index].at.toStringAsFixed(0)}x in ${cards[index].per.toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 7, color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
