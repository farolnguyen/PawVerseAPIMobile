# 📊 Provider & Dio Usage Summary - PawVerse Mobile

**Last Updated:** October 7, 2025  
**Current Phase:** ✅ Phase 3 Completed - Products Catalog

---

## 📦 **PROVIDER (State Management) - 8 Files**

### **1. lib/main.dart** 
**Role:** 🌐 Global Provider Setup
```dart
import 'package:provider/provider.dart';  // ← PROVIDER package

// ✅ MultiProvider wraps toàn app để cung cấp state globally
return MultiProvider(
  providers: [
    // 4 providers được register:
    ChangeNotifierProvider(create: (_) => AuthProvider(...)),      // Authentication
    ChangeNotifierProvider(create: (_) => ProductProvider(...)),   // Products
    ChangeNotifierProvider(create: (_) => CartProvider(...)),      // Shopping Cart
    ChangeNotifierProvider(create: (_) => WishlistProvider(...)),  // Wishlist
  ],
  child: MaterialApp.router(...),
);
```
**Purpose:**
- Khởi tạo tất cả providers khi app start
- Providers available cho tất cả screens/widgets
- Tự động dispose khi app close

---

### **2. lib/presentation/screens/auth/login_screen.dart**
**Role:** 🔐 Login Screen
```dart
import 'package:provider/provider.dart';

// ✅ READ: Lấy provider để gọi methods (không rebuild UI)
final authProvider = context.read<AuthProvider>();
await authProvider.login(email, password);
```
**Provider Methods Used:**
- `context.read<AuthProvider>()` - Gọi login()
- `context.read<AuthProvider>()` - Gọi loginWithGoogle()

**Purpose:** Authenticate user và navigate to home

---

### **3. lib/presentation/screens/auth/register_screen.dart**
**Role:** 📝 Register Screen
```dart
import 'package:provider/provider.dart';

// ✅ READ: Đăng ký user mới
final authProvider = context.read<AuthProvider>();
await authProvider.register(
  email: email,
  password: password,
  fullName: fullName,
  phoneNumber: phoneNumber,
);
```
**Provider Methods Used:**
- `context.read<AuthProvider>()` - Gọi register()

**Purpose:** Tạo account mới và auto-login

---

### **4. lib/presentation/screens/profile/profile_screen.dart**
**Role:** 👤 Profile Screen
```dart
import 'package:provider/provider.dart';

// ✅ WATCH: Listen to user changes và rebuild UI
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    final user = authProvider.user;  // Lấy current user
    return Text(user?.hoTen ?? 'Guest');
  },
)

// ✅ READ: Logout
final authProvider = context.read<AuthProvider>();
await authProvider.logout();
```
**Provider Methods Used:**
- `Consumer<AuthProvider>` - Display user info
- `context.read<AuthProvider>()` - Gọi logout()

**Purpose:** Hiển thị và manage user profile

---

### **5. lib/presentation/screens/home/home_screen.dart**
**Role:** 🏠 Home Screen (Main Screen)
```dart
import 'package:provider/provider.dart';

// ✅ WATCH: Listen to multiple providers
Consumer<AuthProvider>(...)        // User greeting
Consumer<ProductProvider>(...)     // Products list
Consumer<CartProvider>(...)        // Cart badge count

// ✅ READ: Trigger actions
context.read<ProductProvider>().loadProducts(refresh: true);
context.read<CartProvider>().loadCart();
```
**Provider Methods Used:**
- `Consumer<AuthProvider>` - Display user name
- `Consumer<ProductProvider>` - Display products grid, categories
- `Consumer<CartProvider>` - Display cart item count badge
- `context.read<ProductProvider>()` - Load products, filter, sort

**Purpose:** Main app screen với products catalog

---

### **6. lib/presentation/screens/product/product_detail_screen.dart**
**Role:** 🛍️ Product Detail Screen
```dart
import 'package:provider/provider.dart';

// ✅ WATCH: Display product details
Consumer<ProductProvider>(
  builder: (context, productProvider, child) {
    final product = productProvider.selectedProduct;
    return ProductDetailWidget(product: product);
  },
)

// ✅ READ: Add to cart/wishlist
context.read<CartProvider>().addToCart(productId, quantity);
context.read<WishlistProvider>().toggleWishlist(productId);
```
**Provider Methods Used:**
- `Consumer<ProductProvider>` - Display product
- `Consumer<WishlistProvider>` - Wishlist button state
- `context.read<CartProvider>()` - Add to cart
- `context.read<WishlistProvider>()` - Toggle wishlist

**Purpose:** Chi tiết sản phẩm và actions

---

