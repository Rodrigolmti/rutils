import 'dart:io';

import 'package:device_info/device_info.dart';

const _default_model = '-';
const _default_brand = '-';

const _invalid_id = '-1';
const _invalidBrand = '-';

/**
 * This class is responsible for returning information about the device.
 */
class DeviceInfo {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  AndroidDeviceInfo? _androidDeviceInfo;
  IosDeviceInfo? _iosDeviceInfo;

  Future<String?> _getDeviceInfo<T>({
    String Function()? isAndroid,
    String Function()? unknown,
    String Function()? isIos,
  }) async {
    if (Platform.isAndroid) {
      _androidDeviceInfo = _androidDeviceInfo ?? await _deviceInfo.androidInfo;
      return isAndroid?.call();
    } else if (Platform.isIOS) {
      _iosDeviceInfo = _iosDeviceInfo ?? await _deviceInfo.iosInfo;
      return isIos?.call();
    } else {
      return unknown?.call();
    }
  }

  /**
   * Returns the device model, if is not available returns -.
   */
  Future<String?> getDeviceModel() async => _getDeviceInfo(
      isAndroid: () => _androidDeviceInfo?.model ?? _default_model,
      isIos: () => _iosDeviceInfo?.model ?? _default_model,
      unknown: () => Platform.operatingSystem);

  /**
   * Returns the device brand, if is not available returns -.
   */
  Future<String?> getDeviceBrand() async => _getDeviceInfo(
      isAndroid: () => _androidDeviceInfo?.brand ?? _default_brand,
      isIos: () => 'Apple',
      unknown: () => _invalidBrand);

  /**
   * Returns the device id, if is not available returns -1.
   */
  Future<String?> getDeviceId() async => _getDeviceInfo(
      isAndroid: () => _androidDeviceInfo?.id ?? _invalid_id,
      isIos: () => _iosDeviceInfo?.identifierForVendor ?? _invalid_id,
      unknown: () => _invalid_id);
}
