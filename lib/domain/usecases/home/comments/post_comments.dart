import 'package:fpdart/fpdart.dart';
import 'package:visionapp/core/generics/no_params.dart';
import 'package:visionapp/domain/entities/comment.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/comment_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';

class PostComments implements UseCase<List<Comment>, PostCommentsParams> {
  final CommentRepository repository;

  PostComments(this.repository);

  @override
  Future<Either<Failure, List<Comment>>> call(PostCommentsParams params) async {
    return await repository.getComments(params.id);
  }
}
class PostCommentsParams {
  final int id;
  PostCommentsParams(this.id);
}