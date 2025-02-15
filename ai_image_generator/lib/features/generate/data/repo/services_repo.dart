import 'dart:io';
import 'dart:typed_data';

import 'package:ai_image_generator/features/generate/data/repo/contract_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class GenerateServicesRepo implements GenerateContractRepo {
  @override
  Future<Uint8List?> generateImage(String prompt) async {
    String? url = dotenv.env['url'];
    String? apiKey = dotenv.env['key'];
    Map<String, dynamic> header = {'Authorization': 'Bearer $apiKey'};

    Map<String, dynamic> payload = {
      'prompt': prompt,
      'style': 'realistic',
      'aspect_ratio': "1:1",
      'cfg': '10',
      'seed': '10',
      'high_res_result': '1',
    };
    FormData formData = FormData.fromMap(payload);
    Dio dio = Dio();
    dio.options =
        BaseOptions(headers: header, responseType: ResponseType.bytes);
    final response = await dio.post(
      url ?? 'Empty',
      data: formData,
    );
    if (response.statusCode == 200) {
      Uint8List uint8list = Uint8List.fromList(response.data);
      debugPrint('RESPONSE DATA IS PRINTED');
      debugPrint(response.data.toString());
      return uint8list;
    } else {
      return null;
    }
  }

  @override
  Future<void> requestPermission() async {
    if (await Permission.storage.request().isGranted ||
        await Permission.photos.request().isGranted) {
      debugPrint("Storage permission granted");
    } else {
      debugPrint("Storage permission denied");
    }
  }



  /// Capture and save the image to the gallery
  @override
  Future<void> saveImageToGallery(
      mounted, context, ScreenshotController screenController) async {

       
    final Uint8List? image = await screenController.capture();
    if (image == null) {
      debugPrint("Error: Screenshot capture failed.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to capture image.")),
        );
      }
      return;
    }

    var status = await Permission.storage.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      requestPermission();
      debugPrint("Error: Permission denied.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Permission denied. Cannot save image.")),
        );
      }
      return;
    }

    // Save image
    final result = await ImageGallerySaverPlus.saveImage(
      image,
      name: "generated_image_${DateTime.now().millisecondsSinceEpoch}",
    );

    if (result['isSuccess'] == true) {
      debugPrint("Image saved successfully.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image saved successfully!")),
        );
      }
    } else {
      debugPrint("Error: Failed to save image.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save image.")),
        );
      }
    }
  }

  @override
  Future<void> shareImage(Uint8List? image) async {
    final directory = await getTemporaryDirectory();
    final imagePath = File('${directory.path}/generated_image.png');
    await imagePath.writeAsBytes(image!);

    Share.shareXFiles([XFile(imagePath.path)]);
  }
}
