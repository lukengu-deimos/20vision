import 'package:visionapp/core/data/base_response.dart';
import 'package:visionapp/core/utils/video_cache_manager.dart';
import 'package:visionapp/data/models/post_model.dart';
import 'package:visionapp/domain/enums/http_method.dart';
import 'package:visionapp/init_dependencies.dart';

import 'api_client_service.dart';

class VideoPostCache {
  VideoPostCache._();
  static final VideoPostCache instance = VideoPostCache._();
  factory VideoPostCache() => instance;

  networkCache() async {
    final service = serviceLocator<ApiClientService>();
    final response = await service.execute(path:"posts", method: HttpMethod
        .get, headers: await service.headers);
    if (response.statusCode == 200) {
      final result =  BaseResponse<List<dynamic>>.fromJson(response.data);
      final posts =  result.data!.map((e) => PostModel.fromJson(e))
          .toList();
      for(final post in posts) {
         VideoCacheManager().getSingleFile(post.videoUrl);
      }
    }
  }

}