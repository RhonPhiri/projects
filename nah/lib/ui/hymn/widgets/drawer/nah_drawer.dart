import 'package:flutter/material.dart';
import 'package:nah/ui/about/widgets/about_screen.dart';
import 'package:nah/ui/hymn/widgets/drawer/drawer_tile.dart';
import 'package:nah/ui/hymn_collection/widgets/hymn_col_screen.dart';

class NahDrawer extends StatelessWidget {
  const NahDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isBright = Theme.of(context).brightness == Brightness.light;
    return Drawer(
      key: ValueKey("NahDrawer"),
      child: Column(
        children: [
          DrawerHeader(
            key: ValueKey("DrawerHeader"),
            margin: EdgeInsets.only(top: 16),
            child: SizedBox(
              child: Image.asset(
                "assets/images/${isBright ? "nac_logo_light.png" : "nac_logo_blue.png"}",
              ),
            ),
          ),
          Spacer(),
          DrawerTile(
            key: ValueKey("DrawerTile_HymnCollections"),
            title: "Hymn Collections",
            icon: Icons.menu_book,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => HymnColScreen()));
              //Close the drawer
              Scaffold.of(context).closeDrawer();
            },
          ),

          DrawerTile(
            title: "About",
            icon: Icons.info,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => AboutScreen()));

              Scaffold.of(context).closeDrawer();
            },
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }
}
