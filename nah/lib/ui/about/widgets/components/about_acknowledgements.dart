import 'package:flutter/material.dart';

class AboutAcknowledgements extends StatelessWidget {
  const AboutAcknowledgements({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              text:
                  "Grateful to the New Apostolic Church and everyone involved in making the hymns used in this app available",
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge,
          ),

          SizedBox(height: 16),
          Text(
            "If you love the app or have any challenges, please, do not hesitate to give us feedback through our contacts provided",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
