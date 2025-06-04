import 'package:flutter/material.dart';
import 'package:nah/ui/about/widgets/components/app_icon.dart';

class AboutHeader extends StatelessWidget {
  const AboutHeader({super.key, required this.appVersion});
  final String appVersion;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(tag: "appIcon", child: AppIcon()),
      minLeadingWidth: 64,
      title: Text("New Apostolic Church Hymnal App"),
      titleTextStyle: Theme.of(context).textTheme.headlineSmall,
      subtitle: Text(appVersion),
    );
  }
}
