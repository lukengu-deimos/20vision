import 'package:visionapp/core/data/base_response.dart';
import 'package:visionapp/data/models/notification_model.dart';
import 'package:visionapp/domain/enums/http_method.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/features/services/api_client_service.dart';

abstract interface class AlertRemoteDataSource {
  Future<bool> updateDeleted(int id, int userId);
  Future<List<NotificationModel>> getNotifications(int userId);
}

class AlertRemoteDataSourceImpl implements AlertRemoteDataSource {

  final ApiClientService service;
  AlertRemoteDataSourceImpl({required this.service});

  @override
  Future<bool> updateDeleted(int id, int userId) async {
    try {
      final response = await service.execute(path: 'notifications/$id', method:
      HttpMethod.put, body: {"deleted": true, "type": "PUSH", "userId": userId},
          headers: await service
              .headers);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw const ServiceException('Failed to fetch recent posts');
      }
    } on ServiceException catch(e) {
      throw  ServiceException(e.message);
    }
  }

  @override
  Future<List<NotificationModel>> getNotifications(int userId) async {
    final response = await service.execute
      (path:'notifications/user/$userId/PUSH',
        method:
    HttpMethod.get, headers: await service.headers);
    print('notifications/user/$userId/PUSH');
    print(response.statusCode);
    if (response.statusCode == 200) {

      final result = BaseResponse<List<dynamic>>.fromJson(response.data);
      return result.data!.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      throw const ServiceException('Failed to fetch recent posts');
    }
  }

}