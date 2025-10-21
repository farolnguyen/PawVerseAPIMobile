import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/auth/forgot_password_screen.dart';
import '../presentation/screens/auth/reset_password_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/main/main_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/profile/edit_profile_screen.dart';
import '../presentation/screens/profile/change_password_screen.dart';
import '../presentation/screens/product/product_detail_screen.dart';
import '../presentation/screens/cart/cart_screen.dart';
import '../presentation/screens/wishlist/wishlist_screen.dart';
import '../presentation/screens/checkout/checkout_screen.dart';
import '../presentation/screens/orders/orders_screen.dart';
import '../presentation/screens/orders/order_detail_screen.dart';
import '../presentation/screens/search/search_screen.dart';
import '../presentation/screens/categories/categories_screen.dart';
import '../presentation/screens/categories/category_products_screen.dart';
import '../presentation/screens/chatbot/chatbot_screen.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // Root Route - Redirect to home
      GoRoute(
        path: '/',
        redirect: (context, state) => '/home',
      ),
      
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
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder: (context, state) {
          final email = state.extra as String;
          return ResetPasswordScreen(email: email);
        },
      ),
      
      // Main Routes
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) {
          // Get optional index parameter (default to 0)
          final index = state.uri.queryParameters['index'];
          return MainScreen(
            initialIndex: index != null ? int.tryParse(index) ?? 0 : 0,
          );
        },
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
      
      // Wishlist Route
      GoRoute(
        path: '/wishlist',
        name: 'wishlist',
        builder: (context, state) => const WishlistScreen(),
      ),
      
      // Checkout Route
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      
      // Orders Routes
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/orders/:id',
        name: 'order-detail',
        builder: (context, state) {
          final orderId = state.pathParameters['id']!;
          return OrderDetailScreen(orderId: orderId);
        },
      ),
      
      // Profile Routes
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/change-password',
        name: 'change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      
      // Search Route
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      
      // Categories Routes
      GoRoute(
        path: '/categories',
        name: 'categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/categories/:id',
        name: 'category-products',
        builder: (context, state) {
          final categoryId = state.pathParameters['id']!;
          return CategoryProductsScreen(categoryId: categoryId);
        },
      ),
      
      // Chatbot Route
      GoRoute(
        path: '/chatbot',
        name: 'chatbot',
        builder: (context, state) => const ChatbotScreen(),
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
