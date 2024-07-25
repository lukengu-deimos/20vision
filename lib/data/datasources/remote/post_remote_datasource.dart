import 'dart:io';

import 'package:dio/dio.dart';
import 'package:visionapp/core/data/base_response.dart';
import 'package:visionapp/data/models/category_model.dart';
import 'package:visionapp/data/models/post_model.dart';
import 'package:visionapp/domain/entities/post.dart';
import 'package:visionapp/domain/enums/http_method.dart';
import 'package:visionapp/domain/enums/linode_bucket.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/features/services/api_client_service.dart';




abstract interface class PostRemoteDatasource {
  Future<List<PostModel>> fetchRecent(CategoryModel? category);
  Future<Post> createPost({
    required String title,
    required String description,
    required List<int> categories,
    required File video,
    required int userId,
  });
}

class PostRemoteDatasourceImpl implements PostRemoteDatasource {
  final ApiClientService service;
  PostRemoteDatasourceImpl({required this.service});

  @override
  Future<List<PostModel>> fetchRecent(CategoryModel? category) async {
    String path = "posts";
    if(category != null ) path += "/category/${category.id}";

    final response = await service.execute(path:path, method: HttpMethod
        .get, headers: await service.headers);
    if (response.statusCode == 200) {
      final result =  BaseResponse<List<dynamic>>.fromJson(response.data);
      return result.data!.map((e) => PostModel.fromJson(e)).toList();
    } else {
      throw const ServiceException('Failed to fetch recent posts');
    }
  }

  @override
  Future<Post> createPost({required String title, required String
  description, required List<int> categories, required File video, required
  int userId})
  async {
    try {
      final uploadResponse = await _call(
          path: "files/upload/${LinodeBucket.videos.value}",
          method: HttpMethod.upload,
          file: video);
      if (uploadResponse.statusCode == 200) {
        final uploadResult = BaseResponse<Map<String, dynamic>>.fromJson(
          uploadResponse.data,
        );
        final videoUrl = uploadResult.data!['permanentUrl'];
        var payload = {
          'title': title,
          'content': description,
          'categories': categories,
          'videoUrl': videoUrl,
          'userId': userId
        };

        print(payload);

        final response = await _call(path:'posts', method: HttpMethod.post,
            body: payload);
        if (response.statusCode == 200) {
          final result = BaseResponse<Map<String, dynamic>>.fromJson(response.data);
          return PostModel.fromJson(result.data!);
        } else {
          throw const ServiceException('Failed to create post');
        }
      } else {
        throw const ServiceException('Failed to upload profile picture');
      }
    } on ServiceException catch (e) {
      throw ServiceException(e.message);
    }
  }

  Future<Response> _call(
      {required String path,
        required HttpMethod method,
        Map<String, dynamic>? body,
        File? file}) async {
    return await service.execute(
        path: path,
        method: method,
        body: body,
        headers: await service.headers,
        file: file);
  }
}


