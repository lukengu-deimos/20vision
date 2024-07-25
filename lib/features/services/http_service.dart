import 'dart:io';

import 'package:dio/dio.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/features/services/dio_client.dart';

abstract interface class HttpService {
  Future<Response> get(String url, Map<String, String>? headers);

  Future<Response> post(
      String url, Map<String, dynamic> body, Map<String, String> headers);

  Future<Response> put(
      String url, Map<String, dynamic> body, Map<String, String> headers);

  Future<Response> delete(String url, Map<String, String>? headers);

  Future<Response> patch(
      String url, Map<String, dynamic> body, Map<String, String> headers);

  Future<Response> upload(String url, File file, Map<String, String>? headers);
}

class HttpServiceImpl implements HttpService {
  final dioClient = DioClient();

  @override
  Future<Response> get(String url, Map<String, String>? headers) async {
    try {
      final response = await dioClient.dio.get(
        url,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      throw ServiceException(_parseError(e));
    } catch (e) {
      throw const ServiceException('Failed to load data');
    }
  }

  @override
  Future<Response> post(String url, Map<String, dynamic> body,
      Map<String, String> headers) async {

    try {
      final response = await dioClient.dio
          .post(url, data: body, options: Options(headers: headers));
      return response;
    } on DioException catch (e) {
      throw ServiceException(_parseError(e));
    } catch (e) {
      throw const ServiceException('Failed to post data');
    }
  }

  @override
  Future<Response> put(String url, Map<String, dynamic> body,
      Map<String, String> headers) async {
    try {
      final response = await dioClient.dio
          .put(url, data: body, options: Options(headers: headers));
      return response;
    } on DioException catch (e) {
      throw ServiceException(_parseError(e));
    } catch (e) {
      throw const ServiceException('Failed to load data');
    }
  }

  @override
  Future<Response> delete(String url, Map<String, String>? headers) async {
    try {
      final response = await dioClient.dio.delete(
        url,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      throw ServiceException(_parseError(e));
    } catch (e) {
      throw const ServiceException('Failed to delete data');
    }
  }

  @override
  Future<Response> patch(String url, Map<String, dynamic> body,
      Map<String, String> headers) async {
    try {
      final response = await dioClient.dio
          .patch(url, data: body, options: Options(headers: headers));
      return response;
    } on DioException catch (e) {
      throw ServiceException(_parseError(e));
    } catch (e) {
      throw const ServiceException('Failed to patch data');
    }
  }

  @override
  Future<Response> upload(String url, File file, Map<String, String>? headers) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path,
          filename: file.path.split("/").last),
    });
    try {
      final response = await dioClient.dio.post(url, data: formData);
      if (response.statusCode == 200) {
        return response;
      } else {
        throw const ServiceException('Failed to upload file');
      }
    } on DioException catch (e) {
      throw ServiceException(_parseError(e));
    } on Exception catch (e) {
      throw const ServiceException('Failed to upload file');
    }
  }

  String _parseError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please try again later.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again later.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again later.';
      case DioExceptionType.badResponse:
        return e.response?.data['error'] ?? e.message;
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.unknown:
        return e.message ?? 'Unknown error';
      case DioExceptionType.badCertificate:
        return 'Bad certificate: ${e.message}';
      case DioExceptionType.connectionError:
        return 'Connection error: ${e.message}';
    }
  }
}
