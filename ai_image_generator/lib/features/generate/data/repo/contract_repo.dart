import 'dart:typed_data';

import 'package:screenshot/screenshot.dart';

abstract class GenerateContractRepo {
  Future<Uint8List?> generateImage(String prompt);
  Future<void> requestPermission();
  Future<void> saveImageToGallery(
      mounted, context, ScreenshotController screenController);
  Future<void> shareImage(Uint8List image);
}
