import 'package:flutter/material.dart';

class AboutDescription extends StatelessWidget {
  const AboutDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            width: 8,
            color: Theme.of(context).colorScheme.primary,
          ),
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          right: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 0.5,
          ),
        ),
      ),
      child: Text(
        """New Apostolic Church Hymnal is a simple and accessible app with a collection of hymns in different languages. Designed for use when a physical hymnal isn't available, with robust features such as full-screen view, search, bookmarks, and dark mode.

      Intended as a quiet companion to support worship and personal devotion — and not a replacement for the printed hymnal.""",
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
