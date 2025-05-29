import 'package:flutter/material.dart';
import 'package:nah/ui/core/ui/no_data.dart';

class SliverListEmpty extends StatelessWidget {
  const SliverListEmpty({
    super.key,
    required this.message,
    required this.emptyGender,
  });
  final String message;
  final String emptyGender;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          NoData(gender: emptyGender),
        ],
      ),
    );
  }
}
