import 'package:fpdart/src/either.dart';
import 'package:visionapp/core/generics/no_params.dart';
import 'package:visionapp/domain/entities/category.dart';
import 'package:visionapp/domain/entities/post.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/post_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';

class FetchRecentCategoryPosts implements UseCase<List<Post>, FetchRecentCategoryPostsParams> {
  final PostRepository repository;

  FetchRecentCategoryPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(FetchRecentCategoryPostsParams params) async {
    return await repository.fetchRecent(category: params.category);
  }
  
}
class FetchRecentCategoryPostsParams {
  final Category category;
  FetchRecentCategoryPostsParams(this.category);
}