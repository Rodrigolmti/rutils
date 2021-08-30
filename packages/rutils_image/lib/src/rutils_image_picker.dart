import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' show get;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Use this class to setup the image picker
/// [showCrop] - show crop image
/// [compressImage] - compress image
/// [imageQuality] - image quality
/// [maxWidth] - max image width
/// [maxHeight] - max image height
class RUtilsImagePickerOptions {
  final bool showCrop;
  final bool compressImage;
  final int imageQuality;

  final double? maxWidth;
  final double? maxHeight;

  const RUtilsImagePickerOptions({
    required this.showCrop,
    required this.compressImage,
    required this.imageQuality,
    this.maxWidth,
    this.maxHeight,
  });
}

/// Image picker utils based on [ImagePicker] and [ImageCropper]
/// You can get images from native camera and gallery
/// If you do not provide a image quality it will be set to 100,
/// ranging from 0-100
/// If you do not provide a max width or height it will be set according
/// to the image quality or the device supported dimensions
/// The download method will download the image from the url and store in
/// the remporary directory with the timestamp as the name
class RUtilsImagePicker {
  RUtilsImagePicker._();

  static final _picker = ImagePicker();

  static Future<File?> downloadImageFromPathAndStore({
    required String url,
  }) async {
    final response = await get(Uri.parse(url));
    final file = await _writeToFile(response.bodyBytes);

    return _cropImage(file);
  }

  static Future<File?> chooseImageFromGallery(
    RUtilsImagePickerOptions options,
  ) =>
      _getImageFromSource(options, ImageSource.gallery);

  static Future<File?> takeAPicture(
    RUtilsImagePickerOptions options,
  ) async =>
      _getImageFromSource(options, ImageSource.camera);

  static Future<File?> _getImageFromSource(
    RUtilsImagePickerOptions options,
    ImageSource source,
  ) async {
    final pickedFile = options.compressImage
        ? await _picker.pickImage(
            imageQuality: options.imageQuality,
            maxHeight: options.maxHeight,
            maxWidth: options.maxWidth,
            source: source,
          )
        : await _picker.pickImage(
            imageQuality: options.imageQuality,
            maxHeight: options.maxHeight,
            maxWidth: options.maxWidth,
            source: source,
          );

    if (pickedFile == null) {
      return null;
    }

    if (options.showCrop) {
      return _cropImage(File(pickedFile.path));
    }

    return File(pickedFile.path);
  }

  static Future<File?> _cropImage(File image) async => ImageCropper.cropImage(
        cropStyle: CropStyle.circle,
        sourcePath: image.path,
        maxWidth: 320,
        maxHeight: 320,
      );

  static Future<File> _writeToFile(Uint8List data) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final filePath = '$tempPath/${DateTime.now().toString()}.tmp';
    return File(filePath).writeAsBytes(data);
  }
}
