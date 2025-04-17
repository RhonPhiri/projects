import 'package:flutter/material.dart';
import 'package:nac_hymnal/components/modal_bot_sheet_container.dart';
import 'package:nac_hymnal/pages/edit_lyrics_page.dart';
import 'package:provider/provider.dart';
import '../hymn/hymn_model.dart';
import '../providers/theme_provider.dart';

class SettingsModalBotSheet extends StatelessWidget {
  const SettingsModalBotSheet({super.key, required this.hymn});
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
            return ChoiceChip(
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
                      context.read<ThemeProvider>().themeMode ==
                              ThemeMode.values[index]
                          ? Colors.white
                          : Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              side: BorderSide.none,
              selected:
                  context.read<ThemeProvider>().themeMode ==
                  ThemeMode.values[index],
              onSelected: (value) {
                context.read<ThemeProvider>().changeAppTheme(index);
              },
              checkmarkColor: Colors.white,
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
              value: fontSize,
              onChanged: (newValue) => themeProvider.changeFontSize(newValue),
              min: 12.0,
              max: 36.0,
              divisions: 6,
              label: '$fontSize',
              padding: const EdgeInsets.only(top: 16, bottom: 16, right: 24),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEditLyrics(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        onPressed: () {
          Navigator.of(context).pop(); //pop of the modalbotsheet
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditLyricsPage(hymn: hymn)),
          );
        },
        child: const Text('Edit Lyrics', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
