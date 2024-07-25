enum MetricType {like, comment, dislike, views}
extension MetricTypeExtension on MetricType {
  String get value {
    switch (this) {
      case MetricType.like:
        return 'LIKE';
      case MetricType.comment:
        return 'COMMENT';
      case MetricType.dislike:
        return 'DISLIKE';
      case MetricType.views:
        return 'VIEWS';
      default:
        return '';
    }
  }
  static MetricType fromString(String value) {
    switch (value) {
      case 'LIKE':
        return MetricType.like;
      case 'COMMENT':
        return MetricType.comment;
      case 'DISLIKE':
        return MetricType.dislike;
      case 'VIEWS':
        return MetricType.views;
      default:
        return MetricType.like;
    }
  }
}