import 'package:hive/hive.dart';

part 'comment.g.dart';
@HiveType(typeId: 3)
class Comment {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String value;
  @HiveField(3)
  final int postId;
  @HiveField(4)
  final String createdAt;
  @HiveField(5)
  final String? profilePic;
  
  Comment({
    this.id,
    required this.username,
    required this.value,
    required this.postId,
    required this.createdAt,
    this.profilePic
  });
}