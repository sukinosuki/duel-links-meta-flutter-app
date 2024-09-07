import 'package:flutter/material.dart';

class MdCardsBoxLayout extends StatelessWidget {
  const MdCardsBoxLayout({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
        bottom: 0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff385979),
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        image: const DecorationImage(image: AssetImage('assets/images/modal_bg.webp'), fit: BoxFit.fitWidth),
      ),
      child: child,
    );
  }
}
