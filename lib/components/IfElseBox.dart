import 'package:flutter/material.dart';

class IfElseBox extends StatelessWidget {
  const IfElseBox({super.key, required this.ifTure, this.elseTrue, required this.condition});

  final bool condition;
  final Widget? ifTure;
  final Widget? elseTrue;

  Widget?  get target => condition ? ifTure : elseTrue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: target,
    );
  }
}
