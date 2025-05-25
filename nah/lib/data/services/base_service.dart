import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:nah/data/services/result.dart';

//This is an abstract class containing the common properties & variables used by the hymn & hymnal service classes
abstract class BaseService {
  ///Method to fetch embedded files & pass them to the repository
  Future<Result<String>> fetchData(String filePath) async {
    try {
      final file = await rootBundle.loadString(filePath, cache: false);
      return Success(file);
    } on FlutterError catch (e) {
      print("Base service: $e");
      return Failure(Exception("Assert not found: $filePath ($e)"));
    } on Exception catch (e) {
      print("Base service: $e");
      return Failure(
        Exception("Failed to fetch embedded data: BaseService $e"),
      );
    }
  }
}
