import 'dart:ffi';
import 'dart:io';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visionapp/core/generics/no_params.dart';
import 'package:visionapp/domain/entities/category.dart';
import 'package:visionapp/domain/entities/post.dart';
import 'package:visionapp/domain/usecases/home/posts/create_post.dart';
import 'package:visionapp/domain/usecases/home/posts/fetch_recent_category_posts.dart';
import 'package:visionapp/domain/usecases/home/posts/fetch_recent_posts.dart';
import 'package:visionapp/domain/usecases/home/posts/pick_video.dart';





@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

final class PostsFetched extends PostState {
  final List<Post> posts;

  PostsFetched(this.posts);
}


final class PostCreated extends PostState {
  final Post post;
  PostCreated(this.post);
}

final class PostFilePicked extends PostState{
  final File file;
  PostFilePicked(this.file);
}



final class PostError extends PostState {
  final String message;

  PostError(this.message);
}



//Events
@immutable
sealed class PostEvent {}

final class FetchPosts extends PostEvent {}
final class FetchCategoryPosts extends PostEvent {
  final Category category;
  FetchCategoryPosts(this.category);
}

final class PostPickFile extends PostEvent {
  final ImageSource imageSource;
  PostPickFile(this.imageSource);
}

final class CreatePostEvent extends PostEvent {
  final String title;
  final String body;
  final List<int> categories;
  final File videoFile;
  final int userId;

  CreatePostEvent({
    required this.title,
    required this.body,
    required this.categories,
    required this.videoFile,
    required this.userId,
  });
}


class PostBloc extends Bloc<PostEvent, PostState> {
  final FetchRecentPosts _fetchRecentPosts;
  final FetchRecentCategoryPosts _fetchRecentCategoryPosts;
  final CreatePost _createPost;
  final PickVideo _pickVideo;


  PostBloc({
    required FetchRecentPosts fetchRecentPosts,
    required FetchRecentCategoryPosts fetchRecentCategoryPosts,
    required PickVideo pickVideo,
    required CreatePost createPost,
  })  : _fetchRecentPosts = fetchRecentPosts,
        _fetchRecentCategoryPosts = fetchRecentCategoryPosts,
        _pickVideo =  pickVideo,
        _createPost = createPost,
        super(PostInitial()) {
    on<PostEvent>((_, emit) => emit(PostLoading()));
    on<FetchPosts>(_onFetchPosts);
    on<FetchCategoryPosts>(_onFetchCategoryPosts);
    on<PostPickFile>(_onPostPickFile);
    on<CreatePostEvent>(_onCreatePost);
  }

  _onCreatePost(CreatePostEvent event, Emitter<PostState> emit) async {

    final result = await _createPost.call(CreatePostParams(
      title: event.title,
      description: event.body,
      categories: event.categories,
      video: event.videoFile,
      userId: event.userId,
    ));
    result.fold(
      (failure) => emit(PostError(failure.message)),
      (post) => emit(PostCreated(post)),
    );
  }

  _onPostPickFile(PostPickFile event, Emitter<PostState> emit) async {
    final result = await _pickVideo.call(PickImageParams(event.imageSource));
    result.fold(
      (failure) => emit(PostError(failure.message)),
      (file) => emit(PostFilePicked(file)),
    );
  }

  _onFetchCategoryPosts(FetchCategoryPosts event, Emitter<PostState> emit) async {
    final result = await _fetchRecentCategoryPosts.call(FetchRecentCategoryPostsParams(event.category));
    result.fold(
      (failure) => emit(PostError(failure.message)),
      (posts) => emit(PostsFetched(posts)),
    );
  }
  _onFetchPosts(FetchPosts event, Emitter<PostState> emit) async {
    final result = await _fetchRecentPosts.call(NoParams());
    result.fold(
      (failure) => emit(PostError(failure.message)),
      (posts) => emit(PostsFetched(posts)),
    );
  }
}
