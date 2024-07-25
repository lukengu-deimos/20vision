import 'dart:ffi';

import 'package:fpdart/fpdart.dart';
import 'package:visionapp/domain/entities/metric_count.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/enums/metric_type.dart';
import 'package:visionapp/domain/exceptions/failure.dart';

abstract interface class MetricRepository {
  Future<Either<Failure, List<MetricCount>>> getPostMetrics({required int
  postId});
  Future<Either<Failure, bool>> addMetric({ required int userId, required int postId, required MetricType type, required String value});
}