import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

class SharedPrefs {
  SharedPrefs._();

  static final SharedPrefs instance = SharedPrefs._();

  factory SharedPrefs() => instance;

  Future<SharedPreferences> get prefs async =>
      await SharedPreferences.getInstance();

  Future<bool> has(String key) async  {
    return (await prefs).containsKey(key);
  }

  Future<void> delete(String key) async {
    if(await has(key)) {
      (await prefs).remove(key);
    }
  }

  Future<void> clear()  async{
    (await prefs).clear();
  }

  Future<T> get<T>(String key)  async{
    return  (await prefs).get(key) as T;
  }

  Future<void> save<T>(String key, T value)  async{
    if (value is String) {
      (await prefs).setString(key, value);
    } else if (value is int) {
      (await prefs).setInt(key, value);
    } else if (value is double) {
      (await prefs).setDouble(key, value);
    } else if (value is bool) {
      (await prefs).setBool(key, value);
    } else if (value is List<String>) {
      (await prefs).setStringList(key, value);
    } else {
      throw Exception('Type not supported');
    }
  }

  Future<String?> getUser() async {
    return await get(kUserSessionKey);
  }
  Future<void> saveUser(String value) async {
    await save(kUserSessionKey, value);
  }
  Future<void> clearUser() async {
    await delete(kUserSessionKey);
  }
}
