import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoteDataSource {
  final Dio dio;
  const RemoteDataSource({required this.dio});
}
