import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visionapp/core/cubits/app_user_cubit.dart';
import 'package:visionapp/data/repositories/alert_repository_impl.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/enums/user_role.dart';
import 'package:visionapp/domain/usecases/auth/current_user.dart';
import 'package:visionapp/domain/usecases/auth/pick_image.dart';
import 'package:visionapp/domain/usecases/auth/reset_password.dart';
import 'package:visionapp/domain/usecases/auth/update_profile.dart';
import 'package:visionapp/domain/usecases/auth/user_sigin.dart';
import 'package:visionapp/domain/usecases/auth/user_signup.dart';

import '../../core/generics/no_params.dart';

//Sate
@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final User? user;

  AuthSuccess(this.user);
}

final class AuthNewsPublisherRegistered extends AuthState {
  final User user;

  AuthNewsPublisherRegistered(this.user);
}

final class AuthPasswordSuccess extends AuthState {}

//Login

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

// Profile Image
final class AuthFilePicked extends AuthState {
  final File file;

  AuthFilePicked(this.file);
}

//Events
@immutable
sealed class AuthEvent {}

//Login
final class AuthSignUp extends AuthEvent {
  final String fullname;
  final String username;
  final String mobileNumber;
  final String password;
  final String emailAddress;
  final String role;
  final String? bio;
  final File? profilePic;
  final bool active;

  AuthSignUp(
      {required this.fullname,
      required this.username,
      required this.mobileNumber,
      required this.password,
      required this.emailAddress,
      required this.role,
      this.bio,
      this.profilePic,
      this.active = false});
}

final class AuthUserIsLoggedIn extends AuthEvent {}
final class AuthUserReset extends AuthEvent {}

final class AuthUserSignIn extends AuthEvent {
  final String username;
  final String password;

  AuthUserSignIn({
    required this.username,
    required this.password,
  });
}

// Profile Image
final class AuthPickFile extends AuthEvent {
  final ImageSource imageSource;

  AuthPickFile(this.imageSource);
}

//User SignUp
final class AuthUserSignUp extends AuthEvent {
  final String fullname;
  final String username;
  final String mobileNumber;
  final String password;
  final String emailAddress;
  final String role;
  final String? bio;
  final File? profilePic;
  final bool active;

  AuthUserSignUp(
      {required this.fullname,
      required this.username,
      required this.mobileNumber,
      required this.password,
      required this.emailAddress,
      required this.role,
      this.bio,
      this.profilePic,
      this.active = false});
}

final class AuthUpdateUser extends AuthEvent {
  final User user;
  final File? profilePic;

  AuthUpdateUser({required this.user, this.profilePic});
}

final class AuthResetPassword extends AuthEvent {
  final String emailAddress;

  AuthResetPassword({required this.emailAddress});
}

//Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignIn _userSignIn;
  final PickImage _pickImage;
  final UserSignUp _userSignUp;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UpdateProfile _updateProfile;
  final ResetPassword _resetPassword;

  AuthBloc(
      {required UserSignIn userSignIn,
      required PickImage pickImage,
      required UserSignUp userSignUp,
      required AppUserCubit appUserCubit,
      required CurrentUser currentUser,
      required UpdateProfile updateProfile,
      required ResetPassword resetPassword})
      : _userSignIn = userSignIn,
        _pickImage = pickImage,
        _userSignUp = userSignUp,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _updateProfile = updateProfile,
        _resetPassword = resetPassword,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthUserSignIn>(_onAuthUserSignIn);
    on<AuthPickFile>(_onAuthPickFile);
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthUserIsLoggedIn>(_isUserLoggedIn);
    on<AuthUpdateUser>(_onAuthUpdateProfile);
    on<AuthResetPassword>(_onAuthResetPassword);
    on<AuthUserReset>((event, emit) => emit(AuthInitial()));
  }

  void _onAuthResetPassword(
      AuthResetPassword event, Emitter<AuthState> emit) async {
    var result = await _resetPassword
        .call(ResetPasswordParams(emailAddress: event.emailAddress));

    result.fold((failure) => emit(AuthFailure(failure.message)),
        (success) => emit(AuthPasswordSuccess()));
  }

  void _onAuthUpdateProfile(
      AuthUpdateUser event, Emitter<AuthState> emit) async {
    var result = await _updateProfile.call(UpdateProfileParams(
        fullname: event.user.fullname!,
        username: event.user.username,
        mobileNumber: event.user.mobileNumber,
        emailAddress: event.user.emailAddress ?? '',
        profilePic: event.profilePic,
        bio: event.user.bio,
        id: event.user.id!));
    result.fold((failure) => emit(AuthFailure(failure.message)),
        (user) => _emitAuthSuccess(user, emit, true));
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    var result = await _userSignUp.call(UserSignUpParams(
        fullname: event.fullname,
        username: event.username,
        mobileNumber: event.mobileNumber,
        password: event.password,
        emailAddress: event.emailAddress,
        role: event.role,
        bio: event.bio,
        active: event.active,
        profilePic: event.profilePic));
    result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) =>
            _emitAuthSuccess(user, emit, user.role == UserRole.appUser.value));
  }

  void _onAuthPickFile(AuthPickFile event, Emitter<AuthState> emit) async {
    var result = await _pickImage(PickImageParams(event.imageSource));

    result.fold((failure) => emit(AuthFailure(failure.message)),
        (file) => emit(AuthFilePicked(file)));
  }

  void _onAuthUserSignIn(AuthUserSignIn event, Emitter<AuthState> emit) async {
    final result = await _userSignIn(UserSignInParams(
      username: event.username,
      password: event.password,
    ));
    result.fold((failure) => emit(AuthFailure(failure.message)),
        (user) => _emitAuthSuccess(user, emit, true));
  }

  void _isUserLoggedIn(
      AuthUserIsLoggedIn event, Emitter<AuthState> emit) async {
    final result = await _currentUser(NoParams());
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit, true),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit, bool isAppUser) {
    if (isAppUser) {
      _appUserCubit.updateUser(user);
      emit(AuthSuccess(user));
    } else {
      emit(AuthNewsPublisherRegistered(user));
    }
  }
}
