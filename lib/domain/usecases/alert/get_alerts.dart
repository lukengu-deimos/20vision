import 'package:fpdart/src/either.dart';
import 'package:visionapp/core/generics/no_params.dart';
import 'package:visionapp/domain/entities/notification.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/alert_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';

class GetAlerts implements UseCase<List<Notification>, NoParams> {

  final AlertRepository repository;
  GetAlerts({required this.repository});

  @override
  Future<Either<Failure, List<Notification>>> call(NoParams params) async {
    return repository.getAlerts();
  }
}