import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/components/IfElseBox.dart';
import 'package:duel_links_meta/constant/colors.dart';
import 'package:duel_links_meta/pages/cards_viewpager/CardView.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class CardsViewpagerPage extends StatefulWidget {
  const CardsViewpagerPage({super.key, required this.cards, required this.index});

  final List<MdCard> cards;
  final int index;

  @override
  State<CardsViewpagerPage> createState() => _CardsViewpagerPageState();
}

class _CardsViewpagerPageState extends State<CardsViewpagerPage> {
  List<MdCard> get mdCards => widget.cards;

  int get index => widget.index;
  late PageController _controller;
  var animationFlag = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: index);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        animationFlag = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: animationFlag ? 1 : 1.05,
      duration: const Duration(milliseconds: 100),
      child: AnimatedOpacity(
        opacity: animationFlag ? 1 : 0,
        duration: const Duration(milliseconds: 100),
        child: PageView(
            controller: _controller,
            children: mdCards
                .map((card) => Container(
                      // color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: CardView(card: card)
                      ),
                    ))
                .toList()),
      ),
    );
  }
}
