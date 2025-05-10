import 'package:flutter/material.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/ui/details/widget/flow_menu/flow_menu_delegate.dart';
import 'package:nah/ui/hymn_collection/widgets/hymn_col_bot_sheet.dart';
import 'package:nah/ui/core/theme/widgets/theme_preferences.dart';

class FlowMenu extends StatefulWidget {
  const FlowMenu({super.key, required this.hymn});
  final Hymn hymn;

  @override
  State<FlowMenu> createState() => _FlowMenuState();
}

class _FlowMenuState extends State<FlowMenu>
    with SingleTickerProviderStateMixin {
  //animation controller to be used in the flowDelegate
  late AnimationController controller;

  //variable to check if the flow menu button is open or closed
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

  //Method to take up a flow child & retain a FAB
  Widget createFab(IconData icon) => FloatingActionButton(
    onPressed: () {
      if (controller.status == AnimationStatus.completed) {
        controller.reverse();
      } else {
        controller.forward();
      }
      if (icon != Icons.menu && icon != Icons.fullscreen) {
        showModalBottomSheet(
          context: context,
          builder:
              (context) =>
                  icon == Icons.text_fields
                      ? ThemePreferences(hymn: widget.hymn)
                      : HymnColBotSheet(hymn: widget.hymn),
        );
      }
    },
    child: Icon(icon, size: 32),
  );
}
