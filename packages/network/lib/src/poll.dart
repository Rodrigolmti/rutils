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

  bool get isError => error != null;
  bool get isSuccess => error == null;

  @override
  String toString() =>
      // ignore: lines_longer_than_80_chars
      'PollingResult<$T>{data: $data, error: $error, callCount: $callCount, elapsedTime: $elapsedTime}';
}

typedef _Task<T> = Future<T> Function();

/// Polls a task until it completes or the timeout is reached.
///
/// You should provide a stop condition [stopWhen].
/// Errors will not stop polling by default. Instead, you should check for the
/// error type in your [stopWhen] callback.
///
/// If you provide a [period], will call the task at most once per [period]
/// Credit: @danilofuchs
Future<T> poll<T>(
  _Task<T> task, {
  required bool Function(PollingResult<T> result) stopWhen,
  Duration timeout = const Duration(minutes: 1),
  Duration? period,
}) async {
  late PollingResult<T> result;
  int callCount = 0;
  final initialTime = clock.now();
  bool isTimeout = false;

  DateTime lastActivationTime = initialTime;
  late DateTime lastCompletionTime;

  bool shouldStopPolling = false;

  Future<void> _maybeWaitUntilNextPeriod() async {
    final timeToExecuteIteration =
        lastCompletionTime.difference(lastActivationTime);

    final shouldWait =
        !shouldStopPolling && period != null && timeToExecuteIteration < period;

    if (shouldWait) {
      final waitFor = period - timeToExecuteIteration;
      await Future.delayed(waitFor);
    }
  }

  do {
    callCount++;
    lastActivationTime = clock.now();
    try {
      final data = await task();
      lastCompletionTime = clock.now();

      final elapsedTime = lastCompletionTime.difference(initialTime);
      result = PollingResult(
        data: data,
        error: null,
        callCount: callCount,
        elapsedTime: elapsedTime,
      );
      isTimeout = elapsedTime >= timeout;
    } catch (error) {
      lastCompletionTime = clock.now();
      final elapsedTime = lastCompletionTime.difference(initialTime);

      result = PollingResult(
        data: null,
        error: error,
        callCount: callCount,
        elapsedTime: elapsedTime,
      );
      isTimeout = elapsedTime >= timeout;
    }
    shouldStopPolling = stopWhen(result) || isTimeout;

    await _maybeWaitUntilNextPeriod();
  } while (!shouldStopPolling);

  if (isTimeout) {
    throw TimeoutException('Polling timed out');
  }

  if (result.error != null) {
    throw result.error;
  }

  return result.data as T;
}
