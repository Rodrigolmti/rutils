// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:rutils_local_storage/rutils_local_storage.dart' as _i5;

import '../data/data_sources/local_data_source.dart' as _i7;
import '../data/data_sources/remote_data_source.dart' as _i6;
import '../data/repositories/app_repository.dart' as _i8;
import '../session/app_session.dart' as _i3;
import 'injector_module.dart' as _i9; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final serviceModule = _$ServiceModule();
  gh.singleton<_i3.AppSession>(_i3.AppSession());
  gh.lazySingleton<_i4.Dio>(() => serviceModule.dio());
  gh.factoryAsync<_i5.RUtilsLocalStorage>(() => serviceModule.prefs);
  gh.factory<_i6.RemoteDataSource>(
      () => _i6.RemoteDataSource(dio: get<_i4.Dio>()));
  gh.factoryAsync<_i7.LocalDataSource>(() async => _i7.LocalDataSource(
      localStorage: await get.getAsync<_i5.RUtilsLocalStorage>()));
  gh.factoryAsync<_i8.AppRepository>(() async => _i8.AppRepository(
      remoteDataSource: get<_i6.RemoteDataSource>(),
      localDataSource: await get.getAsync<_i7.LocalDataSource>()));
  return get;
}

class _$ServiceModule extends _i9.ServiceModule {}
