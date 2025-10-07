# 📚 Provider & Dio - Giải Thích Chi Tiết Code

**Tài liệu kỹ thuật về State Management (Provider) và HTTP Client (Dio) trong PawVerse Mobile**

---

## 📦 **PHẦN I: PROVIDER - State Management**

### **1. Provider Là Gì?**

Provider là package quản lý state trong Flutter, giúp:
- ✅ Chia sẻ data giữa nhiều widgets
- ✅ Tự động rebuild UI khi data thay đổi
- ✅ Quản lý vòng đời state tự động

---

### **2. Các Cách Sử Dụng Provider**

#### **A. context.read<T>() - Không Rebuild**
**Dùng khi:** Gọi methods/actions

```dart
// ✅ Gọi login (không rebuild widget)
final authProvider = context.read<AuthProvider>();
await authProvider.login(email, password);
```

**Ví dụ trong dự án:**
```dart
// lib/presentation/screens/auth/login_screen.dart
Future<void> _handleLogin() async {
  // Lấy AuthProvider để gọi login
  final authProvider = context.read<AuthProvider>();
  
  try {
    await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    
    if (mounted) {
      context.go('/home'); // Navigate sau khi login thành công
    }
  } catch (e) {
    // Hiển thị lỗi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}
```

---

#### **B. Consumer<T> - Rebuild Có Chọn Lọc**
**Dùng khi:** Cần hiển thị data và tối ưu performance

```dart
// ✅ Chỉ rebuild widget bên trong builder
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    final user = authProvider.user;
    return Text(user?.hoTen ?? 'Guest');
  },
)
```

**Ví dụ trong dự án:**
```dart
// lib/presentation/screens/profile/profile_screen.dart

// Hiển thị thông tin user
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    final user = authProvider.user;
    
    if (user == null) {
      return Text('Chưa đăng nhập');
    }
    
    return Column(
      children: [
        CircleAvatar(
          child: Text(user.initials), // VD: "NA" từ "Nguyen A"
        ),
        Text(user.hoTen),
        Text(user.email),
        Text('SĐT: ${user.soDienThoai ?? "Chưa có"}'),
      ],
    );
  },
)
```

**Giải thích:**
- Khi `authProvider.user` thay đổi → Consumer tự động rebuild
- Widget bên ngoài Consumer KHÔNG rebuild (tiết kiệm performance)

---

#### **C. MultiProvider - Setup Nhiều Providers**
**Dùng khi:** Khởi tạo providers ở root app

```dart
// lib/main.dart
MultiProvider(
  providers: [
    // 4 providers cho toàn app
    ChangeNotifierProvider(create: (_) => AuthProvider(...)),
    ChangeNotifierProvider(create: (_) => ProductProvider(...)),
    ChangeNotifierProvider(create: (_) => CartProvider(...)),
    ChangeNotifierProvider(create: (_) => WishlistProvider(...)),
  ],
  child: MaterialApp.router(...),
)
```

**Giải thích:**
- `MultiProvider`: Cung cấp nhiều providers cùng lúc
- `ChangeNotifierProvider`: Tạo provider từ class extends `ChangeNotifier`
- `create: (_) => ...`: Hàm khởi tạo provider (chỉ chạy 1 lần)

---

### **3. Ví Dụ Thực Tế Trong Dự Án**

#### **Ví Dụ 1: Cart Badge - Hiển Thị Số Lượng Items**

```dart
// lib/presentation/screens/home/home_screen.dart

AppBar(
  actions: [
    // Consumer lắng nghe CartProvider
    Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final itemCount = cartProvider.itemCount;
        
        return Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () => context.push('/cart'),
            ),
            // Badge hiển thị số lượng
            if (itemCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    itemCount.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    ),
  ],
)
```

**Flow hoạt động:**
1. User add product to cart
2. `CartProvider.itemCount` thay đổi (từ 0 → 1)
3. Consumer tự động rebuild
4. Badge hiển thị số 1

---

#### **Ví Dụ 2: Wishlist Icon - Toggle Yêu Thích**

```dart
// lib/presentation/widgets/product_card.dart

Consumer<WishlistProvider>(
  builder: (context, wishlistProvider, child) {
    // Kiểm tra product có trong wishlist không
    final isInWishlist = wishlistProvider.isInWishlist(product.idSanPham);
    
    return IconButton(
      icon: Icon(
        isInWishlist ? Icons.favorite : Icons.favorite_border,
        color: isInWishlist ? Colors.red : Colors.grey,
      ),
      onPressed: () async {
        // Toggle wishlist
        await wishlistProvider.toggleWishlist(product.idSanPham);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isInWishlist ? 'Đã xóa khỏi yêu thích' : 'Đã thêm vào yêu thích'
            ),
          ),
        );
      },
    );
  },
)
```

**Flow hoạt động:**
1. User click heart icon
2. `wishlistProvider.toggleWishlist()` được gọi
3. WishlistProvider update state (add/remove product)
4. Consumer tự động rebuild icon (đổi từ outline → filled hoặc ngược lại)

---

#### **Ví Dụ 3: Cart Screen - Quản Lý Giỏ Hàng**

