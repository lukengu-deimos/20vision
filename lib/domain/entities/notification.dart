import 'package:hive/hive.dart';
part 'notification.g.dart';

@HiveType(typeId: 4)
class Notification  {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String body;
  @HiveField(2)
  final int createdAt;
  @HiveField(3)
  final int notificationId;

  Notification({required this.title, required this.body, required this
      .createdAt, required this.notificationId});
}