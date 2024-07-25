

import 'package:hive/hive.dart';
import 'package:visionapp/data/models/comment_model.dart';
import 'package:visionapp/data/models/post_model.dart';
import 'package:visionapp/data/repositories/category_repository_impl.dart';
import 'package:visionapp/domain/entities/comment.dart';
import 'package:visionapp/domain/entities/post.dart';

abstract interface class CommentLocalDataSource {
  List<Comment> getComments(int postId);
  cacheComments(List<CommentModel> comments);
}

class CommentLocalDataSourceImpl implements CommentLocalDataSource {
  final Box<Comment> box;
  CommentLocalDataSourceImpl(this.box);

  @override
  List<Comment> getComments(int postId) {
    List<Comment> comments = [];
    for(Comment comment in box.values){
      comments.add(comment);
    }
    return comments.where((comment) => comment.postId == postId).toList();
  }

  @override
  cacheComments(List<CommentModel> comments) {
    box.clear();
    for(int i= 0; i < comments.length; i++){
      box.put(i, comments[i]);
    }
  }


}
