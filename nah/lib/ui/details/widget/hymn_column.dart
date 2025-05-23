import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/ui/core/theme/theme_provider.dart';
import 'package:nah/utils/hymn_extensions.dart';

class HymnColumn extends StatelessWidget {
  const HymnColumn({super.key, required this.hymn});
  final Hymn hymn;

  List<Widget> _buildLyrics(
    List<String> verses,
    String chorus,
    double fontSize,
  ) {
    if (chorus.isNotEmpty) {
      return [
        for (var i = 0; i < verses.length; i++) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              verses[i],
              style: TextStyle(
                height: 1.5,
                fontSize: fontSize,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          if (i == 0)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                chorus,
                style: TextStyle(
                  fontSize: fontSize + 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ];
    } else {
      return [
        for (String verse in verses)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              verse,
              style: TextStyle(
                height: 1.5,
                fontSize: fontSize,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    ///variable to hold the font size
    final fontSize = context.watch<ThemeProvider>().fontSize;

    ///variable to hold the list of verses
    final verses = hymn.verses;
    final chorus = hymn.chorus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(2, (int index) {
          return Text(
            index == 0 ? "${hymn.id}. ${hymn.title}" : hymn.otherDetails,

            style: TextStyle(
              height: 1.5,
              fontSize: index == 0 ? 24 : 16,
              fontWeight: index == 0 ? FontWeight.bold : FontWeight.w300,
            ),
          );
        }),
        const Divider(),
        const SizedBox(height: 16),
        ..._buildLyrics(verses, chorus, fontSize),
      ],
    );
  }
}
