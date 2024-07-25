import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:visionapp/data/datasources/local/alert_local_data_source.dart';
import 'package:visionapp/data/datasources/remote/alert_remote_data_source.dart';
import 'package:visionapp/domain/entities/notification.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/alert_repository.dart';

class AlertRepositoryImpl implements AlertRepository {

  final AlertLocalDataSource localDataSource;
  final AlertRemoteDataSource remoteDataSource;

  AlertRepositoryImpl({required this.localDataSource, required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Notification>>> getAlerts() async {
    try {
      final alerts = localDataSource.getAlerts();
      return Right(alerts);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Notification>>> deleteAlert(int id, int userId) async {
    try {
      localDataSource.deleteAlert(id);
      await remoteDataSource.updateDeleted(id, userId);
      return  Right(localDataSource.getAlerts());
    } catch (e) {
      return Left(Failure(e.toString()));
    }

  }

  @override
  Future<Either<Failure, List<Notification>>> updateAlerts(int userId) async {
    try {
      print("here");
      final alerts =  await remoteDataSource.getNotifications(userId);
      print(jsonEncode(alerts));
      localDataSource.addAlert(alerts);
      return  Right(localDataSource.getAlerts());
    } catch (e) {
      return Left(Failure(e.toString()));
    }

  }

}