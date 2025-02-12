
import 'dart:typed_data';

import 'package:ai_image_generator/features/generate/data/repo/contract_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GenerateServicesRepo implements GenerateContractRepo {
  @override
Future<Uint8List?> generateImage(String prompt) async {
  String url = 'https://api.vyro.ai/v2/image/generations';
  String apiKey = 'vk-LwuY8XBj9yjaVWF3FFmcXA2ht8I3EMBDoTd2S2M2ilLOW2tJ';
  Map<String, dynamic> header = {'Authorization': 'Bearer $apiKey'};

  Map<String, dynamic> payload = {
    'prompt': prompt,
    'style': 'realistic',
    'aspect_ratio': "1:1",
    'cfg': '0',
    'seed': '0',
    'high_res_result': '1',
  };
  FormData formData = FormData.fromMap(payload);
  Dio dio = Dio();
  dio.options =
      BaseOptions(headers: header, responseType: ResponseType.bytes);
  final response = await dio.post(
    url,
    data: formData,
  );
  if (response.statusCode == 200) {
    Uint8List uint8list = Uint8List.fromList(response.data);
    debugPrint('RESPONSE DATA IS PRINTED');
    debugPrint(String.fromCharCodes(response.data)); // Convert to String for printing
    return uint8list;
  } else {
    return null;
  }
}
}
