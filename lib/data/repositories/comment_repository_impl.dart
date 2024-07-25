import 'package:fpdart/fpdart.dart';
import 'package:visionapp/core/networks/connection_checker.dart';
import 'package:visionapp/data/datasources/local/comment_local_datasource.dart';
import 'package:visionapp/data/datasources/remote/comment_remote_datasource.dart';
import 'package:visionapp/domain/entities/comment.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/domain/repostories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;
  final CommentLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  CommentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker
  });

  @override
  Future<Either<Failure, List<Comment>>> getComments(int postId) async {
    try {
      if( await (connectionChecker.isConnected)){
        final comments = await remoteDataSource.getComments(postId);
        await localDataSource.cacheComments(comments);
        return Right(comments);
      } else {
        final comments = localDataSource.getComments(postId);
        return Right(comments);
      }
    } on ServiceException catch  (e) {
      return Left(Failure(e.message));
    }
  }
}