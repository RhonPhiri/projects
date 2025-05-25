import 'package:flutter/material.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/ui/core/theme/theme_provider.dart';
import 'package:nah/ui/core/ui/modal_bot_sheet_container.dart';
import 'package:provider/provider.dart';

class ThemePreferences extends StatelessWidget {
  const ThemePreferences({super.key, required this.hymn});
  final Hymn hymn;

  @override
  Widget build(BuildContext context) {
    return ModalBotSheetContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAppTheme(context),
          _buildFontSizeSlider(),
          // _buildEditLyrics(context),
        ],
      ),
    );
  }

  Widget _buildAppTheme(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'AppTheme:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...List.generate(3, (int index) {
            return Consumer<ThemeProvider>(
              builder:
                  (context, themeProvider, child) => ChoiceChip(
                    key: ValueKey('themeChoiceChip_$index'),
                    backgroundColor: getThemeColor(themeProvider.themeMode),
                    label: Text(
                      index == 0
                          ? 'System'
                          : index == 1
                          ? 'Light'
                          : 'Dark',
                      style: TextStyle(
                        //if the current thememode is equal to the selected thememode then apply the white color
                        //else use the on primary
                        color:
                            themeProvider.themeMode == ThemeMode.values[index]
                                ? Colors.white
                                : Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    side: BorderSide.none,
                    selected:
                        themeProvider.themeMode == ThemeMode.values[index],
                    onSelected: (value) {
                      context.read<ThemeProvider>().changeAppTheme(index);
                    },
                    checkmarkColor: Colors.white,
                  ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFontSizeSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Font Size:', style: TextStyle(fontWeight: FontWeight.bold)),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            final fontSize = themeProvider.fontSize;
            return Slider(
              key: ValueKey('fontSizeSlider'),
              inactiveColor: getThemeColor(themeProvider.themeMode),
              value: fontSize,
              onChanged: (newValue) => themeProvider.changeFontSize(newValue),
              min: 12.0,
              max: 32.0,
              divisions: 5,
              label: '$fontSize',
              padding: const EdgeInsets.only(top: 16, bottom: 16, right: 24),
            );
          },
        ),
      ],
    );
  }

  Color getThemeColor(ThemeMode themeMode) =>
      themeMode == ThemeMode.light ? Colors.white : Colors.grey.shade800;
}
