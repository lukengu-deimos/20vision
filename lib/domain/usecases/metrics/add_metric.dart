import 'dart:ffi';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:visionapp/domain/entities/metric.dart';
import 'package:visionapp/domain/entities/post.dart';
import 'package:visionapp/domain/enums/metric_type.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/metric_repository.dart';
import 'package:visionapp/domain/repostories/post_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';

class AddMetric implements UseCase<bool, AddMetricParams> {
  final MetricRepository repository;

  AddMetric(this.repository);

  @override
  Future<Either<Failure, bool>> call(AddMetricParams params) async {
    return await repository.addMetric(
      userId: params.userId,
      postId: params.postId,
      type: params.type,
      value: params.value,
    );
  }
}

class AddMetricParams {
  final int userId;
  final int postId;
  final MetricType type ;
  final String value;


  AddMetricParams({
    required this.userId,
    required this.postId,
    required this.type,
    required this.value,
  });
}