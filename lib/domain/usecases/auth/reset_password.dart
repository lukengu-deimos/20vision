import 'package:fpdart/fpdart.dart';
import 'package:visionapp/core/generics/no_params.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/auth_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';



class ResetPassword implements UseCase<bool, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPassword(this.repository);

  @override
  Future<Either<Failure, bool>> call(ResetPasswordParams param) async {

    return await repository.sendResetPassword(emailAddress: param.emailAddress);
  }

}
class ResetPasswordParams {
  final String emailAddress;

  ResetPasswordParams({
    required this.emailAddress,
  });
}