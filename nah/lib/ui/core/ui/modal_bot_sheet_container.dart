import 'package:flutter/material.dart';

class ModalBotSheetContainer extends StatelessWidget {
  const ModalBotSheetContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          color: Theme.of(context).bottomSheetTheme.backgroundColor,
        ),
        child: child,
      ),
    );
  }
}
