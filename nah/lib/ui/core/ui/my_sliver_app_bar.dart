import 'package:flutter/material.dart';

class MySliverAppBar extends StatelessWidget {
  const MySliverAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    //  SliverAppBar(
    //         pinned: true,
    //         flexibleSpace: FlexibleSpaceBar(
    //           title: Text(
    //             title,
    //             style: Theme.of(context).appBarTheme.titleTextStyle,
    //           ),
    //           expandedTitleScale: 1.5,
    //           titlePadding: EdgeInsets.only(left: 16, bottom: 16),
    //         ),
    //         expandedHeight: 100,
    //         actions: [
    //
    //         ],
    //       ),
    return SliverAppBar.medium(
      title: Text(title),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.blurBackground],
        background: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 4,
                  width: (title.length / 1) * 10,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      leading: leading,
      actions: actions,
      actionsPadding: const EdgeInsets.only(right: 16),
    );
  }
}
