import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactButtons extends StatelessWidget {
  const ContactButtons({super.key, required this.appVersion});
  final String appVersion;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          List.generate(AboutButtons.values.length, (int index) {
            final aboutButton = AboutButtons.values[index];
            return Column(
              children: [
                FloatingActionButton(
                  heroTag: aboutButton.label,
                  onPressed: () => aboutButton.launchAction(appVersion),
                  tooltip: aboutButton.label,
                  child: Icon(aboutButton.icon),
                ),
                SizedBox(height: 4),
                Text(aboutButton.label),
              ],
            );
          }).toList(),
    );
  }
}

enum AboutButtons {
  gmail(label: "Help or Feedback", icon: Icons.help),
  github(label: "Source Code", icon: Icons.device_hub);

  final String label;
  final IconData icon;

  const AboutButtons({required this.label, required this.icon});

  Future<void> launchAction(String appVersion) async {
    try {
      switch (this) {
        case AboutButtons.gmail:
          final uri = Uri(
            scheme: 'mailto',
            path: "phirirhon42@gmail.com",
            queryParameters: {
              'subject': 'New Apostolic Church App $appVersion',
            },
          );
          if (!await canLaunchUrl(uri)) {
            throw Exception("Failed to launch ${uri.toString()}");
          }
          await launchUrl(uri);
          break;
        case AboutButtons.github:
          final uri = Uri.parse("https://github.com/RhonPhiri/nah");
          if (!await canLaunchUrl(uri)) {
            throw Exception("Failed to launch ${uri.toString()}");
          }
          await launchUrl(uri);

          break;
      }
    } catch (e) {
      print("Error launching about url: $e");
    }
  }
}
