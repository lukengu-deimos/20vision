import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/auth_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';

class UpdateProfile implements UseCase<User, UpdateProfileParams> {
  final AuthRepository repository;
  UpdateProfile({required this.repository});

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) {
    return repository.updateProfile(fullname: params.fullname, username:
    params.username, mobileNumber: params.mobileNumber, emailAddress: params.emailAddress, id: params.id, bio: params.bio, profilePic: params.profilePic);
  }
}

class UpdateProfileParams {
  final String fullname;
  final String username;
  final String mobileNumber;
  final String emailAddress;
  final String? bio;
  final File? profilePic;
  final int id;

  UpdateProfileParams({ 
    required this.fullname,
    required this.username,
    required this.mobileNumber,
    required this.emailAddress,
    this.bio,
    this.profilePic,
    required this.id
  });
  
}