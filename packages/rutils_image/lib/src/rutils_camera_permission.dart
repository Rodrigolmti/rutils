import 'package:permission_handler/permission_handler.dart';

Future<bool> isCameraServiceEnabled() async =>
    Permission.camera.status.isGranted;

Future<void> openCameraAppSettings() => openAppSettings();

Future<void> validateCameraService() async {
  final status = await Permission.camera.status;
  if (status == PermissionStatus.denied) {
    await Permission.camera.request();
  } else if (status == PermissionStatus.permanentlyDenied ||
      status == PermissionStatus.restricted) {
    await openCameraAppSettings();
  }
}
