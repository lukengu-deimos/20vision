import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:visionapp/core/data/base_response.dart';
import 'package:visionapp/data/models/category_model.dart';
import 'package:visionapp/data/models/post_model.dart';
import 'package:visionapp/domain/entities/post.dart';
import 'package:visionapp/domain/enums/http_method.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';

import '../../../features/services/api_client_service.dart';


abstract interface class CategoryRemoteDatasource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDatasourceImpl implements CategoryRemoteDatasource {
  final ApiClientService service;
  CategoryRemoteDatasourceImpl({required this.service});

  @override
  Future<List<CategoryModel>> getCategories() async   {
    final response = await service.execute(path:'category', method: HttpMethod
        .get, headers: await service.headers);
    if (response.statusCode == 200) {
      final result =  BaseResponse<List<dynamic>>.fromJson(response.data);
      return result.data!.map((e) => CategoryModel.fromJson(e)).toList();
    } else {
      throw const ServiceException('Failed to fetch recent posts');
    }
  }
}


