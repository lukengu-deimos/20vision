import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:visionapp/core/networks/connection_checker.dart';
import 'package:visionapp/data/datasources/local/auth_local_data_source.dart';
import 'package:visionapp/data/datasources/remote/auth_remote_datasource.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/enums/user_role.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/domain/repostories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthRemoteDatasource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl({required this.remoteDataSource, required this
      .localDataSource, required this.connectionChecker});


  @override
  Future<Either<Failure, User>> signIn({required String username, required
  String password}) async {
    if(!await connectionChecker.isConnected) {
      return Left(Failure('No internet connection'));
    }
    try {
      final user = await remoteDataSource.signIn(username: username, password:
      password);
      localDataSource.cacheUserSession(user);
      return Right(user);
    } on ServiceException catch(e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({required String fullname, required
  String username, required String mobileNumber, required String password,
    required String emailAddress, required String role, required String? bio,
    required File? profilePic,
    required bool active}) async {

    if(!await connectionChecker.isConnected) {
      return Left(Failure('No internet connection'));
    }
    try {

      final user = await remoteDataSource.signUp(fullname: fullname,
          username: username, mobileNumber: mobileNumber, password: password,
          emailAddress: emailAddress,   role: role, bio: bio, profilePic:
          profilePic, active: active);
      if(user.role == UserRole.appUser.value) {
        localDataSource.cacheUserSession(user);
      }
      return Right(user);
    } on ServiceException catch(e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearUserSession() async {
    return Right(await localDataSource.clearUserSession());
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    final user = await localDataSource.getSessionUserData();
    if(user != null) {
      return Right(user);
    }
    return Left(Failure(''));
  }

  @override
  Future<Either<Failure, User>> updateProfile({required String fullname,
    required String username, required String mobileNumber, required String
    emailAddress, String? bio, File? profilePic, required int id}) async {
    try {
      final user = await remoteDataSource.updateProfile(fullname: fullname,
          username: username, mobileNumber: mobileNumber, emailAddress:
          emailAddress,  bio: bio,
          profilePic: profilePic, id: id);
      localDataSource.cacheUserSession(user);
      return Right(user);
    } on ServiceException catch(e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> sendResetPassword({required String
  emailAddress}) async {
    // TODO: implement sendResetPassword
    try {
      final result = await remoteDataSource.sendResetLink(emailAddress:
      emailAddress);
      return Right(result);
    } on ServiceException catch(e) {
      return Left(Failure(e.message));
    }
  }

  
  
}