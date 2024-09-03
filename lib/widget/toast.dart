import 'package:flutter/material.dart';

class ToastWidget extends StatelessWidget {
  const ToastWidget({required this.msg, super.key});

  final String msg;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