### **7. lib/presentation/screens/cart/cart_screen.dart**
**Role:** 🛒 Shopping Cart Screen
```dart
import 'package:provider/provider.dart';

// ✅ WATCH: Display cart items
Consumer<CartProvider>(
  builder: (context, cartProvider, child) {
    final cart = cartProvider.cart;
    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) => CartItemWidget(cart.items[index]),
    );
  },
)

// ✅ READ: Cart actions
context.read<CartProvider>().updateQuantity(itemId, newQuantity);
context.read<CartProvider>().removeItem(itemId);
context.read<CartProvider>().clearCart();
```
**Provider Methods Used:**
- `Consumer<CartProvider>` - Display cart items & total
- `context.read<CartProvider>()` - Update quantity, remove, clear

**Purpose:** Manage shopping cart

---

### **8. lib/presentation/widgets/product_card.dart**
**Role:** 🎴 Product Card Widget (Reusable)
```dart
import 'package:provider/provider.dart';

// ✅ WATCH: Wishlist button
Consumer<WishlistProvider>(
  builder: (context, wishlistProvider, child) {
    final isInWishlist = wishlistProvider.isInWishlist(product.idSanPham);
    return Icon(isInWishlist ? Icons.favorite : Icons.favorite_border);
  },
)

// ✅ READ: Add to cart
context.read<CartProvider>().addToCart(product.idSanPham, 1);
```
**Provider Methods Used:**
- `Consumer<WishlistProvider>` - Toggle wishlist icon
- `context.read<CartProvider>()` - Quick add to cart

**Purpose:** Reusable product card với wishlist & add to cart

---

## 🌐 **DIO (HTTP Client) - 1 File**

### **lib/data/services/api_service.dart**
**Role:** 🔌 API Service (Core HTTP Client)

```dart
import 'package:dio/dio.dart';        // Main Dio package
import 'package:dio/io.dart';         // For IOHttpClientAdapter
import 'dart:io';                     // For HttpClient, X509Certificate

class ApiService {
  final Dio _dio;                     // ← DIO instance
  final StorageService _storageService;

  ApiService(this._storageService) : _dio = Dio() {
    _setupDio();
  }

  void _setupDio() {
    // ✅ 1. BASE OPTIONS (Dio configuration)
    _dio.options = BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,           // https://10.0.2.2:7038/api
      connectTimeout: Duration(seconds: 30),   // Connection timeout
      receiveTimeout: Duration(seconds: 30),   // Response timeout
      contentType: Headers.jsonContentType,    // JSON
      responseType: ResponseType.json,         // Auto parse JSON
    );

    // ✅ 2. SSL BYPASS (Development only)
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        // ⚠️ Allow self-signed certificates
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );

    // ✅ 3. INTERCEPTORS (Middleware)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,      // Before request → Add JWT token
        onResponse: _onResponse,    // After response → Handle success
        onError: _onError,          // On error → Handle errors
      ),
    );

    // ✅ 4. LOGGING (Development)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (log) => print('[DIO] $log'),
      ),
    );
  }

  // ✅ REQUEST INTERCEPTOR: Auto-attach JWT token
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storageService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  // ✅ RESPONSE INTERCEPTOR: Handle success
  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // Log successful responses
    print('[API Success] ${response.requestOptions.path}');
    handler.next(response);
  }

  // ✅ ERROR INTERCEPTOR: Handle errors
  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized → Maybe refresh token
    if (error.response?.statusCode == 401) {
      // Token expired → Logout or refresh
      await _storageService.deleteToken();
    }
    
    // Throw custom exception
    handler.reject(error);
  }

  // ✅ HTTP METHODS
  Future<Response> get(String endpoint) async {
    return await _dio.get(endpoint);
  }

  Future<Response> post(String endpoint, dynamic data) async {
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> put(String endpoint, dynamic data) async {
    return await _dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint) async {
    return await _dio.delete(endpoint);
  }
}
```

### **Dio Features Used:**

| Feature | Purpose | Location |
|---------|---------|----------|
| **BaseOptions** | Base URL, timeouts, headers | Line 18-24 |
| **IOHttpClientAdapter** | SSL bypass for dev | Line 28-35 |
| **InterceptorsWrapper** | JWT token, logging | Line 38-44 |
| **LogInterceptor** | Debug API calls | Line 47-52 |
| **Auto JWT Injection** | Add Bearer token to all requests | `_onRequest` |
| **Error Handling** | Handle 401, network errors | `_onError` |
| **JSON Parsing** | Auto parse responses | BaseOptions |

### **ApiService được dùng trong:**
- `lib/data/repositories/auth_repository.dart` → Login, Register
- `lib/data/repositories/product_repository.dart` → Get products
- `lib/data/repositories/cart_repository.dart` → Cart CRUD
- `lib/data/repositories/order_repository.dart` → Orders
- `lib/data/repositories/wishlist_repository.dart` → Wishlist

---

## 🎯 **PROVIDER vs DIO - Khi Nào Dùng Gì?**

### **PROVIDER (State Management):**
**Dùng Khi:**
- ✅ Cần share data giữa nhiều widgets
- ✅ UI cần rebuild khi data thay đổi
- ✅ Manage app state (auth, cart, wishlist)

