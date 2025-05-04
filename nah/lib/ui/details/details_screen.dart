import 'package:flutter/material.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/ui/details/hymn_column.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.hymn});
  final Hymn hymn;

  @override
  Widget build(BuildContext context) {
    //variable to hold the list of names of the actions buttons for the appbar
    final actionButtonLable = ['Preferences', 'Bookmark'];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: HymnColumn(hymn: hymn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
