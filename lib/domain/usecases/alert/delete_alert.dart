import 'package:fpdart/fpdart.dart';
import 'package:visionapp/domain/entities/notification.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/alert_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';

class DeleteAlert implements UseCase<List<Notification>, DeleteAlertParams> {
  final AlertRepository repository;

  DeleteAlert(this.repository);

  @override
  Future<Either<Failure, List<Notification>>> call(DeleteAlertParams params) async {
    return await repository.deleteAlert(params.id, params.userId);
  }
}
class DeleteAlertParams {
  final int id;
  final int userId;
  DeleteAlertParams(this.id, this.userId);
}
