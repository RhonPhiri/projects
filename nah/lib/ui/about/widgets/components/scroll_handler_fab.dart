import 'package:flutter/material.dart';

class ScrollHandlerFAB extends StatelessWidget {
  const ScrollHandlerFAB({
    super.key,
    required this.scrollController,
    required this.isAtBottom,
    required this.isScrollable,
  });
  final ScrollController scrollController;
  final bool isAtBottom;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    return isScrollable
        ? FloatingActionButton(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.primary,
          mini: true,
          elevation: 0,
          tooltip: isAtBottom ? "Back to top" : "Scroll to bottom",
          onPressed: () => handleScrolling(),

          child: Icon(
            isAtBottom
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
          ),
        )
        : SizedBox.shrink();
  }

  void handleScrolling() {
    scrollController.jumpTo(
      isAtBottom
          ? scrollController.position.minScrollExtent
          : scrollController.position.maxScrollExtent,
    );
  }
}
