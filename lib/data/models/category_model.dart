


import 'dart:convert';

import 'package:visionapp/core/utils/class_to_json.dart';
import 'package:visionapp/data/models/post_model.dart';
import 'package:visionapp/domain/entities/category.dart';
class CategoryModel extends Category implements JsonSerializable
{
  CategoryModel({required super.id, required super.name, required super.imageUrl});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
    //  posts: (json['posts'] as List).map((e) => PostModel.fromJson(e))
      //    .toList(),


    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,

    };
  }

}