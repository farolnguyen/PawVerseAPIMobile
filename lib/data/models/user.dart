import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final String? diaChi;
  final String? gioiTinh;
  final DateTime? ngaySinh;
  final String? hinhAnh;
  final List<String>? roles;

  User({
    required this.id,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.diaChi,
    this.gioiTinh,
    this.ngaySinh,
    this.hinhAnh,
    this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // Helper methods
  bool get isAdmin => roles?.contains('Admin') ?? false;
  
  String get displayName => fullName ?? email;
  
  String get initials {
    if (fullName != null && fullName!.isNotEmpty) {
      final parts = fullName!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
      }
      return fullName![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }
}

@JsonSerializable()
class LoginResponse {
  final String token;
  final String? refreshToken;
  final User user;

  LoginResponse({
    required this.token,
    this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => 
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
