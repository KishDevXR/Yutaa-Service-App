import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // Use 10.0.2.2 for Android Emulator to access localhost
  // Use localhost for iOS Simulator or Web
  static const String _baseUrl = 'http://10.0.2.2:5000/api/v1';
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<Response> login(String firebaseToken) async {
    return await _dio.post(
      '/auth/login',
      data: {'firebaseToken': firebaseToken},
      queryParameters: {'role': 'partner'}, // Specify partner role
    );
  }

  Future<Response> updateProfile({
    required String name,
    String? email,
    String? serviceCategory,
  }) async {
    return await _dio.put('/users/profile', data: {
      'name': name,
      if (email != null) 'email': email,
      if (serviceCategory != null) 'serviceCategory': serviceCategory,
    });
  }

  Future<Response> getProfile() async {
    return await _dio.get('/users/profile');
  }
}
