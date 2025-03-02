import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ibadahku/constants/box_storage.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:ibadahku/core/provider/api/api_constants.dart';

class ApiClient {
  static const String baseUrl = ApiConstants.baseUrl;

  final Dio _dio = Dio();

  ApiClient() {
    // Initialize Dio default configurations
    _dio.options.baseUrl = baseUrl;
    _dio.options.receiveTimeout = const Duration(seconds: 60); // 3 seconds
    _dio.options.connectTimeout = const Duration(seconds: 60);
  }

  // URLs that don't require token
  static List<String> urlsWithoutToken = [
    // ApiConstants.loginEndpoint,
    // ApiConstants.kitchenTabsEndpoint,
  ];

  // Method to add x-api-key and x-token headers when necessary
  Future<void> _addHeadersIfRequired(String endpoint) async {
  //   if (!urlsWithoutToken.contains(endpoint)) {
  //     Map<String, dynamic> tokens =
  //         await _getTokens(); // Add your method to retrieve the tokens
  //     // _dio.options.headers["x-api-key"] = tokens['x-api-key'];
  //     log("X-Token: ${tokens['x-token']}");
  //     _dio.options.headers["X-Token"] = tokens['x-token'];
  //   }
  }

  // // Mock function to get tokens (Replace with actual implementation)
  // Future<Map<String, String>> _getTokens() async {
  //   // This should retrieve x-api-key and x-token from secure storage or preferences
  //   return {
  //     'x-token': AppStorage().get('current_user')['token'],
  //   };
  // }

  // POST method
  Future<dynamic> post({
    required String endpoint,
    required dynamic body,
    required Options? options,
  }) async {
    try {
      await _addHeadersIfRequired(endpoint);

      // Tambahkan logging
      log('Request URL: $endpoint');
      log('Request Headers: ${_dio.options.headers}');
      log('Request Body: $body');

      final response = await _dio.post(endpoint, data: body, options: options);

      // Log response
      log('Response Status: ${response.statusCode}');
      log('Response Data: ${response.data}');

      _handleErrorWhenStatus0(response.data);
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  // GET method
  Future<dynamic> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var now = DateTime.now();
      await _addHeadersIfRequired(endpoint);
      final response =
          await _dio.get(endpoint, queryParameters: queryParameters);
      _handleErrorWhenStatus0(response.data);

      log("Time elapsed: ${DateTime.now().difference(now).inMilliseconds} ms || ${DateTime.now().difference(now).inSeconds} s");
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  // PUT method
  Future<dynamic> put({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    try {
      await _addHeadersIfRequired(endpoint);
      final response = await _dio.put(endpoint, data: body);
      _handleErrorWhenStatus0(response.data);

      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  // DELETE method
  Future<dynamic> delete({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      await _addHeadersIfRequired(endpoint);
      final response =
          await _dio.delete(endpoint, queryParameters: queryParameters);
      _handleErrorWhenStatus0(response.data);
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  void _handleErrorWhenStatus0(dynamic response) {
    // log('response handle error when status 0: $response');
    if (response['status'] == 0) {
      log('response handle error when status 0: ${response['message']}');
      throw response['message'];
    }
  }

  // Error handling
  dynamic _handleError(dynamic error) {
    log("Original error: $error");

    if (error is DioException) {
      log("DioError type: ${error.type}");
      log("DioError message: ${error.message}");
      log("DioError response: ${error.response?.data}");
      log("DioError statusCode: ${error.response?.statusCode}");

      // Cek dulu apakah error response mengandung 'Akun tidak dikenali'
      if (error.response?.data?['message'] == 'Akun tidak dikenali') {
        Get.offAllNamed(Routes.login);
        BoxStorage().save('current_user', null);
        throw 'Akun tidak dikenali';
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          throw 'Koneksi timeout';
        case DioExceptionType.sendTimeout:
          throw 'Send timeout';
        case DioExceptionType.receiveTimeout:
          throw 'Receive timeout';
        case DioExceptionType.badResponse:
          final responseData = error.response?.data;
          throw responseData?['message'] ??
              'Error: ${error.response?.statusCode}';
        case DioExceptionType.cancel:
          throw 'Request dibatalkan';
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            throw 'Tidak dapat terhubung ke server';
          }
          throw error.message ?? 'Terjadi kesalahan yang tidak diketahui';
        default:
          // customSnackbar(ctx: Get.context!, text: 'The connection errored');
          throw 'Terjadi kesalahan: ${error.message}';
      }
    } else if (error == 'Akun tidak dikenali') {
      // Get.offAllNamed(Routes.loginKasir);
      // AppStorage().set('current_user', null);
      return;
    }

    throw error.toString();
  }
}
