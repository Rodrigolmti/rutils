import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rutils_network/src/network_failure.dart';

class _ConnectionHanlder {
  factory _ConnectionHanlder() => I;

  static final _ConnectionHanlder I = _ConnectionHanlder._();

  _ConnectionHanlder._();

  final InternetConnectionChecker connectionChecker =
      InternetConnectionChecker();
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}

/// Use this method to throw a Network Exception if no connectivity
/// or call callback if has.
///
/// Tests reachability to known stable servers
Future<T> doRequestOrThrowNetworkException<T>(
  Future<T> Function() callback,
) async {
  if (await _ConnectionHanlder.I.connectionChecker.hasConnection) {
    return callback();
  } else {
    throw const NetworkException('User has no internet connection');
  }
}

/// Call procced function if network is available or call exit if not.
Future<void> proccedOnConnectionOrExit({
  required VoidCallback procced,
  required VoidCallback exit,
}) async {
  if (await _ConnectionHanlder.I.connectionChecker.hasConnection) {
    procced();
  } else {
    exit();
  }
}

/// Call block function in case the Response is valid or throw a NetworkFailure
T parseOrThrown<T>(
  Response response, {
  T Function(Map<String, dynamic>? response)? block,
}) {
  if (response.isResponseInvalid()) {
    print('Network error on request ${response.toString()}');
    throw const NetworkFailure();
  }

  return block != null ? block(response.data) : response.data;
}

extension ResponseX on Response {
  // ignore: avoid_dynamic_calls
  bool isResponseInvalid() => data == null || (data is String && data.isEmpty);
}
