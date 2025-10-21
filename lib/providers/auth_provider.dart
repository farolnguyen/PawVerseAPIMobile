import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../data/models/user.dart';
import '../data/repositories/auth_repository.dart';
import '../data/services/storage_service.dart';
import '../data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final StorageService _storageService;
  final AuthService _authService;

  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(
    this._authRepository,
    this._storageService,
    this._authService,
  );

  // Getters
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Login with Email & Password
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authRepository.login(email, password);
      
      _user = response.user;
      await _storageService.saveToken(response.token);
      
      if (response.refreshToken != null) {
        await _storageService.saveRefreshToken(response.refreshToken!);
      }
      
      // Save user data
      await _storageService.saveUserData(jsonEncode(_user!.toJson()));
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register
  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
    required String phoneNumber,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authRepository.register(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );
      
      _user = response.user;
      await _storageService.saveToken(response.token);
      
      if (response.refreshToken != null) {
        await _storageService.saveRefreshToken(response.refreshToken!);
      }
      
      // Save user data
      await _storageService.saveUserData(jsonEncode(_user!.toJson()));
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login with Google
  Future<void> loginWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Use AuthService to handle Google Sign In
      final response = await _authService.loginWithGoogle();
      
      _user = response.user;
      await _storageService.saveToken(response.token);
      
      if (response.refreshToken != null) {
        await _storageService.saveRefreshToken(response.refreshToken!);
      }
      
      // Save user data
      await _storageService.saveUserData(jsonEncode(_user!.toJson()));
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Sign out from Google if signed in
      await _authService.signOutGoogle();
      
      await _storageService.deleteToken();
      await _storageService.deleteRefreshToken();
      await _storageService.deleteUserData();
      
      _user = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Check if user is logged in (auto-login)
  Future<void> checkAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _storageService.getToken();
      
      if (token != null && token.isNotEmpty) {
        // Try to get current user from API
        try {
          _user = await _authRepository.getCurrentUser();
          
          // Update stored user data
          await _storageService.saveUserData(jsonEncode(_user!.toJson()));
        } catch (e) {
          // Token might be expired, try to load from storage
          final userData = _storageService.getUserData();
          if (userData != null) {
            _user = User.fromJson(jsonDecode(userData));
          } else {
            // Clear invalid token
            await _storageService.deleteToken();
            await _storageService.deleteRefreshToken();
            _user = null;
          }
        }
      } else {
        _user = null;
      }
    } catch (e) {
      _error = e.toString();
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update Profile
  Future<void> updateProfile({
    required String fullName,
    required String phoneNumber,
    String? diaChi,
    String? gioiTinh,
    DateTime? ngaySinh,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedUser = await _authRepository.updateProfile(
        fullName: fullName,
        phoneNumber: phoneNumber,
        diaChi: diaChi,
        gioiTinh: gioiTinh,
        ngaySinh: ngaySinh,
      );
      
      _user = updatedUser;
      
      // Update stored user data
      await _storageService.saveUserData(jsonEncode(_user!.toJson()));
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Upload Avatar
  Future<void> uploadAvatar(File imageFile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Upload image to backend
      await _authRepository.uploadAvatar(imageFile);
      
      // Reload user data from backend to get updated avatar
      final updatedUser = await _authRepository.getCurrentUser();
      _user = updatedUser;
      
      // Update stored user data
      await _storageService.saveUserData(jsonEncode(_user!.toJson()));
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Change Password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Forgot Password
  Future<void> forgotPassword({
    required String email,
    required String phoneNumber,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.forgotPassword(
        email: email,
        phoneNumber: phoneNumber,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset Password
  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.resetPassword(
        email: email,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear Error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
