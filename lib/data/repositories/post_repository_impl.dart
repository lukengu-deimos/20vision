import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:visionapp/core/networks/connection_checker.dart';
import 'package:visionapp/data/datasources/local/auth_local_data_source.dart';
import 'package:visionapp/data/datasources/local/post_local_datasource.dart';
import 'package:visionapp/data/datasources/remote/auth_remote_datasource.dart';
import 'package:visionapp/data/datasources/remote/post_remote_datasource.dart';
import 'package:visionapp/data/models/category_model.dart';
import 'package:visionapp/domain/entities/category.dart';
import 'package:visionapp/domain/entities/post.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/enums/user_role.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/domain/repostories/auth_repository.dart';
import 'package:visionapp/domain/repostories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {

  final PostRemoteDatasource remoteDataSource;
  final PostLocalDatasource localDataSource;
  final ConnectionChecker connectionChecker;

  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker
  });

  @override
  Future<Either<Failure, List<Post>>> fetchRecent({Category? category})
  async {
    print("Fetching recent posts from repository");
    if(! await (connectionChecker.isConnected)){
      return Right(localDataSource.fetchRecent(category));
    }
    try {
      final posts = await remoteDataSource.fetchRecent((category as
      CategoryModel?));
      localDataSource.saveRecent(posts);
      return Right(posts);
    }  on ServiceException catch  (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Post>> createPost({required String title, required
  String description, required List<int> categories, required File video,
    required int userId}) async {

    try {
      final post = await remoteDataSource.createPost(
        title: title,
        description: description,
        categories: categories,
        video: video,
        userId: userId
      );
      return Right(post);
    }  on ServiceException catch  (e) {
      return Left(Failure(e.message));
    }
  }
}