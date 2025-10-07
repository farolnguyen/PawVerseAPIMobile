import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // 📦 STATE MANAGEMENT: Provider package cho state management toàn app
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
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
