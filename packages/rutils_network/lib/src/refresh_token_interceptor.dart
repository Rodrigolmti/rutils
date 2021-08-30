import 'package:dio/dio.dart';

class RefreshOptions {
  final String path;
  final Map<String, dynamic> params;
  final Map<String, dynamic> headers;
  final bool printLog;
  final int retryCount;
  const RefreshOptions({
    required this.path,
    required this.params,
    required this.headers,
    this.printLog = false,
    this.retryCount = 2,
  });
}

class RetryOptions {
  final Map<String, dynamic> headers;
  const RetryOptions({required this.headers});
}

/// Refresh token interceptor for DIO library.
/// It receives refreshOptions that contains the path to refresh token endpoint,
/// the parameters to send to the endpoint and the headers
/// to send with the request.
/// It also receives retryOptions that contains the headers
/// to send with the retry request.
/// It will automatically refresh the token and retry the request.
/// The retry count is configurable.
/// If the token is not refreshed, the request will fail.
/// If the token is refreshed, the request will be retried, and the
/// callback onRefreshToken will be called with the response.
/// If the retry count is reached, the request will fail with
/// DioError with cancel type.
class RefreshTokenInterceptor {
  final RefreshOptions refreshOptions;
  final RetryOptions retryOptions;
  final Future<void> Function<T>(T data) onRefreshToken;
  final Dio dio;

  int _retryCount = 0;

  RefreshTokenInterceptor({
    required this.refreshOptions,
    required this.onRefreshToken,
    required this.retryOptions,
    required this.dio,
  });

  Future<dynamic> refreshToken(
    DioError dioError,
    ErrorInterceptorHandler handler,
  ) async {
    if (_retryCount >= refreshOptions.retryCount) {
      _retryCount = 0;
      if (refreshOptions.printLog) {
        print('The retry limit was reached!');
      }
      handler.reject(
        DioError(
          requestOptions: dioError.requestOptions,
          type: DioErrorType.cancel,
        ),
      );
      return;
    }

    final tokenDio = Dio()
      ..options = dio.options.copyWith(
        headers: {},
      );

    dio.interceptors.requestLock.lock();
    _retryCount += 1;

    return tokenDio
        .post(
      refreshOptions.path,
      data: refreshOptions.params,
      options: Options(
        headers: refreshOptions.headers,
      ),
    )
        .then((json) async {
      await onRefreshToken.call(json);
      if (refreshOptions.printLog) {
        print('Token refreshed, retrying the previous request!');
      }
      dioError.requestOptions.headers = retryOptions.headers;
      dio.interceptors.requestLock.unlock();
      final result = await _retryLastRequest(dioError);
      _retryCount = 0;
      handler.resolve(result);
    }).catchError((error, stackTrace) {
      if (refreshOptions.printLog) {
        print('Token not refreshed, rejecting the request!');
      }
      dio.interceptors.requestLock.unlock();
      handler.reject(error);
    });
  }

  Future<Response> _retryLastRequest(DioError dioError) async => dio.request(
        dioError.requestOptions.path,
        data: dioError.requestOptions.data,
        queryParameters: dioError.requestOptions.queryParameters,
      );
}
