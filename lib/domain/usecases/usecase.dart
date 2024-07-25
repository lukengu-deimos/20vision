import 'package:fpdart/fpdart.dart';
import 'package:visionapp/domain/exceptions/failure.dart';

abstract  interface class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}