import 'dart:io';

import 'package:ai_image_generator/features/generate/data/repo/contract_repo.dart';
import 'package:dio/dio.dart';

class GenerateServicesRepo implements GenerateContractRepo {
  @override
  Future<File?> generateImage(String prompt) async {
    String url = 'https://api.vyro.ai/v2/image/generations';
    String apiKey = 'vk-LwuY8XBj9yjaVWF3FFmcXA2ht8I3EMBDoTd2S2M2ilLOW2tJ';
    Map<String, dynamic> header = {'Authorization': 'Bearer $apiKey'};

    Map<String, dynamic> payload = {
      'prompt': prompt,
      'style': 'realistic',
      'aspect_ratio': "1:1",
      'cfg': '1',
      'seed': '1',
      'high_res_result': '1',
    };
    Dio dio = Dio();
    dio.options = BaseOptions(
      headers: header,
    );
    final response = await dio.post(url, data: payload);
    if (response.statusCode == 200) {
      File file = File('image.jpg');
      file.writeAsBytesSync(response.data);
    } else {
      return null;
    }
    return null;
  }
}
