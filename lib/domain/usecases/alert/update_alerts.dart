import 'package:fpdart/fpdart.dart';
import 'package:visionapp/core/generics/no_params.dart';
import 'package:visionapp/domain/entities/notification.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/alert_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';

class UpdateAlerts implements UseCase<List<Notification>, UpdateAlertsParams> {
  final AlertRepository repository;

  UpdateAlerts(this.repository);

  @override
  Future<Either<Failure, List<Notification>>> call(UpdateAlertsParams params) async {
    return await repository.updateAlerts(params.userId);
  }
}
class UpdateAlertsParams {
  final int userId;
  UpdateAlertsParams(this.userId);

}