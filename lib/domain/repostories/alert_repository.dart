
import 'package:fpdart/fpdart.dart';
import 'package:visionapp/domain/entities/notification.dart';
import 'package:visionapp/domain/exceptions/failure.dart';

abstract interface class AlertRepository {
  Future<Either<Failure, List<Notification>>> getAlerts();
  Future<Either<Failure, List<Notification>>> deleteAlert(int id, int userId);
  Future<Either<Failure, List<Notification>>> updateAlerts(int userId);
}