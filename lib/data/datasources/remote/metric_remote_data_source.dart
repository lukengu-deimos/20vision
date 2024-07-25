
import 'dart:convert';
import 'dart:ffi';

import 'package:visionapp/core/data/base_response.dart';
import 'package:visionapp/data/models/metric_count_model.dart';
import 'package:visionapp/domain/enums/http_method.dart';
import 'package:visionapp/domain/enums/metric_type.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/features/services/api_client_service.dart';

abstract interface class MetricRemoteDataSource {
  Future<List<MetricCountModel>> getPostMetrics({required int postId});
  Future<void> addMetric({required int userId, required int postId, required
  MetricType type, required String value});
}


class MetricRemoteDataSourceImpl implements MetricRemoteDataSource {

  final ApiClientService service;
  MetricRemoteDataSourceImpl({required this.service});

  @override
  Future<List<MetricCountModel>> getPostMetrics({required int postId}) async {
    final response = await service.execute(path:'metrics/posts/$postId',
        method: HttpMethod.get, headers: await service.headers);
    try {
      if (response.statusCode == 200) {
        final result = BaseResponse<List<dynamic>>.fromJson(response.data);
        return result.data!.map((e) => MetricCountModel.fromJson(e)).toList();
      } else {
        throw const ServiceException('Failed to fetch post metrics');
      }
    } on ServiceException catch (e) {
      print(e.message);
      throw e;
    }
  }

  @override
  Future<void> addMetric({required int userId, required int postId, required
  MetricType type, required String value}) async {

    final response = await service.execute(path:'metrics',
        method: HttpMethod.post, body: {
      'userId': userId, 'postId': postId, 'type': type.value, 'value': value
        }, headers: await service.headers);



    if (response.statusCode != 200) {
      throw const ServiceException('Failed to  post metrics');
    }
  }

}