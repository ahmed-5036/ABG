import 'package:flutter/foundation.dart';

class LogManager {
  LogManager._();

  static void logToConsole(Object? value,
      [String? title = "log", bool enabled = true]) {
    if (enabled == false) return;
    if (kDebugMode) {
      debugPrint("""
$title: 
${value.toString()}""");
    }
  }
}
