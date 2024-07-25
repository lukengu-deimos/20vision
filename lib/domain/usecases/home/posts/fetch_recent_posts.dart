import 'package:fpdart/src/either.dart';
import 'package:visionapp/core/generics/no_params.dart';
import 'package:visionapp/domain/entities/category.dart';
import 'package:visionapp/domain/entities/post.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/post_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';

class FetchRecentPosts implements UseCase<List<Post>, NoParams> {
  final PostRepository repository;

  FetchRecentPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) async {
    print("Fetching recent posts from usercase");
    return await repository.fetchRecent();
  }
  
}