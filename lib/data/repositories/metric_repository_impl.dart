import 'dart:ffi';

import 'package:fpdart/fpdart.dart';
import 'package:visionapp/data/datasources/remote/metric_remote_data_source.dart';
import 'package:visionapp/data/models/metric_count_model.dart';
import 'package:visionapp/domain/entities/metric_count.dart';
import 'package:visionapp/domain/enums/metric_type.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/domain/repostories/metric_repository.dart';

class MetricRepositoryImpl implements MetricRepository {
  final MetricRemoteDataSource remoteDataSource;

  MetricRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MetricCount>>> getPostMetrics({required int
  postId}) async {
    try {
      final metrics = await remoteDataSource.getPostMetrics(postId: postId);
      return Right(metrics);
    }  on ServiceException catch  (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> addMetric({required int userId, required int
  postId, required MetricType type, required String value}) async {
    try {
      print("repository.addMetric");
      await remoteDataSource.addMetric(
          userId: userId, postId: postId, type: type, value: value);
      return const Right(true);
    } on ServiceException catch  (e) {
      return Left(Failure(e.message));
    }
  }
}