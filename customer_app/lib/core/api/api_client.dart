import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // Use computer's IP address for physical device testing
  // Use 10.0.2.2 for Android Emulator, localhost for iOS Simulator or Web
  static const String _baseUrl = 'http://10.0.2.2:5000/api/v1';
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) {
            print('API Request: ${options.method} ${options.path}');
            print('Data: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('API Response: ${response.statusCode} ${response.data}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print('API Error: ${e.message}');
            if (e.response != null) {
              print('Error Data: ${e.response?.data}');
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;



  // Helper method for login
  Future<Response> login(String firebaseToken) async {
    return await _dio.post('/auth/login', data: {
      'firebaseToken': firebaseToken,
    });
  }

  // Helper method for updating profile
  Future<Response> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? dob,
    String? bio,
    String? profileImage,
  }) async {
    return await _dio.put('/users/profile', data: {
      if (name != null) 'name': name,
      if (email != null && email.isNotEmpty) 'email': email,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (gender != null) 'gender': gender,
      if (dob != null) 'dob': dob,
      if (bio != null) 'bio': bio,
      if (profileImage != null) 'profileImage': profileImage,
    });
  }

  Future<Response> getProfile() async {
    return await _dio.get('/users/profile');
  }
}
