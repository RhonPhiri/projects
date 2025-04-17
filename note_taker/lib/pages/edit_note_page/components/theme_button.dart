import 'package:flutter/material.dart';
import 'package:note_taker/providers/theme_provider.dart';
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
            final textTheme = Theme.of(context).textTheme;

            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...List.generate(3, (int index) {
                    //list of 1st 3 variables in the modalBottomSheet
                    //used patterns (switch expressions) to parse check the variables and asign accordingly
                    final variables = ['themeMode', 'themeColor', 'textTheme'];
                    return ChoiceChipRow(
                      title: switch (variables[index]) {
                        'themeMode' => 'Choose Theme:',
                        'themeColor' => 'Choose color:',
                        'textTheme' => 'Font:',
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
                        'textTheme' =>
                          NoteTextTheme.values
                              .map((textTheme) => textTheme.name)
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
                        'textTheme' => NoteTextTheme.values.indexOf(
                          themeProvider.noteTextTheme,
                        ),
                        _ => 0,
                      },
                      onSelectedMethod: switch (variables[index]) {
                        'themeMode' =>
                          (p0) => themeProvider.changeVariable(p0, 'themeMode'),
                        'themeColor' =>
                          (p0) =>
                              themeProvider.changeVariable(p0, 'themeColor'),
                        'textTheme' =>
                          (p0) => themeProvider.changeVariable(p0, 'textTheme'),
                        _ => (p0) {},
                      },
                    );
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Font size:',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: List.generate(2, (int index) {
                          return IconButton(
                            onPressed: () {
                              context.read<ThemeProvider>().changeFontSize(
                                index,
                              );
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
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      icon: switch (context.watch<ThemeProvider>().themeMode) {
        ThemeMode.system => const Icon(Icons.invert_colors),
        ThemeMode.light => const Icon(Icons.wb_sunny),
        ThemeMode.dark => const Icon(Icons.dark_mode),
      },
    );
  }
}
