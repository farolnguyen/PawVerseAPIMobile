import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'dart:io';
import '../../config/app_config.dart';
import '../../core/errors/api_exception.dart';
import 'storage_service.dart';

class ApiService {
  final Dio _dio;
  final StorageService _storageService;

  ApiService(this._storageService) : _dio = Dio() {
    _setupDio();
  }

  void _setupDio() {
    // Base Options
    _dio.options = BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

    // DEVELOPMENT ONLY: Bypass SSL certificate verification
    // ⚠️ REMOVE THIS IN PRODUCTION!
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = 
          (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );

    // Add Interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    // Add Logging Interceptor (for debugging)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('[Dio] $obj'),
      ),
    );
  }

  // Request Interceptor - Attach JWT Token
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get JWT token from storage
    final token = await _storageService.getToken();
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    print('[Request] ${options.method} ${options.path}');
    return handler.next(options);
  }

  // Response Interceptor
  Future<void> _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    print('[Response] ${response.statusCode} ${response.requestOptions.path}');
    return handler.next(response);
  }

  // Error Interceptor
  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    print('[Error] ${error.message}');

    // Handle 401 Unauthorized - Token expired
    if (error.response?.statusCode == 401) {
      // Try to refresh token
      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry the original request
          final options = error.requestOptions;
          final token = await _storageService.getToken();
          options.headers['Authorization'] = 'Bearer $token';
          
          final response = await _dio.fetch(options);
          return handler.resolve(response);
        }
      } catch (e) {
        // Refresh failed, logout user
        await _storageService.deleteToken();
        // TODO: Navigate to login screen
      }
    }

    return handler.next(error);
  }

  // Refresh Token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '${AppConfig.authEndpoint}/refresh-token',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['data']['token'];
        await _storageService.saveToken(newToken);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // GET Request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // POST Request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // PUT Request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // DELETE Request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // Upload File
  Future<Response> uploadFile(
    String path,
    String filePath, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        ...?data,
      });

      final response = await _dio.post(path, data: formData);
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
