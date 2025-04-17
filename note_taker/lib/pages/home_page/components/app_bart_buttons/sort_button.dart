import 'package:flutter/material.dart';
import 'package:note_taker/models/models.dart';
import 'package:provider/provider.dart';

class SortButton extends StatefulWidget {
  const SortButton({super.key});

  @override
  State<SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  int selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.sort),
      tooltip: 'Sort notes by',
      position: PopupMenuPosition.under,
      onSelected:
          (value) => setState(() {
            selectedIndex = value;
          }),
      itemBuilder: (context) {
        return List.generate(Sort.values.length, (index) {
          final notesProvider = context.read<NoteProvider>();
          final sortItem = Sort.values[index];
          return PopupMenuItem(
            onTap:
                () => switch (sortItem) {
                  Sort.name => notesProvider.sortByName(),
                  Sort.date => notesProvider.sortByDate(),
                  Sort.size => notesProvider.sortByContentSize(),
                },
            enabled: selectedIndex != index,
            value: index,
            child: Text(sortItem.lable),
          );
        });
      },
    );
  }
}

enum Sort {
  name('Name'),
  date('Modification'),
  size('Content size');

  final String lable;
  const Sort(this.lable);
}
