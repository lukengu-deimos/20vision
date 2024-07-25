import 'package:visionapp/core/data/base_response.dart';
import 'package:visionapp/data/models/comment_model.dart';
import 'package:visionapp/domain/enums/http_method.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/features/services/api_client_service.dart';

abstract interface class CommentRemoteDataSource {
  Future<List<CommentModel>> getComments(int postId);
}
class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {

  final ApiClientService service;

  CommentRemoteDataSourceImpl({required this.service});

  @override
  Future<List<CommentModel>> getComments(int postId) async {
    final response = await service.execute(path: 'metrics/comments/$postId',
        method: HttpMethod.get, headers: await service.headers);
    if (response.statusCode == 200) {
      final result = BaseResponse<List<dynamic>>.fromJson(response.data);
      return result.data!.map((e) => CommentModel.fromJson(e)).toList();
    } else {
      throw const ServiceException('Failed to fetch comments');
    }
  }
}
