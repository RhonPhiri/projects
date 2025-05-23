import 'package:flutter/material.dart';
import 'package:nah/data/models/hymn_collection_model.dart';

class CreateHymnCollectionAlertDialog extends StatefulWidget {
  const CreateHymnCollectionAlertDialog({super.key});

  @override
  State<CreateHymnCollectionAlertDialog> createState() =>
      _CreateHymnCollectionAlertDialogState();
}

class _CreateHymnCollectionAlertDialogState
    extends State<CreateHymnCollectionAlertDialog> {
  late TextEditingController _titleEditingController;
  late TextEditingController _descriptionEditingController;

  //variable to hold the key of the form
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleEditingController = TextEditingController();
    _descriptionEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _descriptionEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        titleTextStyle: Theme.of(context).textTheme.bodyLarge,
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleEditingController,
                maxLines: null,
                maxLength: 50,
                decoration: const InputDecoration(hintText: 'Title (Required)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the collection title';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _descriptionEditingController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Description (Optional)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    _descriptionEditingController.text =
                        'No description available';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pop(
                  HymnCollection(
                    title: _titleEditingController.text,
                    description: _descriptionEditingController.text,
                  ),
                );
              }
            },
            child: const Text('Create'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
