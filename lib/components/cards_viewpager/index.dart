import 'package:duel_links_meta/type/MdCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'CardView.dart';

class CardsViewpagerPage extends StatefulWidget {
  const CardsViewpagerPage({required this.cards, required this.index, super.key});

  final List<MdCard> cards;
  final int index;

  @override
  State<CardsViewpagerPage> createState() => _CardsViewpagerPageState();
}

class _CardsViewpagerPageState extends State<CardsViewpagerPage> {
  List<MdCard> get _mdCards => widget.cards;

  int get initialIndex => widget.index;

  late PageController _pageController;
  bool _animationFlag = false;

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: initialIndex);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _animationFlag = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _animationFlag ? 1 : 1.05,
      duration: const Duration(milliseconds: 100),
      child: AnimatedOpacity(
        opacity: _animationFlag ? 1 : 0,
        duration: const Duration(milliseconds: 100),
        child: PageView(
          controller: _pageController,
          children: _mdCards
              .map(
                (card) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CardView(card: card),
                      SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            card.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
