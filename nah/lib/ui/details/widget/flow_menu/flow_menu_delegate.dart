import 'dart:math';
import 'package:flutter/material.dart';

class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> animation;

  FlowMenuDelegate({required this.animation}) : super(repaint: animation);
  @override
  void paintChildren(FlowPaintingContext context) {
    ///variable to hold the nummber of children
    final n = context.childCount;

    ///variable to hold the arc radius and inc. or dec. depending on the animation value (0.0 - 1.0)
    final r = 120.0 * animation.value;

    ///variable to hold the button size
    final buttonSize = context.getChildSize(0)!.width;

    ///Get the container size
    final size = context.size;
    final xStart = size.width - buttonSize;
    final yStart = size.height - buttonSize;

    for (var i = 0; i < n; i++) {
      ///variable to hold the angle theta
      final theta = i * pi * 0.5 / (n - 2);

      ///variables to hold the x & y coordinates
      ///check if the button is the last item or not & set the position as on the origin or not
      final bool isLastItem = i == context.childCount - 1;
      setValue(value) => isLastItem ? 0.0 : value;
      final x = xStart - setValue(r * cos(theta));
      final y = yStart - setValue(r * sin(theta));
      context.paintChild(
        i,
        transform:
            Matrix4.identity()
              ..translate(x, y, 0)
              ..scale(isLastItem ? 1.0 : max(animation.value, 0.5)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowMenuDelegate oldDelegate) {
    return animation != oldDelegate.animation;
  }
}
