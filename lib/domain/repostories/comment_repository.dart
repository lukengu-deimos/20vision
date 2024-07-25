import 'package:fpdart/fpdart.dart';
import 'package:visionapp/domain/entities/comment.dart';
import 'package:visionapp/domain/exceptions/failure.dart';

abstract interface class CommentRepository {
  Future<Either<Failure, List<Comment>>> getComments(int postId);
}