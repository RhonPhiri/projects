import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class OpenContainerTransition extends StatelessWidget {
  const OpenContainerTransition({
    super.key,
    required this.closedBuilderWidget,
    required this.openBuilderWidget,
  });
  final Widget closedBuilderWidget;
  final Widget openBuilderWidget;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      closedColor: Theme.of(context).colorScheme.surface,
      transitionDuration: const Duration(milliseconds: 500),
      transitionType: ContainerTransitionType.fade,
      closedBuilder: (context, action) => closedBuilderWidget,
      openBuilder: (context, action) => openBuilderWidget,
    );
  }
}
