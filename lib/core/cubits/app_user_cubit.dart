import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visionapp/domain/entities/user.dart';

sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}
final class AppUserIsLoggedIn extends AppUserState {
  final User user;
  AppUserIsLoggedIn({
    required this.user,
  });
}


class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user){
    if(user == null) {
      emit(AppUserInitial());
    } else {
      emit(AppUserIsLoggedIn(user: user));
    }
  }

  void logout() {
    updateUser(null);
  }
}