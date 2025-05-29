import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;

class AssertVersionHandler {
  static Future<int> getStoredVersion(String key) async {
    debugPrint("getting stored version: $key....");

    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  static Future<void> setStoredVersion(String key, int version) async {
    debugPrint("setting embedded version: $key....");

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, version);
  }

  static Future<int> loadEmbeddedVersion(String fileType) async {
    debugPrint("Loading embedded version: $fileType....");
    final version = await rootBundle.loadString(
      "assets/$fileType/version.txt",
      cache: false,
    );
    return int.parse(version);
  }
}
