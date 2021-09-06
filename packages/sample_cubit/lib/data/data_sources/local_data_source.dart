import 'package:injectable/injectable.dart';

import 'package:rutils_local_storage/rutils_local_storage.dart';

@injectable
class LocalDataSource {
  final RUtilsLocalStorage localStorage;
  const LocalDataSource({required this.localStorage});
}
