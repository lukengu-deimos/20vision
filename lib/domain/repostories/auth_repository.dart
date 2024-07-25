
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/exceptions/failure.dart';

abstract interface class AuthRepository {

  Future<Either<Failure, User>> signIn({required String username, required
  String password});

  Future<Either<Failure, User>> signUp({
    required String fullname,
    required String username,
    required String mobileNumber,
    required String password,
    required String emailAddress,
    required String role,
    required String ?bio,
    required File ?profilePic,
    required bool active
  });

  Future<Either<Failure, User>> currentUser();
  Future<Either<Failure, void>> clearUserSession();

  Future<Either<Failure, User>> updateProfile({
    required String fullname,
    required String username,
    required String mobileNumber,
    required String emailAddress,
    String ?bio,
    File ?profilePic,
    required int id
  });
  Future<Either<Failure, bool>> sendResetPassword({required String emailAddress});
}


