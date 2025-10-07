class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)';
  }

  factory ApiException.fromDioError(dynamic error) {
    if (error.response != null) {
      final response = error.response;
      final statusCode = response?.statusCode;
      
      // Try to extract error message from response
      String message = 'Có lỗi xảy ra';
      
      if (response?.data != null) {
        if (response.data is Map) {
          message = response.data['message'] ?? 
                   response.data['error'] ?? 
                   message;
        } else if (response.data is String) {
          message = response.data;
        }
      }
      
      return ApiException(
        message: message,
        statusCode: statusCode,
        data: response?.data,
      );
    } else {
      // Network error
      return ApiException(
        message: 'Không thể kết nối với server',
        statusCode: null,
      );
    }
  }
}
