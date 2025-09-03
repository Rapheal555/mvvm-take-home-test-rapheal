import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../error/exceptions.dart';
import 'api_constants.dart';

class ApiService {
  final Dio _dio;
  final SharedPreferences _prefs;

  ApiService({required SharedPreferences prefs})
    : _prefs = prefs,
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          responseType: ResponseType.json,
        ),
      ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          final token = _prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            // Handle unauthorized error (e.g., logout user)
            _handleUnauthorized();
            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                error: const UnauthorizedException(),
              ),
            );
          }
          return handler.next(e);
        },
      ),
    );
  }

  void _handleUnauthorized() {
    // Clear stored credentials
    _prefs.remove('auth_token');
    _prefs.remove('user_id');
    // You might want to navigate to login screen or show a message
  }

  Future<Map<String, dynamic>> _handleResponse(Response response) async {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      if (data['success'] == false) {
        throw ApiException.fromJson(data);
      }
      return data;
    }
    throw const ApiException(message: 'Invalid response format');
  }

  // Auth APIs
  Future<Map<String, dynamic>> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      final data = await _handleResponse(response);
      if (data['token'] != null) {
        await _prefs.setString('auth_token', data['token']);
        await _prefs.setInt('user_id', data['userId']);
      }
      return data;
    } on DioException catch (e) {
      throw _handleDioError(e, context);
    }
  }

  Future<Map<String, dynamic>> register(
    BuildContext context,
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await _dio.post(ApiConstants.register, data: userData);
      final data = await _handleResponse(response);
      if (data['token'] != null) {
        await _prefs.setString('auth_token', data['token']);
        await _prefs.setInt('user_id', data['userId']);
      }
      return data;
    } on DioException catch (e) {
      throw _handleDioError(e, context);
    }
  }

  Future<Map<String, dynamic>> updateInterests(
    BuildContext context,
    List<int> interests,
  ) async {
    try {
      final userId = _prefs.getInt('user_id');
      final response = await _dio.post(
        '/users/$userId/interests',
        // ApiConstants.updateInterests,
        data: {'interests': interests},
      );
      return await _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e, context);
    }
  }

  // Articles APIs
  Future<List<Map<String, dynamic>>> getBlogPosts(
    BuildContext context, {
    String? categoryId,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.blogPosts,
        queryParameters: {if (categoryId != null) 'categoryId': categoryId},
      );
      // The response is already a list, no need to call _handleResponse
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      throw const ApiException(
        message: 'Invalid response format - expected an array',
      );
    } on DioException catch (e) {
      throw _handleDioError(e, context);
    }
  }

  Future<List<Map<String, dynamic>>> getInterests(BuildContext context) async {
    try {
      final userId = _prefs.getInt('user_id');
      final response = await _dio.get('/users/$userId/interests');
      // final data = await _handleResponse(response);
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e, context);
    }
  }

  // Future<List<Map<String, dynamic>>> getStreams() async {
  //   try {
  //     final response = await _dio.get(ApiConstants.streams);
  //     final data = await _handleResponse(response);
  //     return List<Map<String, dynamic>>.from(data['streams'] ?? []);
  //   } on DioException catch (e) {
  //     throw _handleDioError(e);
  //   }
  // }

  // Categories APIs
  Future<List<Map<String, dynamic>>> getCategories(BuildContext context) async {
    try {
      final response = await _dio.get(ApiConstants.categories);
      // final data = await _handleResponse(response);
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e, context);
    }
  }

  Exception _handleDioError(DioException e, BuildContext context) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkException(message: 'Connection timeout');
      case DioExceptionType.connectionError:
        return const NetworkException(message: 'No internet connection');
      case DioExceptionType.badResponse:
        if (e.response?.data is Map<String, dynamic>) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.response!.data['message'] ?? 'An error occurred'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          return ApiException.fromJson(e.response!.data);
          // return ApiException.fromJson(e.response!.data);
        }
        return ApiException(
          message: 'Error ${e.response?.statusCode}: ${e.message}',
        );
      default:
        return ApiException(message: e.message ?? 'An error occurred');
    }
  }
}
