import 'package:flutter/foundation.dart';

class LogService {
  static void init() {
    if (kDebugMode) {
      print('[INFO] LogService initialized');
    }
  }

  static void info(String tag, String message) {
    if (kDebugMode) {
      final time = DateTime.now().toIso8601String().split('T').last;
      print('[$time] [INFO] [$tag]: $message');
    }
  }

  static void error(String tag, String message, [dynamic error, StackTrace? stack]) {
    if (kDebugMode) {
      final time = DateTime.now().toIso8601String().split('T').last;
      print('[$time] [ERROR] [$tag]: $message');
      if (error != null) print('Error: $error');
      if (stack != null) print('Stack: $stack');
    }
  }
}