// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  email: json['email'] as String,
  fullName: json['fullName'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  diaChi: json['diaChi'] as String?,
  gioiTinh: json['gioiTinh'] as String?,
  ngaySinh: json['ngaySinh'] == null
      ? null
      : DateTime.parse(json['ngaySinh'] as String),
  hinhAnh: json['hinhAnh'] as String?,
  roles: (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'fullName': instance.fullName,
  'phoneNumber': instance.phoneNumber,
  'diaChi': instance.diaChi,
  'gioiTinh': instance.gioiTinh,
  'ngaySinh': instance.ngaySinh?.toIso8601String(),
  'hinhAnh': instance.hinhAnh,
  'roles': instance.roles,
};

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
    };
