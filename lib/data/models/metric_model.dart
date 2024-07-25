import 'package:visionapp/core/utils/class_to_json.dart';
import 'package:visionapp/data/models/post_model.dart';
import 'package:visionapp/data/models/user_model.dart';
import 'package:visionapp/domain/entities/metric.dart';

class MetricModel extends Metric implements JsonSerializable
{
  MetricModel({
    required super.id,
    required super.user,
    required super.post,
    required super.type,
    required super.createdAt,
    required super.updatedAt,
  });
  factory MetricModel.fromJson(Map<String, dynamic> json) {
    return MetricModel(
      id: json['id'] as int,
      user: UserModel.fromJson(json['userId']),
      post: PostModel.fromJson(json['postId']),
      type: json['type'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': (user as UserModel).toJson(),
      'post': (post as PostModel).toJson(),
      'type': type,
    };
  }
} 