import 'package:geolocator/geolocator.dart';
import 'package:rutils_location/src/rutils_position.dart';

class LocationFailure implements Exception {
  final Object? error;

  const LocationFailure({this.error});
}

/// Location status enum
/// [hasPermission] the user has accept the permission
/// [serviceDisabled] the user has disabled the location service
/// [denied] the user has denied the permission
/// [deniedForever] the user has denied the permission forever (Only Android)
enum RUtilsLocationStatus {
  hasPermission,
  serviceDisabled,
  denied,
  deniedForever,
  unableToDetermine,
}

/// Determine the current position of the user in case of
/// [RUtilsLocationStatus.hasPermission]
Future<RUtilsPosition> determinePosition() async =>
    askForPermission().then((value) async {
      final position = await Geolocator.getCurrentPosition();
      return RUtilsPosition.fromPosition(position);
    }).onError((error, stackTrace) {
      throw LocationFailure(error: error);
    });

// Ask for location permission and return the [RUtilsLocationStatus]
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
    case LocationPermission.unableToDetermine:
      return RUtilsLocationStatus.unableToDetermine;
  }
}

/// Check if the location service is enabled is not the same as permission
/// location service is the location provider of the device
Future<bool> isLocationServiceEnabled() async =>
    Geolocator.isLocationServiceEnabled();

/// Return the [RUtilsLocationStatus] of the location permission
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
