import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:visionapp/domain/entities/post.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/post_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';

class CreatePost implements UseCase<Post, CreatePostParams> {
  final PostRepository repository;

  CreatePost(this.repository);

  @override
  Future<Either<Failure, Post>> call(CreatePostParams params) async {
    return await repository.createPost(
      title: params.title,
      description: params.description,
      categories: params.categories,
      video: params.video,
      userId: params.userId,);
  }
}

class CreatePostParams {
  final String title;
  final String description;
  final List<int> categories;
  final File video;
  final int userId;


  CreatePostParams({
    required this.title,
    required this.description,
    required this.categories,
    required this.video,
    required this.userId,
  });
}