import '../models/user.dart';
import '../services/api_service.dart';
import '../../config/app_config.dart';

class AuthRepository {
  final ApiService _api;

  AuthRepository(this._api);

  // Login with Email & Password
  Future<LoginResponse> login(String email, String password) async {
    final response = await _api.post(
      '${AppConfig.authEndpoint}/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    // Backend returns: { success: true, data: { token, user } }
    final data = response.data['data'];
    return LoginResponse.fromJson(data);
  }

  // Register
  Future<LoginResponse> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
    required String phoneNumber,
  }) async {
    final response = await _api.post(
      '${AppConfig.authEndpoint}/register',
      data: {
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
      },
    );

    final data = response.data['data'];
    return LoginResponse.fromJson(data);
  }

  // Login with Google
  Future<LoginResponse> loginWithGoogle(String idToken) async {
    final response = await _api.post(
      '${AppConfig.authEndpoint}/google-login',
      data: {
        'idToken': idToken,
      },
    );

    final data = response.data['data'];
    return LoginResponse.fromJson(data);
  }

  // Get Current User
  Future<User> getCurrentUser() async {
    final response = await _api.get('${AppConfig.authEndpoint}/me');
    
    final data = response.data['data'];
    return User.fromJson(data);
  }

  // Update Profile
  Future<User> updateProfile({
    required String fullName,
    required String phoneNumber,
    String? diaChi,
    String? gioiTinh,
    DateTime? ngaySinh,
  }) async {
    final response = await _api.put(
      '${AppConfig.authEndpoint}/profile',
      data: {
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        if (diaChi != null) 'diaChi': diaChi,
        if (gioiTinh != null) 'gioiTinh': gioiTinh,
        if (ngaySinh != null) 'ngaySinh': ngaySinh.toIso8601String(),
      },
    );

    final data = response.data['data'];
    return User.fromJson(data);
  }

  // Change Password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    await _api.put(
      '${AppConfig.authEndpoint}/change-password',
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      },
    );
  }

  // Refresh Token
  Future<String> refreshToken(String refreshToken) async {
    final response = await _api.post(
      '${AppConfig.authEndpoint}/refresh-token',
      data: {
        'refreshToken': refreshToken,
      },
    );

    return response.data['data']['token'];
  }
}
