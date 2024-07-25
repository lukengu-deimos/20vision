
import 'dart:convert';

import 'package:visionapp/core/utils/shared_prefs.dart';
import 'package:visionapp/data/models/user_model.dart';

abstract interface class AuthLocalDataSource {
  Future<String?> get userSession;
  Future<UserModel?> getSessionUserData();
  Future<void> cacheUserSession(UserModel user);
  Future<void> clearUserSession();

}
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPrefs sharedPrefs;
  AuthLocalDataSourceImpl({required this.sharedPrefs});

  @override
  Future<String?> get userSession => sharedPrefs.getUser();
  @override
  Future<UserModel?> getSessionUserData() async {
    if(await userSession == null) {
      return null;
    }
    return UserModel.fromJson(jsonDecode( (await userSession)!) ?? {});
  }

  @override
  Future<void> cacheUserSession(UserModel user) async {
    sharedPrefs.saveUser(jsonEncode(user.toJson()));
  }

  @override
  Future<void> clearUserSession() async {
    sharedPrefs.clearUser();
  }
}