import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadFile {
  /**
   * Loads a file from the assets folder and returns the contents as a string.
   */
  static Future<String> loadFromAsset(String pathFile) async {
    try {
      return await rootBundle.loadString(pathFile);
      // ignore: avoid_catching_errors
    } on FlutterError catch (_) {
      // ignore: avoid_print
      print('Error loading the file: $pathFile');
      rethrow;
    }
  }

  /**
   * Loads a file from the assets folder and returns the contents as a map.
   */
  static Future<Map<String, dynamic>?> parseFileContentToMap(
    String pathFile,
  ) async {
    final jsonString = await loadFromAsset(pathFile);
    final Map valueMap = json.decode(jsonString);
    if (valueMap is Map<String, dynamic>) {
      return valueMap;
    }

    return null;
  }
}
