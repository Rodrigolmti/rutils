import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadFile {
  static Future<String> _loadFromAsset(String pathFile) async {
    try {
      return await rootBundle.loadString(pathFile);
      // ignore: avoid_catching_errors
    } on FlutterError catch (_) {
      // ignore: avoid_print
      print('Error loading the file: $pathFile');
      rethrow;
    }
  }

  /// Given a path to a file, load the file and return the contents as a map.
  static Future<Map<String, dynamic>?> parseFileContentToMap(
    String pathFile,
  ) async {
    final jsonString = await _loadFromAsset(pathFile);
    final Map valueMap = json.decode(jsonString);
    if (valueMap is Map<String, dynamic>) {
      return valueMap;
    }

    return null;
  }
}
