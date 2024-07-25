class HttpHeadersConfig {
  static Map<String, String> json() => {
        'Content-Type': 'application/json',
      };

  static Map<String, String> multipart() => {
        'Content-Type': 'multipart/form-data',
      };

  static Map<String, String> urlencoded() => {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

  static Map<String, String> referer(String referer) => {
        'Referer': referer,
      };
}
