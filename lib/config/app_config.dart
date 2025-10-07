class AppConfig {
  // API Configuration
  // For Android Emulator: use 10.0.2.2 instead of localhost
  // For iOS Simulator: use localhost
  // For Real Device: use your computer's IP address
  static const String apiBaseUrl = 'https://10.0.2.2:7038/api';
  
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
}
