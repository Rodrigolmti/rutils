import 'dart:io';

import 'package:device_info/device_info.dart';

const _default_model = '-';
const _default_brand = '-';

const _invalid_id = '-1';
const _invalidBrand = '-';

/// Returns some information about the device.
/// This is a wrapper around [DeviceInfoPlugin].
class DeviceInfo {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  AndroidDeviceInfo? _androidDeviceInfo;
  IosDeviceInfo? _iosDeviceInfo;

  Future<String?> _getDeviceInfo<T>({
    String Function()? isAndroid,
    String Function()? unknow,
    String Function()? isIos,
  }) async {
    if (Platform.isAndroid) {
      _androidDeviceInfo = _androidDeviceInfo ?? await _deviceInfo.androidInfo;
      return isAndroid?.call();
    } else if (Platform.isIOS) {
      _iosDeviceInfo = _iosDeviceInfo ?? await _deviceInfo.iosInfo;
      return isIos?.call();
    } else {
      return unknow?.call();
    }
  }

  /// Returns the device model or - if is not available.
  Future<String?> getDeviceModel() async => _getDeviceInfo(
      isAndroid: () => _androidDeviceInfo?.model ?? _default_model,
      isIos: () => _iosDeviceInfo?.model ?? _default_model,
      unknow: () => Platform.operatingSystem);

  /// Returns the device brand, for iOS aways Apple or -
  /// if is not available in Android.
  Future<String?> getDeviceBrand() async => _getDeviceInfo(
      isAndroid: () => _androidDeviceInfo?.brand ?? _default_brand,
      isIos: () => 'Apple',
      unknow: () => _invalidBrand);

  /// Returns the device id, if is not available returns -1.
  Future<String?> getDeviceId() async => _getDeviceInfo(
      isAndroid: () => _androidDeviceInfo?.id ?? _invalid_id,
      isIos: () => _iosDeviceInfo?.identifierForVendor ?? _invalid_id,
      unknow: () => _invalid_id);
}
