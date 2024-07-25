import 'dart:io';

import 'package:dio/dio.dart';
import 'package:visionapp/domain/enums/http_method.dart';

abstract interface class ApiClientService {
  Future<Map<String, String>> get headers;
  Future<String> get endpoint;
  Future<Response> execute({required String path, required HttpMethod method, Map<String,dynamic> ?body,  Map<String, String> ?headers, File ?file});
}