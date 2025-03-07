import 'package:file_downloader/services/storage_service.dart';
import 'package:http/http.dart';

class DownloadService {
  //variable to access the storage
  final _storage = StorageService();
  //method to download the file anad save to storage
  Future<StreamedResponse> downloadFile(String uri, String fileName) async {
    try {
      final request = Request('GET', Uri.parse(uri));
      final response = await Client().send(request);
      return response;
    } catch (e) {
      print('Failed to download file: $e');
      throw Exception('Failed to download file');
    }
  }
}