```dart
// lib/presentation/screens/cart/cart_screen.dart

Consumer<CartProvider>(
  builder: (context, cartProvider, child) {
    // Loading state
    if (cartProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    // Empty state
    if (cartProvider.cart.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.shopping_cart, size: 100),
            Text('Giỏ hàng trống'),
          ],
        ),
      );
    }
    
    // Data state
    return Column(
      children: [
        // List items
        ListView.builder(
          itemCount: cartProvider.cart.items.length,
          itemBuilder: (context, index) {
            final item = cartProvider.cart.items[index];
            
            return ListTile(
              title: Text(item.tenSanPham),
              subtitle: Text('${item.giaHienThi} ₫'),
              trailing: Row(
                children: [
                  // Decrease quantity
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      cartProvider.updateQuantity(item.id, item.soLuong - 1);
                    },
                  ),
                  Text(item.soLuong.toString()),
                  // Increase quantity
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      cartProvider.updateQuantity(item.id, item.soLuong + 1);
                    },
                  ),
                ],
              ),
            );
          },
        ),
        
        // Total
        Text('Tổng: ${cartProvider.cart.tongTien} ₫'),
      ],
    );
  },
)
```

**Flow hoạt động:**
1. CartScreen mở → `cartProvider.loadCart()` được gọi
2. Consumer rebuild 3 lần:
   - Lần 1: `isLoading = true` → Hiển thị loading
   - Lần 2: `isLoading = false`, `cart.items = []` → Hiển thị empty
   - Lần 3: `cart.items = [...]` → Hiển thị list
3. User click +/- → `updateQuantity()` → Consumer rebuild list

---

### **4. Tổng Kết Provider**

| Method | Rebuild | Khi Nào Dùng | Ví Dụ |
|--------|---------|--------------|-------|
| **context.read<T>()** | ❌ Không | Gọi actions | Login, Logout, Add to cart |
| **Consumer<T>** | ✅ Có (chỉ widget con) | Hiển thị data | User info, Cart badge, Product list |
| **context.watch<T>()** | ✅ Có (toàn widget) | Simple cases | Ít dùng trong dự án này |

---

## 🌐 **PHẦN II: DIO - HTTP Client**

### **1. Dio Là Gì?**

Dio là HTTP client mạnh mẽ cho Flutter, có nhiều features hơn package `http` built-in:
- ✅ Interceptors (middleware)
- ✅ Auto attach JWT token
- ✅ Timeout configuration
- ✅ Error handling tập trung
- ✅ Logging

---

### **2. Cấu Trúc Dio Trong Dự Án**

```dart
// lib/data/services/api_service.dart

class ApiService {
  final Dio _dio;
  final StorageService _storageService;

  ApiService(this._storageService) : _dio = Dio() {
    _setupDio(); // Setup configuration
  }

  void _setupDio() {
    // 1. Base configuration
    _dio.options = BaseOptions(
      baseUrl: 'https://10.0.2.2:7038/api',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

    // 2. SSL bypass (Development only)
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );

    // 3. Interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }
}
```

---

### **3. Interceptors - Middleware**

#### **A. onRequest - Chạy Trước Mỗi Request**

```dart
Future<void> _onRequest(
  RequestOptions options,
  RequestInterceptorHandler handler,
) async {
  print('[API] ${options.method} ${options.path}');
  
  // Lấy JWT token từ storage
  final token = await _storageService.getToken();
  
  // Tự động thêm token vào header
  if (token != null) {
    options.headers['Authorization'] = 'Bearer $token';
  }
  
  // Tiếp tục request
  handler.next(options);
}
```

**Giải thích:**
- Mỗi request đều chạy qua đây trước
- Tự động attach JWT token nếu có
- Không cần manually thêm token ở mỗi API call

---

#### **B. onResponse - Chạy Sau Mỗi Response**

```dart
void _onResponse(
  Response response,
  ResponseInterceptorHandler handler,
) {
  print('[API Success] ${response.statusCode}');
  
  // Log response data (debugging)
  if (response.data != null) {
    print('[API Data] ${response.data}');
  }
  
  handler.next(response);
}
```

**Giải thích:**
- Chạy sau mỗi response thành công
- Log data để debug
- Có thể transform data ở đây nếu cần

---

#### **C. onError - Chạy Khi Có Lỗi**

```dart
Future<void> _onError(
  DioException error,
  ErrorInterceptorHandler handler,
) async {
  print('[API Error] ${error.message}');
  
  // Xử lý lỗi 401 Unauthorized
  if (error.response?.statusCode == 401) {
    print('[API] Token expired');
    await _storageService.deleteToken();
    // Navigate to login
  }
  
  // Xử lý lỗi timeout
  if (error.type == DioExceptionType.connectionTimeout) {
    print('[API] Connection timeout');
  }
  
  handler.reject(error);
}
```

**Giải thích:**
- Xử lý lỗi tập trung
- Tự động logout khi token expired (401)
- Handle timeout, network errors

---

### **4. HTTP Methods**

