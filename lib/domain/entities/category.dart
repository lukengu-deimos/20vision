import 'package:hive/hive.dart';
import 'package:visionapp/domain/entities/post.dart';
part 'category.g.dart';

@HiveType(typeId: 2)
class Category
{
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  String? createdAt;
  @HiveField(4)
  String? updateAt;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.createdAt,
    this.updateAt,
  });
}
