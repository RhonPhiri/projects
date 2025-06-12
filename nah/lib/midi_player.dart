import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MidiPlayer {
  static const _channel = MethodChannel("nah/midi");

  static Future<void> play(String resourceName) async {
    try {
      await _channel.invokeMethod("playMidi", {"name": "resourceName"});
    } on PlatformException catch (e) {
      debugPrint("Error playing midi: ${e.message}");
    }
  }

  static Future<void> stop() async {
    try {
      await _channel.invokeMethod("stopMidi");
    } on PlatformException catch (e) {
      debugPrint("Error stopping midi: ${e.message}");
    }
  }
}
