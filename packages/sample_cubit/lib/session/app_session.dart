import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppSession implements Disposable {
  @override
  FutureOr onDispose() {}
}
