import 'package:geolocator/geolocator.dart';
import 'package:rutils_location/src/rutils_position.dart';

class LocationFailure implements Exception {
  final Object? error;

  const LocationFailure({this.error});
}

enum RUtilsLocationStatus {
  hasPermission,
  serviceDisabled,
  denied,
  deniedForever
}

Future<RUtilsPosition> determinePosition() async =>
    askForPermission().then((value) async {
      final position = await Geolocator.getCurrentPosition();
      return RUtilsPosition.fromPosition(position);
    }).onError((error, stackTrace) {
      throw LocationFailure(error: error);
    });

Future<RUtilsLocationStatus> askForPermission() async {
  if (await checkLocationStatus() == RUtilsLocationStatus.hasPermission) {
    return RUtilsLocationStatus.hasPermission;
  }

  final permission = await Geolocator.requestPermission();
  switch (permission) {
    case LocationPermission.denied:
      return RUtilsLocationStatus.denied;
    case LocationPermission.deniedForever:
      return RUtilsLocationStatus.deniedForever;
    case LocationPermission.whileInUse:
    case LocationPermission.always:
      if (await isLocationServiceEnabled()) {
        return RUtilsLocationStatus.hasPermission;
      } else {
        return RUtilsLocationStatus.serviceDisabled;
      }
  }
}

Future<bool> isLocationServiceEnabled() async =>
    Geolocator.isLocationServiceEnabled();

Future<RUtilsLocationStatus> checkLocationStatus() async {
  LocationPermission permission;
  bool serviceEnabled;

  serviceEnabled = await isLocationServiceEnabled();
  if (!serviceEnabled) {
    return RUtilsLocationStatus.serviceDisabled;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    return RUtilsLocationStatus.denied;
  }

  if (permission == LocationPermission.deniedForever) {
    return RUtilsLocationStatus.deniedForever;
  }

  return RUtilsLocationStatus.hasPermission;
}
