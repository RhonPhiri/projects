import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });
  final String title;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final isBright = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 24),
      child: Material(
        key: ValueKey("DrawerTileMaterial_$title"),
        color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          key: ValueKey("DrawerTileInkWell_$title"),
          onTap: onTap,
          splashColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: isBright ? 0.2 : 0.8),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Row(
              children: [Icon(icon), const SizedBox(width: 16), Text(title)],
            ),
          ),
        ),
      ),
    );
  }
}
