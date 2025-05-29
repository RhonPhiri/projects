import 'package:flutter/material.dart';

///This is a sliver app bar that takes up a title, leading & action buttons respectively.
///It allows animation of the title from a bottom to the center offset
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
    return SliverAppBar.medium(
      title: Text(title),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.blurBackground],
        background: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8, top: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      ///if either actions / leading is null, then add a shrinked sized box, or an empty list
      leading:
          leading ??
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
      actions: actions ?? [],
      actionsPadding: const EdgeInsets.only(right: 16),
    );
  }
}
