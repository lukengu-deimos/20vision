enum UserRole {appUser, newsPublisher}
extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.appUser:
        return 'app_user';
      case UserRole.newsPublisher:
        return 'news_publisher';
      default:
        return 'app_user';
    }
  }
  static UserRole fromString(String value) {
    switch (value) {
      case 'app_user':
        return UserRole.appUser;
      case 'news_publisher':
        return UserRole.newsPublisher;
      default:
        return UserRole.appUser;
    }
  }
}
