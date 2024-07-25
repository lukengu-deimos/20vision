import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/auth_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';

class UserSignUp implements UseCase<User, UserSignUpParams>{
  
  final AuthRepository repository;
  UserSignUp(this.repository);
  
  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await repository.signUp(
        fullname: params.fullname,
        username: params.username,
        mobileNumber: params.mobileNumber,
        password: params.password,
        emailAddress: params.emailAddress,
        role: params.role,
        bio: params.bio,
        profilePic: params.profilePic,
        active: params.active
    );
  }
}

class UserSignUpParams {
  final String fullname;
  final String username;
  final String mobileNumber;
  final String password;
  final String emailAddress;
  final String role;
  final String? bio;
  final File? profilePic;
  final  bool active;

  UserSignUpParams({
    required this.fullname,
    required this.username,
    required this.mobileNumber,
    required this.password,
    required this.emailAddress,
    required this.role,
    this.bio,
    this.profilePic,
    this.active = false
  });
}