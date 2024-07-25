import 'package:fpdart/fpdart.dart';
import 'package:visionapp/domain/entities/category.dart';
import 'package:visionapp/domain/exceptions/failure.dart';

abstract interface class CategoryRepository {
  Future<Either<Failure, List<Category>>> listCategory();
}