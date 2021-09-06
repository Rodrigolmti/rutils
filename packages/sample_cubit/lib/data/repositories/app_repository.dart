import 'package:injectable/injectable.dart';
import 'package:sample_cubit/data/data_sources/local_data_source.dart';
import 'package:sample_cubit/data/data_sources/remote_data_source.dart';

@injectable
class AppRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  const AppRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });
}
