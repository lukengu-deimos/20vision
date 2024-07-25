
class User {
  int? id;
  String username;
  String? password;
  String ?emailAddress;
  String mobileNumber;
  String? fullname;
  String? role;
  String ?bio;
  bool? active;
  String ?createdAt;
  String? updateAt;
  String? profilePic;



  User({
    required this.id,
    required this.username,
   this.password,
    this.emailAddress,
    required this.mobileNumber,
   this.role,
    this.bio,
    this.active,
    this.createdAt,
    this.updateAt,
    this.profilePic,
    required this.fullname
  });


}
