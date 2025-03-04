import 'package:flutter/material.dart';
import 'package:note_taker/models/theme_provider.dart';
import 'package:provider/provider.dart';
import 'choice_chip_row.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            final themeProvider = context.watch<ThemeProvider>();

            return Container(
              padding: EdgeInsets.all(16),
              height: 250,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...List.generate(3, (int index) {
                    //list of 1st 3 variables in the modalBottomSheet
                    //used patterns (switch expressions) to parse check the variables and asign accordingly
                    final variables = ['themeMode', 'themeColor', 'fontFamily'];
                    return ChoiceChipRow(
                      title: switch (variables[index]) {
                        'themeMode' => 'Choose Theme:',
                        'themeColor' => 'Choose color:',
                        'fontFamily' => 'Choose Font',
                        _ => 'null',
                      },
                      choiceChipNameList: switch (variables[index]) {
                        'themeMode' =>
                          ThemeMode.values
                              .map((themeMode) => themeMode.name)
                              .toList(),
                        'themeColor' =>
                          ThemeColor.values
                              .map((themeColor) => themeColor.name)
                              .toList(),
                        'fontFamily' =>
                          FontFamily.values
                              .map((fontFamily) => fontFamily.name)
                              .toList(),
                        _ => [],
                      },
                      enumValueIndex: switch (variables[index]) {
                        'themeMode' => ThemeMode.values.indexOf(
                          themeProvider.themeMode,
                        ),
                        'themeColor' => ThemeColor.values.indexOf(
                          themeProvider.themeColor,
                        ),
                        'fontFamily' => FontFamily.values.indexOf(
                          themeProvider.fontFamily,
                        ),
                        _ => 0,
                      },
                      onSelectedMethod: switch (variables[index]) {
                        'themeMode' =>
                          (p0) => themeProvider.changeVariable(p0, 'themeMode'),
                        'themeColor' =>
                          (p0) =>
                              themeProvider.changeVariable(p0, 'themeColor'),
                        'fontFamily' =>
                          (p0) =>
                              themeProvider.changeVariable(p0, 'fontFamily'),
                        _ => (p0) {},
                      },
                    );
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Font size'),
                      Spacer(),
                      Row(
                        children: List.generate(2, (int index) {
                          return IconButton(
                            onPressed: () {
                              context.read<ThemeProvider>().changeFontSize(
                                index,
                              );
                              print(context.read<ThemeProvider>().fontSize);
                            },
                            icon: Icon(
                              Icons.text_fields,
                              size: index == 0 ? 24 : 32,
                              color:
                                  Theme.of(context).colorScheme.primaryFixedDim,
                            ),
                          );
                        }),
                      ),
                      Spacer(),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      icon: switch (context.watch<ThemeProvider>().themeMode) {
        ThemeMode.system => Icon(Icons.invert_colors),
        ThemeMode.light => Icon(Icons.wb_sunny),
        ThemeMode.dark => Icon(Icons.dark_mode),
      },
    );
  }
}
