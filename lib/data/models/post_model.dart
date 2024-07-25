import 'dart:convert';

import 'package:visionapp/core/utils/class_to_json.dart';
import 'package:visionapp/data/models/user_model.dart';
import 'package:visionapp/domain/entities/metric_count.dart';
import 'package:visionapp/domain/entities/post.dart';


import 'category_model.dart';
import 'metric_model.dart';
class PostModel extends Post implements JsonSerializable{
  PostModel({
    required super.id,
    required super.title,
    required super.content,
    required super.videoUrl,
    required super.categories,
    required super.createdAt,
    required super.updatedAt,
    required super.profilePic,
    required super.username,
    required super.metrics,
  });


  factory PostModel.fromJson(Map<String, dynamic> json) {

    return PostModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      videoUrl: json['videoUrl'] as String,
      profilePic: json['profilePic'] as String,
      username: json['username'] as String,
      categories: json['categories'] as List<dynamic>,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      metrics: json['metrics'] != null ? json['metrics'] as List<dynamic>: [],

    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'videoUrl': videoUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'username': username,
      'profilePic': profilePic,
      'categories': categories,
      'metrics': metrics,
    };
  }

}