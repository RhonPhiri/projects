import 'package:flutter/material.dart';
import 'package:nac_hymnal/components/my_sliver_app_bar.dart';
import 'package:nac_hymnal/hymn/hymn_model.dart';

class EditLyricsPage extends StatefulWidget {
  const EditLyricsPage({super.key, required this.hymn});
  final Hymn hymn;

  @override
  State<EditLyricsPage> createState() => _EditLyricsPageState();
}

class _EditLyricsPageState extends State<EditLyricsPage> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MySliverAppBar(
            title: 'Edit Hymn',
            leading: IconButton(
              onPressed: () {
                // TODO: Check the contents and compare with the og hymnal to see if
                //changes were made and ask if the changes are to be saved or discarded
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            actions: [
              MaterialButton(
                textColor: Colors.white,
                color: Theme.of(context).colorScheme.primary,
                shape: const StadiumBorder(),
                onPressed: () {
                  // TODO: Check the contents and compare with the og hymnal to see if
                  //changes were made and ask if the changes are to be saved or discarded
                },
                child: const Text('Save'),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: TextField(controller: _textController, maxLines: null),
          ),
        ],
      ),
    );
  }
}
