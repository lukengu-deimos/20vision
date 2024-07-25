import 'package:fpdart/src/either.dart';
import 'package:visionapp/domain/entities/metric_count.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/metric_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';

class GetMetricsForPost implements UseCase<List<MetricCount>,
    GetMetricsForPostParams> {

  final MetricRepository repository;
  GetMetricsForPost(this.repository);

  @override
  Future<Either<Failure, List<MetricCount>>> call(GetMetricsForPostParams params) {
    return repository.getPostMetrics(postId: params.postId);
  }

}

class GetMetricsForPostParams {
  final int postId;
  GetMetricsForPostParams(this.postId);
}