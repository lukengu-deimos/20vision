import 'package:dio/dio.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/features/services/config/vision_api_config.dart';


class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    // Set up Dio options
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        // Add the JWT token to the headers
        String token = await _getToken();
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options); // Continue with the request
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        // Handle the response
        return handler.next(response); // Continue with the response
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        // Handle errors
        return handler.next(error); // Continue with the error
      },
    ));
  }
  Future<String> _getToken() async {
    try {
      final config  = await VisionApiConfig.load();

      var response = await Dio().post(config.tokenUrl, data: {
        'username': config.username,
        'password': config.password,
      }, options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ));
      if (response.statusCode == 200) {
        return response.data['access_token']; // Adjust according to your API response structure
      } else {
        throw Exception('Failed to fetch token');
      }
    } catch (e) {
      throw Exception('Failed to fetch token');
    }
  }
  Dio get dio => _dio;
}