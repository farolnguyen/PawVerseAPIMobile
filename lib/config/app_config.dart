class AppConfig {
  // API Configuration
  // For Android Emulator: use 10.0.2.2 instead of localhost
  // For iOS Simulator: use localhost
  // For Real Device: use your computer's IP address
  static const String apiBaseUrl = 'https://10.0.2.2:7038/api';
  static const String imageBaseUrl = 'https://10.0.2.2:7038';
  
  // API Endpoints
  static const String authEndpoint = '/auth';
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/categories';
  static const String brandsEndpoint = '/brands';
  static const String cartEndpoint = '/cart';
  static const String ordersEndpoint = '/orders';
  static const String wishlistEndpoint = '/wishlist';
  static const String chatbotEndpoint = '/chatbot';
  
  // App Configuration
  static const String appName = 'PawVerse';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String tokenKey = 'jwt_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  
  // Helper methods
  /// Get full image URL from relative path
  static String getImageUrl(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) {
      return '';
    }
    
    // If already a full URL, return as is
    if (relativePath.startsWith('http')) {
      return relativePath;
    }
    
    // Remove leading slash if exists
    final cleanPath = relativePath.startsWith('/') 
        ? relativePath.substring(1) 
        : relativePath;
    
    // If path already includes 'Images/' or 'images/' (case insensitive), use as is
    // This handles both backend static files and database paths
    if (cleanPath.toLowerCase().startsWith('images/')) {
      // Path already has 'images/' prefix, use directly
      return '$imageBaseUrl/$cleanPath';
    }
    
    // Otherwise, prepend 'Images/' for backend static files
    final fullPath = 'Images/$cleanPath';
    
    return '$imageBaseUrl/$fullPath';
  }
}
