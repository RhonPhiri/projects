import 'package:flutter/material.dart';

class ChoiceChipRow extends StatelessWidget {
  const ChoiceChipRow({
    super.key,
    required this.title,
    required this.choiceChipNameList,
    required this.enumValueIndex,
    required this.onSelectedMethod,
  });
  final String title;
  final List<String> choiceChipNameList;
  final int enumValueIndex;
  final void Function(int) onSelectedMethod;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
        ),
        ...List.generate(choiceChipNameList.length, (int index) {
          return ChoiceChip(
            showCheckmark: true,
            selected: index == enumValueIndex,
            label: Text(
              choiceChipNameList[index],
              style: const TextStyle(fontSize: 12),
            ),
            onSelected: (value) {
              if (value) {
                onSelectedMethod(index);
              }
            },
          );
        }),
      ],
    );
  }
}
