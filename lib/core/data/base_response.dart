class BaseResponse <T> {
  T ?data;
  String ?error;
  bool success;

  BaseResponse({required this.success, this.data, this.error});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      data: json['data'],
      error: json['error'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data,
    'success': success,
    'error': error,
  };
}