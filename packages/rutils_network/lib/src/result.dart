import 'package:dio/dio.dart';
import 'package:rutils_network/src/network_failure.dart';

enum Status { success, error }

/// Wrapper class with success and failure status
/// [data] is the response data
/// [status] is the request status
/// [message] is the error message
/// Data and message are nullable you can access them
/// with onSuccess and onError methods
class Result<T> {
  Status status;
  String? message;
  T? data;

  Result.success([this.data]) : status = Status.success;

  Result.error([this.message]) : status = Status.error;

  bool isSuccess() => status == Status.success;

  bool isError() => status == Status.error;

  void onSuccess(
    Function(T) transform,
  ) {
    switch (status) {
      case Status.success:
        // ignore: null_check_on_nullable_type_parameter
        transform(data!);
        break;
      case Status.error:
        break;
    }
  }

  void onError(
    Function(String?) transform,
  ) {
    switch (status) {
      case Status.success:
        break;
      case Status.error:
        transform(message);
        break;
    }
  }
}

typedef ResultCallback<T> = Future<T> Function(T);

/// Coverts a future into a [Result]
/// If you pass mapSuccess you should handle
/// the data and return the mapped result
/// This extensions try to run safely the request with catchError
extension FutureToResult<T> on Future<T> {
  Future<Result<T>> toResult({ResultCallback<T>? mapSuccess}) async =>
      then((data) async {
        if (mapSuccess != null) {
          try {
            final mapped = mapSuccess.call(data);
            return Result<T>.success(await mapped);
          } catch (_) {
            return Result<T>.error();
          }
        }

        return Result<T>.success(data);
      }).catchError((error) {
        try {
          // ignore: avoid_dynamic_calls
          if (error?.error is NetworkFailure) {
            // ignore: avoid_dynamic_calls
            return Result<T>.error(error?.error?.message);
          }

          if (error is DioError) {
            return Result<T>.error(error.error);
          }
        } catch (_) {
          return Result<T>.error();
        }

        return Result<T>.error();
      });
}
