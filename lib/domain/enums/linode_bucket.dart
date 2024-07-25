enum LinodeBucket {videos,categories,profiles}

extension LinodeBucketExtension on LinodeBucket {
  String get value {
    switch (this) {
      case LinodeBucket.videos:
        return 'videos';
      case LinodeBucket.categories:
        return 'categories';
      case LinodeBucket.profiles:
        return 'profiles';
      default:
        return '';
    }
  }
  static LinodeBucket fromString(String value) {
    switch (value) {
      case 'videos':
        return LinodeBucket.videos;
      case 'categories':
        return LinodeBucket.categories;
      case 'profiles':
        return LinodeBucket.profiles;
      default:
        return LinodeBucket.profiles;
    }
  }
}
