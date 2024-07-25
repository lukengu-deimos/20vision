import 'package:fpdart/fpdart.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/auth_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';

class UserSignIn implements UseCase<User, UserSignInParams>{
  final AuthRepository repository;
  UserSignIn(this.repository);

  @override
  Future<Either<Failure, User>> call(UserSignInParams params) async {
     return await repository.signIn(
       username: params.username,
       password: params.password,
     );
  }
}

class UserSignInParams {
  final String username;
  final String password;
  UserSignInParams({ required this.username, required this.password});
}