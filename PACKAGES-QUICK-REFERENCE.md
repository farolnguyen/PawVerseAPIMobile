# Flutter Packages Quick Reference

## 📦 Bảng Tóm Tắt Thư Viện (Từ Hình)

| **Danh Mục** | **Package** | **Version** | **Mục Đích** | **Status** |
|--------------|-------------|-------------|--------------|------------|
| **Quản lý trạng thái** |
| | Provider | ^6.1.1 | State management đơn giản | ✅ Đang dùng |
| | Flutter_Bloc | ^8.1.3 | BLoC pattern | 📦 Đề xuất |
| | Riverpod | ^2.4.9 | Provider cải tiến | 📦 Đề xuất |
| **Giao tiếp mạng** |
| | http | ^1.1.0 | HTTP client cơ bản | 📦 Có thể dùng |
| | dio | ^5.4.0 | HTTP client mạnh | ✅ Đang dùng |
| **Lưu trữ dữ liệu** |
| | Shared Preferences | ^2.2.2 | Key-value storage | ✅ Đang dùng |
| | Firebase | ^2.24.2 | Backend service | 📦 Đề xuất |
| | Hive | ^2.2.3 | NoSQL database | 📦 Đề xuất |
| **Hiển thị ảnh** |
| | Cached Network Image | ^3.3.1 | Cache ảnh từ URL | ✅ Đang dùng |
| | Image Picker | ^1.0.5 | Chọn ảnh Camera/Gallery | 📦 Đề xuất |
| **Thông báo** |
| | Flutter Local Notifications | ^16.3.0 | Local notifications | 📦 Đề xuất |
| | Permission Handler | ^11.1.0 | Request permissions | 📦 Đề xuất |
| **Tương tác hệ thống** |
| | URL Launcher | ^6.2.2 | Mở URL/Phone/Email | 📦 Đề xuất |
| | WebView Flutter | ^4.4.2 | Embed web pages | 📦 Đề xuất |
| | Connectivity Plus | ^5.0.2 | Check internet | 📦 Đề xuất |
| | Package Info Plus | ^5.0.1 | App info/version | 📦 Đề xuất |
| **Định vị & Bản đồ** |
| | Geolocator | ^10.1.0 | Get location | 📦 Đề xuất |
| | Google Maps Flutter | ^2.5.0 | Google Maps | 📦 Đề xuất |
| **Xác thực** |
| | Google Sign In | ^6.2.1 | Google OAuth | ✅ Đang dùng |
| | Sign in Facebook/GG | - | Social login | 📦 Đề xuất |
| **Firebase Cloud Messaging** |
| | Firebase Messaging | ^14.7.6 | Push notifications | 📦 Đề xuất |
| | Onesignal/FCM | - | Push service | 📦 Đề xuất |
| **UI/UX** |
| | Flutter Animate | ^4.3.0 | Animations | 📦 Đề xuất |
| | Shimmer | ^3.0.0 | Loading skeleton | ✅ Đang dùng |
| **Media** |
| | Video Player | ^2.8.1 | Play videos | 📦 Đề xuất |
| **Scanning** |
| | Mobile Scanner | ^3.5.5 | QR/Barcode scanner | 📦 Đề xuất |

---

## ✅ **Packages Hiện Tại**

```yaml
# Đã cài đặt trong pubspec.yaml
dependencies:
  dio: ^5.4.0
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
  go_router: ^14.0.0
  cached_network_image: ^3.3.1
  json_annotation: ^4.8.1
  intl: ^0.19.0
  shimmer: ^3.0.0
  fluttertoast: ^8.2.4
  google_sign_in: ^6.2.1
  cupertino_icons: ^1.0.8
```

---

## 📊 **Top Recommendations**

### **Must Have:**
- ✅ `provider` - State management
- ✅ `dio` - HTTP client
- ✅ `shared_preferences` - Local storage
- ✅ `cached_network_image` - Image caching

### **Highly Recommended:**
- 📦 `image_picker` - Upload avatar/product images
- 📦 `connectivity_plus` - Check internet
- 📦 `url_launcher` - Open links/phone
- 📦 `flutter_local_notifications` - Notifications

### **Nice to Have:**
- 📦 `flutter_animate` - Smooth animations
- 📦 `geolocator` - Location services
- 📦 `mobile_scanner` - QR code scanning
- 📦 `firebase_messaging` - Push notifications

---

## 🎯 **Cách Thêm Package**

```bash
# 1. Thêm vào pubspec.yaml
dependencies:
  package_name: ^version

# 2. Install package
flutter pub get

# 3. Import vào code
import 'package:package_name/package_name.dart';
```

---

**📅 Updated:** Oct 7, 2025  
**📱 Project:** PawVerse Mobile
