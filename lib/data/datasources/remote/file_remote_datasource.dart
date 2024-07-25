import 'dart:io';

import 'package:visionapp/core/data/base_response.dart';
import 'package:visionapp/domain/enums/http_method.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/features/services/api_client_service.dart';

abstract interface class FileRemoteDatasource {
  Future<String> upload({required File file, required String path});
}

class FileRemoteDatasourceImpl implements FileRemoteDatasource {
  final ApiClientService service;
  FileRemoteDatasourceImpl({required this.service});

  @override
  Future<String> upload({required File file, required String path}) async {

    final response = await service.execute(path:'files/upload/$path', method: HttpMethod.upload, file:file
    );
    if (response.statusCode == 200) {
      final result =  BaseResponse<Map<String, dynamic>>.fromJson(response.data);
      if(result.success) {
        return result.data!['permanentUrl'];
      } else {
        throw  ServiceException(result.error!);
      }
    } else {
      throw const ServiceException('Failed to upload file');
    }
  }
}