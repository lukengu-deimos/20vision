import 'package:visionapp/core/utils/class_to_json.dart';
import 'package:visionapp/core/utils/date_utils.dart';
import 'package:visionapp/domain/entities/comment.dart';


class CommentModel extends Comment implements JsonSerializable {
  CommentModel({
    required super.username,
    required super.value,
    required super.postId,
    required super.createdAt,
    super.profilePic,
    super.id,
  });

  factory CommentModel.fromJson(Map<String, dynamic> map) {
    return CommentModel(
      username: map['username'],
      value: map['value'],
      postId: map['postId'],
      createdAt: map['createdAt'] is int  ? formatTimestamp(map['createdAt']) : map['createdAt'],
      profilePic : map['profilePic'],
      id: map['id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'value': value,
      'postId': postId,
      'createdAt': createdAt,
      'profilePic': profilePic,
      'id': id,
    };
  }
}

