import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // 📦 STATE MANAGEMENT: Provider package cho state management toàn app
import 'dart:io';
import 'config/app_config.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'data/services/api_service.dart';
import 'data/services/storage_service.dart';
import 'data/services/auth_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/product_repository.dart';
import 'data/repositories/cart_repository.dart';
import 'data/repositories/wishlist_repository.dart';
import 'data/repositories/order_repository.dart';
import 'data/repositories/chatbot_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/order_provider.dart';
import 'providers/chatbot_provider.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ⚠️ DEVELOPMENT ONLY: Bypass SSL certificate for images
  // This allows Image.network() to load images from self-signed HTTPS
  // REMOVE THIS IN PRODUCTION!
  HttpOverrides.global = DevHttpOverrides();
  
  // Initialize services
  final storageService = StorageService();
  await storageService.init();
  
  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  
  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    // Initialize services and repositories
    final apiService = ApiService(storageService);
    final authRepository = AuthRepository(apiService);
    final authService = AuthService(authRepository);
    final productRepository = ProductRepository(apiService);
    final cartRepository = CartRepository(apiService);
    final wishlistRepository = WishlistRepository(apiService);
    final orderRepository = OrderRepository(apiService);
    final chatbotRepository = ChatbotRepository(http.Client());

    // ✅ PROVIDER: MultiProvider wrap toàn app để cung cấp state cho tất cả screens
    return MultiProvider(
      providers: [
        // Auth Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authRepository,
            storageService,
            authService,
          )..checkAuth(), // Check auth on app start
        ),
        
        // Product Provider
        ChangeNotifierProvider(
          create: (_) => ProductProvider(productRepository),
        ),
        
        // Cart Provider
        ChangeNotifierProvider(
          create: (_) => CartProvider(cartRepository),
        ),
        
        // Wishlist Provider
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(wishlistRepository),
        ),
        
        // Order Provider
        ChangeNotifierProvider(
          create: (_) => OrderProvider(orderRepository),
        ),
        
        // Chatbot Provider
        ChangeNotifierProvider(
          create: (_) => ChatbotProvider(chatbotRepository),
        ),
      ],
      child: MaterialApp.router(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

/// ⚠️ DEVELOPMENT ONLY: Custom HttpOverrides to bypass SSL certificate verification
/// This allows Image.network() to load images from self-signed HTTPS servers
/// REMOVE THIS IN PRODUCTION!
class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true; // Accept all certificates in development
      };
  }
}
