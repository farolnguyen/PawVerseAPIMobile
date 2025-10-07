import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/product/product_detail_screen.dart';
import '../presentation/screens/cart/cart_screen.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main Routes
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      // Product Routes
      GoRoute(
        path: '/product-detail',
        name: 'product-detail',
        builder: (context, state) {
          final productId = state.extra as int;
          return ProductDetailScreen(productId: productId);
        },
      ),
      
      // Cart Route
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      
      // Profile Routes
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      
      // Search Route (placeholder)
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Search Screen - Coming Soon'),
          ),
        ),
      ),
    ],
    
    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
