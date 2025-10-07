# Flutter Packages Reference - PawVerse Mobile

## 📦 Danh Sách Thư Viện Đề Xuất

### 🔹 **1. QUẢN LÝ TRẠNG THÁI (State Management)**

#### **Provider** ⭐ (Đang dùng)
```yaml
provider: ^6.1.1
```
- ✅ Đơn giản, dễ học
- ✅ Official Flutter recommendation
- ✅ Phù hợp cho app vừa và nhỏ
- 📚 [Documentation](https://pub.dev/packages/provider)

#### **Flutter_Bloc**
```yaml
flutter_bloc: ^8.1.3
```
- ⚡ Phức tạp hơn Provider
- ⚡ Tách biệt UI và Business Logic rõ ràng
- ⚡ Phù hợp cho app lớn, phức tạp
- 📚 [Documentation](https://pub.dev/packages/flutter_bloc)

#### **Riverpod**
```yaml
flutter_riverpod: ^2.4.9
```
- 🔥 Provider 2.0 (cải tiến)
- 🔥 Compile-time safety
- 🔥 Không cần BuildContext
- 📚 [Documentation](https://pub.dev/packages/flutter_riverpod)

---

### 🌐 **2. GIAO TIẾP MẠNG (Networking)**

#### **Dio** ⭐ (Đang dùng)
```yaml
dio: ^5.4.0
```
- ✅ HTTP client mạnh mẽ
- ✅ Interceptors, Retries, Timeout
- ✅ FormData, File Upload
- 📚 [Documentation](https://pub.dev/packages/dio)

#### **http**
```yaml
http: ^1.1.0
```
- 📦 HTTP client đơn giản
- 📦 Phù hợp cho request cơ bản
- 📚 [Documentation](https://pub.dev/packages/http)

---

### 💾 **3. LƯU TRỮ DỮ LIỆU (Data Storage)**

#### **Shared Preferences** ⭐ (Đang dùng)
```yaml
shared_preferences: ^2.2.2
```
- ✅ Key-value storage đơn giản
- ✅ Lưu settings, preferences
- 📚 [Documentation](https://pub.dev/packages/shared_preferences)

#### **Flutter Secure Storage** ⭐ (Đang dùng)
```yaml
flutter_secure_storage: ^9.0.0
```
- ✅ Encrypted storage
- ✅ Lưu JWT, sensitive data
- 📚 [Documentation](https://pub.dev/packages/flutter_secure_storage)

#### **Firebase**
```yaml
firebase_core: ^2.24.2
firebase_auth: ^4.15.3
cloud_firestore: ^4.13.6
firebase_storage: ^11.5.6
```
- 🔥 Backend-as-a-Service
- 🔥 Authentication, Database, Storage
- 📚 [Documentation](https://firebase.google.com/docs/flutter/setup)

#### **Hive**
```yaml
hive: ^2.2.3
hive_flutter: ^1.1.0
```
- ⚡ NoSQL database nhanh
- ⚡ Offline-first
- ⚡ Alternative cho SQLite
- 📚 [Documentation](https://pub.dev/packages/hive)

---

### 🖼️ **4. HIỂN THỊ VÀ XỬ LÝ ẢNH (Image Handling)**

#### **Cached Network Image** ⭐ (Đang dùng)
```yaml
cached_network_image: ^3.3.1
```
- ✅ Load ảnh từ URL với cache
- ✅ Placeholder, Error widget
- 📚 [Documentation](https://pub.dev/packages/cached_network_image)

#### **Image Picker**
```yaml
image_picker: ^1.0.5
```
- 📸 Chọn ảnh từ Gallery/Camera
- 📸 Phù hợp cho avatar, product images
- 📚 [Documentation](https://pub.dev/packages/image_picker)

---

### 🔔 **5. THÔNG BÁO VÀ QUYỀN (Notifications & Permissions)**

#### **Flutter Local Notifications**
```yaml
flutter_local_notifications: ^16.3.0
```
- 🔔 Push notifications locally
- 🔔 Schedule notifications
- 📚 [Documentation](https://pub.dev/packages/flutter_local_notifications)

#### **Permission Handler**
```yaml
permission_handler: ^11.1.0
```
- 🔐 Request permissions (Camera, Location, Storage)
- 🔐 Check permission status
- 📚 [Documentation](https://pub.dev/packages/permission_handler)

---

### 🔗 **6. TƯƠNG TÁC HỆ THỐNG (System Integration)**

#### **URL Launcher**
```yaml
url_launcher: ^6.2.2
```
- 🔗 Mở URL, phone, email
- 🔗 Open external apps
- 📚 [Documentation](https://pub.dev/packages/url_launcher)

#### **WebView Flutter**
```yaml
webview_flutter: ^4.4.2
```
- 🌐 Embed web pages trong app
- 🌐 Phù hợp cho Payment Gateway
- 📚 [Documentation](https://pub.dev/packages/webview_flutter)

#### **Connectivity Plus**
```yaml
connectivity_plus: ^5.0.2
```
- 📡 Check internet connection
- 📡 Listen to connectivity changes
- 📚 [Documentation](https://pub.dev/packages/connectivity_plus)

#### **Package Info Plus**
```yaml
package_info_plus: ^5.0.1
```
- 📦 Get app version, build number
- 📦 Package name, app name
- 📚 [Documentation](https://pub.dev/packages/package_info_plus)

---

### 📍 **7. ĐỊNH VỊ VÀ BẢN ĐỒ (Location & Maps)**

#### **Geolocator**
```yaml
geolocator: ^10.1.0
```
- 📍 Get current location
- 📍 Distance calculation
- 📚 [Documentation](https://pub.dev/packages/geolocator)

#### **Google Maps Flutter**
```yaml
google_maps_flutter: ^2.5.0
```
- 🗺️ Embed Google Maps
- 🗺️ Markers, Polylines, Polygons
- 📚 [Documentation](https://pub.dev/packages/google_maps_flutter)

---

### 🔐 **8. XÁC THỰC (Authentication)**

#### **Google Sign In** ⭐ (Đang dùng)
```yaml
google_sign_in: ^6.2.1
```
- ✅ Google OAuth 2.0
- ✅ Sign in with Google
- 📚 [Documentation](https://pub.dev/packages/google_sign_in)

#### **Sign In with Apple**
```yaml
sign_in_with_apple: ^5.0.0
```
- 🍎 Apple Sign In
- 🍎 Required for iOS apps
- 📚 [Documentation](https://pub.dev/packages/sign_in_with_apple)

#### **Flutter Facebook Auth**
```yaml
flutter_facebook_auth: ^6.0.3
```
- 👤 Facebook Login
- 📚 [Documentation](https://pub.dev/packages/flutter_facebook_auth)

---

### 💬 **9. FIREBASE CLOUD MESSAGING (FCM)**

#### **Firebase Messaging**
```yaml
firebase_messaging: ^14.7.6
```
- 📱 Push notifications từ server
- 📱 Background/Foreground notifications
- 📚 [Documentation](https://pub.dev/packages/firebase_messaging)

---

### 🎨 **10. UI/UX ENHANCEMENTS**

#### **Shimmer** ⭐ (Đang dùng)
```yaml
shimmer: ^3.0.0
```
- ✅ Loading skeleton effect
- ✅ Better UX than circular indicator
- 📚 [Documentation](https://pub.dev/packages/shimmer)

#### **Flutter Animate**
```yaml
flutter_animate: ^4.3.0
```
- ✨ Easy animations
- ✨ Fade, Slide, Scale effects
- 📚 [Documentation](https://pub.dev/packages/flutter_animate)

#### **Lottie**
```yaml
lottie: ^2.7.0
```
- 🎬 Animations from JSON files
- 🎬 [LottieFiles.com](https://lottiefiles.com/)
- 📚 [Documentation](https://pub.dev/packages/lottie)

---

### 🎥 **11. MEDIA HANDLING**

#### **Video Player**
```yaml
video_player: ^2.8.1
```
- 🎥 Play videos
- 🎥 Network & Local videos
- 📚 [Documentation](https://pub.dev/packages/video_player)

#### **Chewie**
```yaml
chewie: ^1.7.4
```
- 🎥 Video player với controls
- 🎥 Built on top of video_player
- 📚 [Documentation](https://pub.dev/packages/chewie)

---

### 📷 **12. QR/BARCODE SCANNING**

#### **Mobile Scanner**
```yaml
mobile_scanner: ^3.5.5
```
- 📷 QR Code & Barcode scanner
- 📷 Fast & modern
- 📚 [Documentation](https://pub.dev/packages/mobile_scanner)

---

## 🎯 **Packages Hiện Tại Trong PawVerse Mobile**

### **✅ Đã Cài Đặt:**

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Core Packages
  dio: ^5.4.0                         # HTTP client
  provider: ^6.1.1                    # State management
  shared_preferences: ^2.2.2          # Simple storage
  flutter_secure_storage: ^9.0.0      # Secure JWT storage
  go_router: ^14.0.0                  # Navigation
  cached_network_image: ^3.3.1        # Image caching
  json_annotation: ^4.8.1             # JSON serialization
  intl: ^0.19.0                       # Formatting
  
  # UI Enhancement
  shimmer: ^3.0.0                     # Loading skeleton
  fluttertoast: ^8.2.4                # Toast notifications
  
  # OAuth
  google_sign_in: ^6.2.1              # Google OAuth
  
  # Icons
  cupertino_icons: ^1.0.8
```

---

## 📊 **Đề Xuất Thêm (Future Enhancements)**

### **Nếu Cần Notification:**
```yaml
flutter_local_notifications: ^16.3.0
firebase_messaging: ^14.7.6
```

### **Nếu Cần Upload Ảnh:**
```yaml
image_picker: ^1.0.5
```

### **Nếu Cần Maps:**
```yaml
google_maps_flutter: ^2.5.0
geolocator: ^10.1.0
```

### **Nếu Cần QR Code:**
```yaml
mobile_scanner: ^3.5.5
qr_flutter: ^4.1.0  # Generate QR codes
```

### **Nếu Cần Animations:**
```yaml
flutter_animate: ^4.3.0
lottie: ^2.7.0
```

### **Nếu Cần Video:**
```yaml
video_player: ^2.8.1
chewie: ^1.7.4
```

---

## 🚀 **Best Practices**

### **1. Keep Packages Updated:**
```bash
flutter pub outdated
flutter pub upgrade
```

### **2. Minimize Dependencies:**
- Chỉ thêm packages thực sự cần thiết
- Kiểm tra package maintenance status

### **3. Check Compatibility:**
- Xem pub.dev score
- Check null-safety support
- Review issues/PRs on GitHub

### **4. Use Platform-Specific Packages Wisely:**
- Một số packages chỉ work trên iOS/Android
- Test trên cả hai platforms

---

## 📚 **Resources**

- **Pub.dev:** https://pub.dev/
- **Flutter Favorites:** https://pub.dev/packages?q=is%3Aflutter-favorite
- **Flutter Community:** https://flutter.dev/community

---

**📅 Last Updated:** October 7, 2025
**📱 Project:** PawVerse Mobile
**🏗️ Framework:** Flutter 3.9.2+
