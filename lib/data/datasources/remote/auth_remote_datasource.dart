import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:visionapp/core/constants/constants.dart';
import 'package:visionapp/core/data/base_response.dart';
import 'package:visionapp/data/models/user_model.dart';
import 'package:visionapp/domain/enums/http_method.dart';
import 'package:visionapp/domain/enums/linode_bucket.dart';
import 'package:visionapp/domain/enums/user_role.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/features/services/api_client_service.dart';
import 'package:visionapp/features/services/notification_service.dart';

abstract interface class AuthRemoteDatasource {
  Future<UserModel> signIn(
      {required String username, required String password});

  Future<UserModel> signUp(
      {required String fullname,
      required String username,
      required String mobileNumber,
      required String password,
      required String emailAddress,
      required String role,
      required String? bio,
      required File? profilePic,
      required bool active});

  Future<UserModel> updateProfile({
    required String fullname,
    required String username,
    required String mobileNumber,
    required String emailAddress,
    required File? profilePic,
    required String? bio,
    required int id,
  });

  Future<bool> sendResetLink({ required emailAddress});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDatasource {
  final ApiClientService service;
  final NotificationService notificationService;

  AuthRemoteDataSourceImpl(
      {required this.service, required this.notificationService});

  @override
  Future<UserModel> signIn(
      {required String username, required String password}) async {
    final response = await service.execute(
        path: 'users/login',
        method: HttpMethod.post,
        body: {
          'username': username,
          'password': password,
        },
        headers: await service.headers);
    if (response.statusCode == 200) {
      final result = BaseResponse<Map<String, dynamic>>.fromJson(response.data);
      if (result.success) {
        return UserModel.fromJson(result.data!);
      } else {
        throw ServiceException(result.error!);
      }
    } else {
      throw const ServiceException(
          'Failed to login with username and password');
    }
  }

  @override
  Future<UserModel> signUp(
      {required String fullname,
      required String username,
      required String mobileNumber,
      required String password,
      required String emailAddress,
      required String role,
      required String? bio,
      required File? profilePic,
      required bool active}) async {
    //Create a new user
    print("creating new user");
    final payload = {
      'fullname': fullname,
      'username': username,
      'mobileNumber': mobileNumber,
      'password': password,
      'emailAddress':emailAddress,
      'role': role,
      'bio': bio,
      'active': active
    };
    print(jsonEncode(payload));

    final response = await _call(path: 'users', method: HttpMethod.post,
        body: payload);

    if (response.statusCode == 200) {
      final result = BaseResponse<Map<String, dynamic>>.fromJson(response.data);

      if (result.success) {
        final user = UserModel.fromJson(result.data!);
        print("response data: ${result.data}");
        //Upload profile picture
        if (profilePic != null) {
          final uploadResponse = await _call(
              path: "files/upload/${LinodeBucket.profiles.value}",
              method: HttpMethod.upload,
              file: profilePic);
          if (uploadResponse.statusCode == 200) {
            final uploadResult = BaseResponse<Map<String, dynamic>>.fromJson(
                uploadResponse.data);
            final profileLink = uploadResult.data!['permanentUrl'];
            user.profilePic = profileLink;
            await _call(
                path: "users/${user.id}",
                method: HttpMethod.put,
                body: user.toJson());
          }
        }
        return user;
      } else {
        throw ServiceException(result.error!);
      }
    } else {
      throw const ServiceException(
          'Failed to login with username and password');
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String fullname,
    required String username,
    required String mobileNumber,
    required String emailAddress,
    required File? profilePic,
    required String? bio,
    required int id,
  }) async {
    try {
      String? profileLink;
      print("EMAIL ${emailAddress}");

      // If there's a profile picture, upload it
      if (profilePic != null) {
        final uploadResponse = await _call(
          path: "files/upload/${LinodeBucket.profiles.value}",
          method: HttpMethod.upload,
          file: profilePic,
        );

        if (uploadResponse.statusCode == 200) {
          final uploadResult = BaseResponse<Map<String, dynamic>>.fromJson(
            uploadResponse.data,
          );
          profileLink = uploadResult.data!['permanentUrl'];
        } else {
          throw const ServiceException('Failed to upload profile picture');
        }
      }

      // Create user model with the new data
      final user = UserModel(
        id: id,
        fullname: fullname,
        username: username,
        mobileNumber: mobileNumber,
        emailAddress: emailAddress,
        bio: bio,
        profilePic: profileLink,
      );
      print(user.toJson());

      // Update user profile
      final response = await _call(
        path: "users/$id",
        method: HttpMethod.put,
        body: user.toJson(),
      );


      if (response.statusCode == 200) {
        print(response.data);
        final result = BaseResponse<Map<String, dynamic>>.fromJson(response.data);
        if (result.success) {
          return UserModel.fromJson(result.data!);
        } else {
          throw ServiceException(result.error!);
        }
      } else {
        throw const ServiceException('Failed to update profile');
      }
    } catch (e) {
      throw ServiceException(e.toString());
    }
  }

  @override
  Future<bool> sendResetLink({required emailAddress}) async {
    final response = await _call(
      path: "users/reset-password",
      method: HttpMethod.post,
      body: {"emailAddress": emailAddress},
    );

    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        throw const ServiceException('Failed to send reset link');
      }
    } on ServiceException catch (e) {
      print(response.data);
      print(e.message);
       throw  ServiceException(e.message);
    }

  }

  Future<Response> _call(
      {required String path,
        required HttpMethod method,
        Map<String, dynamic>? body,
        File? file}) async {
    return await service.execute(
        path: path,
        method: method,
        body: body,
        headers: await service.headers,
        file: file);
  }
}
