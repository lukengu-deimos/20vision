import 'package:visionapp/core/utils/class_to_json.dart';
import 'package:visionapp/domain/entities/user.dart';

class UserModel extends User implements JsonSerializable {
  UserModel({
    super.id,
    required super.username,
    super.password,
    super.emailAddress,
    required super.mobileNumber,
    required super.fullname,
    super.role,
    super.bio,
    super.active,
    super.createdAt,
    super.updateAt,
    super.profilePic,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      password: json['password'] as String,
      emailAddress: json['emailAddress'] as String?,
      mobileNumber: json['mobileNumber'] as String,
      fullname: json['fullname'] as String,
      role: json['role'] as String,
      bio: json['bio'] as String?,
      active: json['active'] as bool,
      createdAt: json['createdAt'] as String?,
      updateAt: json['updatedAt'] as String?,
      profilePic: json['profilePic'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'emailAddress': emailAddress,
      'mobileNumber': mobileNumber,
      'fullname': fullname,
      'role': role,
      'bio': bio,
      'active': active,
      'createdAt': createdAt,
      'updateAt': updateAt,
      'profilePic': profilePic,
    };
  }
  UserModel copyWith({
    int? id,
    String? fullname,
    String? username,
    String? mobileNumber,
    String? emailAddress,
    String? bio,
    String? profilePic,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      username: username ?? this.username,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      bio: bio ?? this.bio,
      profilePic: profilePic ?? this.profilePic,
    );
  }
}

