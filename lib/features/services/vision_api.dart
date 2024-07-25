import 'dart:io';

import 'package:dio/src/response.dart';
import 'package:visionapp/domain/enums/http_method.dart';
import 'package:visionapp/features/services/api_client_service.dart';
import 'package:visionapp/features/services/config/http_headers_config.dart';
import 'package:visionapp/features/services/config/vision_api_config.dart';
import 'package:visionapp/features/services/http_service.dart';

class VisionApi implements ApiClientService {

  final HttpService service;
  const VisionApi(this.service);

  @override
  Future<String> get endpoint async   {
    final config = await VisionApiConfig.load();
    return config.endpoint;
  }

  @override
  Future<Response> execute({required String path, required HttpMethod method,
  Map<String, dynamic>? body, Map<String, String>? headers, File ?file}) async {
    path = (await endpoint) + path;
    switch (method) {
      case HttpMethod.post:
        return service.post(path, body!, headers!);
      case HttpMethod.get:
        return service.get(path, headers);
      case HttpMethod.put:
        return service.put(path, body!, headers!);
      case HttpMethod.patch:
        return service.patch(path, body!, headers!);
      case HttpMethod.delete:
        return service.delete(path, headers);
      case HttpMethod.upload:
        return service.upload(path, file!,headers!);
    }
  }

  @override
  Future<Map<String, String>> get headers async => HttpHeadersConfig.json();

}