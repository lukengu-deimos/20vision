import 'package:visionapp/domain/entities/user.dart';

import 'post.dart';

class Metric {
  final int id;
  final User user;
  final Post post;
  final String type;
  String? createdAt;
  String? updatedAt;

  Metric({
    required this.id,
    required this.user,
    required this.post,
    required this.type,
    this.createdAt,
    this.updatedAt,
  });

}