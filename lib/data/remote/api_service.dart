import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:si_angkot/core/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  String? _token;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://yourapi.com/api/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (_token == null) {
          await _loadToken();
        }
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        // Logging request
        print('Request: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Logging response
        print('Response: ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        // Error handling
        print('Error: ${error.response?.statusCode} ${error.message}');
        return handler.next(error);
      },
    ));
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(Constant.TOKEN_KEY);
  }

  Future<void> setToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString(Constant.TOKEN_KEY, token);
    } else {
      await prefs.remove(Constant.TOKEN_KEY);
    }
    _token = token;
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParams, bool useToken = false}) async {
    try {
      return await _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: useToken ? Options(headers: {'Authorization': 'Bearer $_token'}) : null,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String endpoint, {dynamic data, bool useToken = false}) async {
    try {
      return await _dio.post(
        endpoint,
        data: data,
        options: useToken ? Options(headers: {'Authorization': 'Bearer $_token'}) : null,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String endpoint, {dynamic data, bool useToken = false}) async {
    try {
      return await _dio.put(
        endpoint,
        data: data,
        options: useToken ? Options(headers: {'Authorization': 'Bearer $_token'}) : null,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String endpoint, {dynamic data, bool useToken = false}) async {
    try {
      return await _dio.delete(
        endpoint,
        data: data,
        options: useToken ? Options(headers: {'Authorization': 'Bearer $_token'}) : null,
      );
    } catch (e) {
      rethrow;
    }
  }
}
