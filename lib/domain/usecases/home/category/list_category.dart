import 'package:fpdart/fpdart.dart';
import 'package:visionapp/core/generics/no_params.dart';
import 'package:visionapp/domain/entities/category.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/category_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';

class ListCategory implements UseCase<List<Category>, NoParams> {
  final CategoryRepository repository;

  ListCategory(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    return await repository.listCategory();
  }
}