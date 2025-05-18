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
    String Function()? onAndroid,
    String Function()? unknown,
    String Function()? onIos,
  }) async {
    if (Platform.isAndroid) {
      _androidDeviceInfo = _androidDeviceInfo ?? await _deviceInfo.androidInfo;
      return onAndroid?.call();
    } else if (Platform.isIOS) {
      _iosDeviceInfo = _iosDeviceInfo ?? await _deviceInfo.iosInfo;
      return onIos?.call();
    } else {
      return unknown?.call();
    }
  }

  /**
   * Returns the device model, if is not available returns -.
   */
  Future<String?> getDeviceModel() async => _getDeviceInfo(
        onAndroid: () => _androidDeviceInfo?.model ?? _default_model,
        onIos: () => _iosDeviceInfo?.model ?? _default_model,
        unknown: () => Platform.operatingSystem,
      );

  /**
   * Returns the device brand, if is not available returns -.
   */
  Future<String?> getDeviceBrand() async => _getDeviceInfo(
        onAndroid: () => _androidDeviceInfo?.brand ?? _default_brand,
        onIos: () => 'Apple',
        unknown: () => _invalidBrand,
      );

  /**
   * Returns the device id, if is not available returns -1.
   */
  Future<String?> getDeviceId() async => _getDeviceInfo(
        onAndroid: () => _androidDeviceInfo?.id ?? _invalid_id,
        onIos: () => _iosDeviceInfo?.identifierForVendor ?? _invalid_id,
        unknown: () => _invalid_id,
      );
}
