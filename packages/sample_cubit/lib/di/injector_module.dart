import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:rutils_local_storage/rutils_local_storage.dart';
import 'package:sample_cubit/core/constants.dart';

@module
abstract class ServiceModule {
  @lazySingleton
  Dio dio() => Dio(
        BaseOptions(
          baseUrl: serverUrl,
          connectTimeout: 20 * 1000, // 20 seconds
          receiveTimeout: 20 * 1000, // 20 seconds
        ),
      );

  Future<RUtilsLocalStorage> get prefs => RUtilsLocalStorage.getInstance();
}
