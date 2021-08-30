import 'package:shared_preferences/shared_preferences.dart';

abstract class _RUtilsLocalStorage {
  // ignore: avoid_positional_boolean_parameters
  Future<bool> setBool(String key, bool value);

  bool? getBool(String key);

  Future<bool> setDouble(String key, double value);

  double? getDouble(String key);

  Future<bool> setInt(String key, int value);

  int? getInt(String key);

  Future<bool> setString(String key, String value);

  String? getString(String key);

  Future<void> clear(String key);

  Future<void> clearAll();
}

/// Local storage utils, that uses SharedPreferecs and it
/// has methods for all dart primitive types
/// You should call the method getInstance() before using any other method,
///  it is async so you may need to await the result
/// You can use the method getInstance() to get the instance of the class
class RUtilsLocalStorage implements _RUtilsLocalStorage {
  final SharedPreferences preferences;

  RUtilsLocalStorage({required this.preferences});

  static Future<RUtilsLocalStorage> getInstance() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return RUtilsLocalStorage(preferences: sharedPreferences);
  }

  @override
  Future<void> clear(String key) => preferences.remove(key);

  @override
  Future<void> clearAll() => preferences.clear();

  @override
  bool? getBool(String key) => preferences.getBool(key);

  @override
  double? getDouble(String key) => preferences.getDouble(key);

  @override
  int? getInt(String key) => preferences.getInt(key);

  @override
  String? getString(String key) => preferences.getString(key);

  @override
  Future<bool> setBool(String key, bool value) =>
      preferences.setBool(key, value);

  @override
  Future<bool> setDouble(String key, double value) =>
      preferences.setDouble(key, value);

  @override
  Future<bool> setInt(String key, int value) => preferences.setInt(key, value);

  @override
  Future<bool> setString(String key, String value) =>
      preferences.setString(key, value);
}
