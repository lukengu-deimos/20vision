import 'package:hive/hive.dart';
import 'package:visionapp/core/utils/video_cache_manager.dart';
import 'package:visionapp/data/models/post_model.dart';
import 'package:visionapp/domain/entities/post.dart';
import 'package:visionapp/domain/entities/category.dart';
abstract interface class PostLocalDatasource {
  List<Post> fetchRecent(Category? category);
  saveRecent(List<PostModel> recentPosts);
}

class PostLocalDatasourceImpl implements PostLocalDatasource {
  final Box<Post> box;
  PostLocalDatasourceImpl(this.box);

  @override
  List<Post> fetchRecent(Category? category) {
    List<Post> recentPosts = [];
    for(Post post in box.values){
      recentPosts.add(post);

    }
    if(category !=  null){
      recentPosts = recentPosts.where((element) => element.categories.contains(category.name))
          .toList();
    }
    return recentPosts;
  }

  @override
  saveRecent(List<PostModel> recentPosts) {
    box.clear();
    for(int i= 0; i < recentPosts.length; i++){
      box.put(i, recentPosts[i]);
     // VideoCacheManager().getSingleFile(recentPosts[i].videoUrl);
    }
  }


}
