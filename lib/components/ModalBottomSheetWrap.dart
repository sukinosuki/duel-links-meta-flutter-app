import 'package:flutter/material.dart';

class ModalBottomSheetWrap extends StatelessWidget {
  const ModalBottomSheetWrap({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(34),
          topRight: Radius.circular(34),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: ColoredBox(
          color: Theme.of(context).colorScheme.onPrimary,
          child: SingleChildScrollView(
            child: Column(
              children: [
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
