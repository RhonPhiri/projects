import 'package:file_downloader/services/download_service.dart';
import 'package:file_downloader/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //key for the form holding the textformfields used in validation
  final _formKey = GlobalKey<FormState>();
  //controllers for the textfields
  late TextEditingController _urlController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  double progress = 0;
  final _storage = StorageService();

  Future<void> startDownload(String uri, String fileName) async {
    try {
      final request = Request('GET', Uri.parse(uri));
      final response = await Client().send(request);
      final contentLength = response.contentLength;
      final bytes = <int>[];
      response.stream.listen(
        (newBytes) {
          bytes.addAll(newBytes);
          setState(() {
            progress = bytes.length / contentLength!;
          });
        },
        onDone: () async {
          setState(() {
            progress = 1;
          });
          await _storage.saveFile(fileName, bytes);
        },
        onError: print,
        cancelOnError: true,
      );
    } catch (e) {
      print('Failed to download file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  controller: _urlController,
                  decoration: InputDecoration(
                    labelText: 'Url',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please insert a Url';
                    }
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'File name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a file name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                MaterialButton(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      startDownload(
                        _urlController.text.trim(),
                        _nameController.text.trim(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading file')),
                      );
                    }
                  },
                  child: Text('Download'),
                ),
                Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children:
                      progress == 0
                          ? []
                          : [
                            progress == 1
                                ? Icon(Icons.done)
                                : Text(
                                  '${(progress * 100).toStringAsFixed(1)}%',
                                  style: TextStyle(fontSize: 12),
                                ),
                            CircularProgressIndicator(
                              backgroundColor:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onInverseSurface,
                              value: progress,
                            ),
                          ],
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
