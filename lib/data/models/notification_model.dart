import 'package:visionapp/core/utils/class_to_json.dart';
import 'package:visionapp/core/utils/date_utils.dart';
import 'package:visionapp/domain/entities/comment.dart';
import 'package:visionapp/domain/entities/notification.dart';


class NotificationModel extends Notification implements JsonSerializable {
  NotificationModel({
    required  super.body,
    required  super.title,
    required  super.createdAt,
    required  super.notificationId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> map) {
    return NotificationModel(
      body: map['body'],
      title: map['subject'],
      createdAt: map['createdAt'],
      notificationId: map['id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'title': title,
      'notificationId': notificationId,
      'createdAt': createdAt,
    };
  }
}