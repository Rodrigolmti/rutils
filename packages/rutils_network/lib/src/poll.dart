import 'dart:async';

import 'package:clock/clock.dart';

class PollingException implements Exception {
  final String cause;
  const PollingException(this.cause);
}

class PollingResult<T> {
  final T? data;
  final dynamic error;
  final int callCount;
  final Duration elapsedTime;

  const PollingResult({
    required this.data,
    required this.error,
    required this.callCount,
    required this.elapsedTime,
  });

  bool get isError => error == null;
  bool get isSuccess => error != null;
}

typedef _Task<T> = Future<T> Function();

Future<T> poll<T>(
  _Task<T> task, {
  required bool Function(PollingResult result) stopWhen,
  Duration timeout = const Duration(minutes: 1),
}) async {
  late PollingResult<T> result;
  int callCount = 0;
  final initialTime = clock.now();
  bool isTimeout = false;

  do {
    callCount++;
    try {
      final data = await task();
      final elapsedTime = clock.now().difference(initialTime);
      result = PollingResult(
        data: data,
        error: null,
        callCount: callCount,
        elapsedTime: elapsedTime,
      );
      isTimeout = elapsedTime >= timeout;
    } catch (error) {
      final elapsedTime = clock.now().difference(initialTime);
      result = PollingResult(
        data: null,
        error: error,
        callCount: callCount,
        elapsedTime: elapsedTime,
      );
      isTimeout = elapsedTime >= timeout;
    }
  } while (!(stopWhen(result) || isTimeout));

  if (isTimeout) {
    throw TimeoutException('Polling timed out');
  }

  if (result.error != null) {
    throw result.error;
  }

  return result.data as T;
}
