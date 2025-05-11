import 'package:flutter/material.dart';

class SliverListEmpty extends StatelessWidget {
  const SliverListEmpty({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(child: Text(message, style: const TextStyle(fontSize: 16))),
    );
  }
}
