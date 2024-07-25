
import 'package:hive/hive.dart';
import 'package:visionapp/domain/entities/metric.dart';
import 'package:visionapp/domain/entities/metric_count.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/entities/category.dart';

part 'post.g.dart';

@HiveType(typeId: 1)
class Post {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final String videoUrl;
  @HiveField(4)
  final String ?createdAt;
  @HiveField(5)
  final String ?updatedAt;
  @HiveField(6)
  final List<dynamic> categories;
  @HiveField(7)
  final String username;
  @HiveField(8)
  final String ?profilePic;
  @HiveField(9)
  final List<dynamic> metrics;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.videoUrl,
    this.createdAt,
    this.updatedAt,
    required this.categories,
    required this.username,
    this.profilePic,
    required this.metrics
  });
}