```dart
// GET request
Future<Response> get(String endpoint) async {
  return await _dio.get(endpoint);
}

// POST request
Future<Response> post(String endpoint, dynamic data) async {
  return await _dio.post(endpoint, data: data);
}

// PUT request
Future<Response> put(String endpoint, dynamic data) async {
  return await _dio.put(endpoint, data: data);
}

// DELETE request
Future<Response> delete(String endpoint) async {
  return await _dio.delete(endpoint);
}
```

---

### **5. Ví Dụ Sử Dụng Trong Repository**

#### **Ví Dụ 1: Login**

```dart
// lib/data/repositories/auth_repository.dart

class AuthRepository {
  final ApiService _apiService;

  Future<LoginResponse> login(String email, String password) async {
    try {
      // Gọi POST /auth/login
      final response = await _apiService.post(
        '/auth/login',
        {
          'email': email,
          'password': password,
        },
      );
      
      // Parse response
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
```

**Flow:**
```
1. AuthRepository.login()
   ↓
2. ApiService.post('/auth/login', data)
   ↓
3. Interceptor.onRequest → (không có token vì chưa login)
   ↓
4. HTTP POST https://10.0.2.2:7038/api/auth/login
   ↓
5. Response success → Interceptor.onResponse
   ↓
6. Return LoginResponse với token
   ↓
7. AuthProvider lưu token vào storage
```

---

#### **Ví Dụ 2: Get Products (Có Token)**

```dart
// lib/data/repositories/product_repository.dart

class ProductRepository {
  final ApiService _apiService;

  Future<List<Product>> getProducts() async {
    try {
      // Gọi GET /products
      final response = await _apiService.get('/products');
      
      // Parse list
      final List<dynamic> data = response.data['items'];
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Get products failed: $e');
    }
  }
}
```

**Flow:**
```
1. ProductRepository.getProducts()
   ↓
2. ApiService.get('/products')
   ↓
3. Interceptor.onRequest → Tự động thêm: Authorization: Bearer <token>
   ↓
4. HTTP GET https://10.0.2.2:7038/api/products
   ↓
5. Response success → Interceptor.onResponse
   ↓
6. Return List<Product>
```

---

#### **Ví Dụ 3: Add to Cart (Có Token)**

```dart
// lib/data/repositories/cart_repository.dart

class CartRepository {
  final ApiService _apiService;

  Future<Cart> addToCart(int productId, int quantity) async {
    try {
      // Gọi POST /cart/add
      final response = await _apiService.post(
        '/cart/add',
        {
          'productId': productId,
          'quantity': quantity,
        },
      );
      
      // Return updated cart
      return Cart.fromJson(response.data);
    } catch (e) {
      throw Exception('Add to cart failed: $e');
    }
  }
}
```

**Flow:**
```
1. CartProvider.addToCart(productId, quantity)
   ↓
2. CartRepository.addToCart()
   ↓
3. ApiService.post('/cart/add', data)
   ↓
4. Interceptor.onRequest → Tự động thêm token
   ↓
5. HTTP POST https://10.0.2.2:7038/api/cart/add
   ↓
6. Response success → Return Cart
   ↓
7. CartProvider update state
   ↓
8. Consumer<CartProvider> tự động rebuild UI
```

---

### **6. SSL Bypass (Development Only)**

```dart
_dio.httpClientAdapter = IOHttpClientAdapter(
  createHttpClient: () {
    final client = HttpClient();
    // Chấp nhận tất cả SSL certificates
    client.badCertificateCallback = (cert, host, port) => true;
    return client;
  },
);
```

**Giải thích:**
- Development backend dùng self-signed certificate
- Flutter mặc định reject certificate không hợp lệ
- `badCertificateCallback = true` → Bypass validation
- ⚠️ **CHỈ DÙNG CHO DEVELOPMENT! REMOVE KHI PRODUCTION!**

---

### **7. Tổng Kết Dio**

**Features Đang Dùng:**
- ✅ Base URL configuration
- ✅ JWT auto-injection via interceptor
- ✅ Error handling (401, timeout)
- ✅ SSL bypass cho development
- ✅ Logging để debug

**Lợi Ích:**
- Không cần manually thêm token ở mỗi request
- Error handling tập trung
- Code clean hơn
- Dễ maintain

---

## 🎯 **TỔNG KẾT**

### **Provider trong Dự Án:**
- **8 files** đang dùng Provider
- **4 providers**: Auth, Product, Cart, Wishlist
- **Patterns:** `context.read()` cho actions, `Consumer` cho UI

### **Dio trong Dự Án:**
- **1 file core:** `api_service.dart`
- **5 repositories** sử dụng: Auth, Product, Cart, Order, Wishlist
- **Features:** Interceptors, JWT auto-injection, Error handling

**Architecture Flow:**
```
UI (Screens)
  ↓ context.read/Consumer
Provider (State Management)
  ↓ calls repository
Repository (Business Logic)
  ↓ uses apiService
ApiService (Dio HTTP Client)
  ↓ interceptors + JWT
Backend API
```

---

**📅 Created:** October 7, 2025  
**📱 Project:** PawVerse Mobile  
**🎯 Purpose:** Technical documentation for code understanding
