import 'package:flutter/material.dart';
import 'package:nah/ui/about/view_model/about_components_variables.dart';
import 'package:nah/ui/about/widgets/components/app_icon.dart';
import 'package:url_launcher/url_launcher.dart';

enum FooterButtons {
  pp(label: "Privacy Policy"),
  tos(label: "Terms of Service"),
  licences(label: "View Licences");

  final String label;

  const FooterButtons({required this.label});

  Future<void> footerLaunchActions(BuildContext context) async {
    try {
      switch (this) {
        case FooterButtons.pp:
          final uri = Uri.parse(
            "https://rhonphiri.github.io/nah/PRIVACY_POLICY",
          );
          if (!await canLaunchUrl(uri)) {
            throw Exception("Failed to launch ${uri.toString()}");
          }
          await launchUrl(uri);

          break;
        case FooterButtons.tos:
          final uri = Uri.parse(
            "https://rhonphiri.github.io/nah/TERMS_OF_SERVICE",
          );
          if (!await canLaunchUrl(uri)) {
            throw Exception("Failed to launch ${uri.toString()}");
          }
          await launchUrl(uri);
          break;
        case FooterButtons.licences:
          showLicensePage(
            context: context,
            applicationIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 100, maxHeight: 100),
                child: Hero(tag: "appIcon", child: AppIcon()),
              ),
            ),
            applicationName: "New Apostolic Church Hymnal app",
            applicationVersion: appVersion,
          );
          break;
      }
    } catch (e) {
      print("Error launching footer url: $e");
    }
  }
}
