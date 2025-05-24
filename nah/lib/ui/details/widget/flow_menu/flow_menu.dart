import 'package:flutter/material.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/ui/details/widget/flow_menu/flow_menu_delegate.dart';
import 'package:nah/ui/details/widget/full_screen_detailed_view.dart';
import 'package:nah/ui/hymn_collection/widgets/hymn_col_bot_sheet.dart';
import 'package:nah/ui/core/theme/widgets/theme_preferences.dart';

/// A floating action button menu for hymn details actions.
class FlowMenu extends StatefulWidget {
  const FlowMenu({super.key, required this.hymn});
  final Hymn hymn;

  @override
  State<FlowMenu> createState() => _FlowMenuState();
}

class _FlowMenuState extends State<FlowMenu>
    with SingleTickerProviderStateMixin {
  /// Animation controller to be used in the flowDelegate.
  late AnimationController controller;

  /// Variable to check if the flow menu button is open or closed.
  bool menuClosed = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleFlowIconPressed(IconData icon, BuildContext context) {
    icon != Icons.fullscreen
        ? showModalBottomSheet(
          context: context,
          builder:
              (context) =>
                  icon == Icons.text_fields
                      ? ThemePreferences(hymn: widget.hymn)
                      : HymnColBotSheet(hymn: widget.hymn),
        )
        : Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullScreenDetailedView(hymn: widget.hymn),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowMenuDelegate(animation: controller),
      children:
          <IconData>[
            Icons.text_fields,
            Icons.fullscreen,
            Icons.bookmark,
            Icons.menu,
          ].map(createFab).toList(),
    );
  }

  /// Method to take up a flow icon & retain a FAB.
  Widget createFab(IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
    child: FloatingActionButton(
      key: ValueKey('flowMenuFab_${icon.codePoint}'),
      onPressed: () {
        if (controller.status == AnimationStatus.completed) {
          controller.reverse();
        } else {
          controller.forward();
        }
        switch (icon) {
          case Icons.bookmark:
            handleFlowIconPressed(icon, context);
            break;
          case Icons.text_fields:
            handleFlowIconPressed(icon, context);
            break;
          case Icons.fullscreen:
            handleFlowIconPressed(icon, context);
            break;
        }
      },
      child: Icon(icon, size: 32),
    ),
  );
}
