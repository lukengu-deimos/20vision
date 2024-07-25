import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:visionapp/domain/entities/category.dart';
import 'package:visionapp/domain/entities/post.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/exceptions/failure.dart';

abstract interface class PostRepository {
  Future<Either<Failure, List<Post>>> fetchRecent({Category? category});
  Future<Either<Failure, Post>> createPost({
    required String title,
    required String description,
    required List<int> categories,
    required File video,
    required int userId,
});
}


