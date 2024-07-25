import 'package:fpdart/fpdart.dart';
import 'package:visionapp/core/generics/no_params.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/auth_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';



class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository repository;

  CurrentUser(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams param) async {

    return await repository.currentUser();
  }
}