**Syntax:**
```dart
// READ (không rebuild)
context.read<AuthProvider>().login();

// WATCH (rebuild khi thay đổi)
final cart = context.watch<CartProvider>().cart;

// CONSUMER (rebuild only widget trong builder)
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    return Text(authProvider.user?.name ?? '');
  },
)
```

---

### **DIO (HTTP Client):**
**Dùng Khi:**
- ✅ Gọi API (GET, POST, PUT, DELETE)
- ✅ Cần JWT authentication
- ✅ Upload files
- ✅ Handle network errors

**Syntax:**
```dart
// GET request
final response = await apiService.get('/products');
final products = response.data;

// POST request
final response = await apiService.post('/auth/login', {
  'email': 'test@test.com',
  'password': '123456',
});

// With JWT token (auto-attached)
final response = await apiService.get('/cart');  // Bearer token added automatically
```

---

## 📊 **Current Architecture Flow:**

```
┌─────────────────────────────────────────────────────┐
│                    UI Layer                         │
│  (Screens & Widgets)                                │
│  ├── login_screen.dart                              │
│  ├── home_screen.dart                               │
│  └── cart_screen.dart                               │
└─────────────────┬───────────────────────────────────┘
                  │ context.read/watch
                  ↓
┌─────────────────────────────────────────────────────┐
│              State Management                        │
│  (Provider - 4 providers)                           │
│  ├── AuthProvider      → User, Login, Logout        │
│  ├── ProductProvider   → Products, Filters, Search  │
│  ├── CartProvider      → Cart items, Total          │
│  └── WishlistProvider  → Wishlist items             │
└─────────────────┬───────────────────────────────────┘
                  │ calls repository methods
                  ↓
┌─────────────────────────────────────────────────────┐
│              Repositories                            │
│  (Business Logic)                                   │
│  ├── AuthRepository                                 │
│  ├── ProductRepository                              │
│  ├── CartRepository                                 │
│  └── WishlistRepository                             │
└─────────────────┬───────────────────────────────────┘
                  │ uses
                  ↓
┌─────────────────────────────────────────────────────┐
│              ApiService (Dio)                        │
│  ├── Base URL: https://10.0.2.2:7038/api           │
│  ├── Auto JWT injection                             │
│  ├── Error handling                                 │
│  └── JSON parsing                                   │
└─────────────────┬───────────────────────────────────┘
                  │ HTTP requests
                  ↓
┌─────────────────────────────────────────────────────┐
│           Backend API (PawVerseAPI)                 │
│  └── https://localhost:7038/api                     │
└─────────────────────────────────────────────────────┘
```

---

## ✅ **CURRENT PROGRESS:**

### **✅ Phase 1: Foundation (Week 1) - COMPLETED**
- [x] Package installation (11 packages)
- [x] API Service with Dio setup
- [x] Models & Repositories
- [x] JWT token handling
- [x] Error handling

### **✅ Phase 2: Authentication (Week 2) - COMPLETED**
- [x] Login screen với Provider
- [x] Register screen
- [x] Profile screen
- [x] AuthProvider with login/logout
- [x] Protected routes

### **✅ Phase 3: Products Catalog (Week 2-3) - COMPLETED**
- [x] Home screen với products grid
- [x] ProductProvider với filters
- [x] Product detail screen
- [x] Cart screen với CartProvider
- [x] Product card widget
- [x] WishlistProvider

### **🔜 NEXT PHASE:**

### **Phase 4: Orders & Checkout (Week 3-4)**
- [ ] Checkout screen
- [ ] Order placement
- [ ] Orders list
- [ ] Order detail
- [ ] OrderProvider

---

## 📝 **Best Practices Đã Áp Dụng:**

### **Provider:**
- ✅ Sử dụng `MultiProvider` ở root level
- ✅ `context.read()` cho actions (không rebuild)
- ✅ `Consumer<T>` cho listening (rebuild specific widget)
- ✅ `ChangeNotifier` cho providers
- ✅ `notifyListeners()` sau mỗi state change

### **Dio:**
- ✅ Single `ApiService` instance
- ✅ Base URL configuration
- ✅ JWT auto-injection via interceptors
- ✅ Error handling với custom exceptions
- ✅ Logging cho development
- ✅ SSL bypass cho local development

---

## 🎯 **Summary:**

**Provider:**
- **8 files** đang sử dụng
- **4 providers** active: Auth, Product, Cart, Wishlist
- **Main use cases:** Login, Product display, Cart management, Wishlist

**Dio:**
- **1 core file** (`api_service.dart`)
- **Used by 5 repositories**
- **Main features:** HTTP client, JWT auth, Interceptors, Error handling

**Current Status:** ✅ **Phase 3 COMPLETED** → Ready for Phase 4: Orders & Checkout

---

**📅 Last Updated:** October 7, 2025  
**📱 Project:** PawVerse Mobile  
**🏗️ Framework:** Flutter 3.9.2+
