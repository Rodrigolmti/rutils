class NetworkFailure implements Exception {
  final String? message;

  const NetworkFailure({this.message});
}
