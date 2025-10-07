// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistItem _$WishlistItemFromJson(Map<String, dynamic> json) => WishlistItem(
  idYeuThich: (json['idYeuThich'] as num).toInt(),
  idSanPham: (json['idSanPham'] as num).toInt(),
  tenSanPham: json['tenSanPham'] as String,
  hinhAnh: json['hinhAnh'] as String?,
  giaBan: (json['giaBan'] as num).toDouble(),
  giaKhuyenMai: (json['giaKhuyenMai'] as num?)?.toDouble(),
  trangThai: json['trangThai'] as String,
  soLuongTonKho: (json['soLuongTonKho'] as num).toInt(),
  ngayThem: DateTime.parse(json['ngayThem'] as String),
  giaHienThi: (json['giaHienThi'] as num).toDouble(),
  coKhuyenMai: json['coKhuyenMai'] as bool,
  conHang: json['conHang'] as bool,
);

Map<String, dynamic> _$WishlistItemToJson(WishlistItem instance) =>
    <String, dynamic>{
      'idYeuThich': instance.idYeuThich,
      'idSanPham': instance.idSanPham,
      'tenSanPham': instance.tenSanPham,
      'hinhAnh': instance.hinhAnh,
      'giaBan': instance.giaBan,
      'giaKhuyenMai': instance.giaKhuyenMai,
      'trangThai': instance.trangThai,
      'soLuongTonKho': instance.soLuongTonKho,
      'ngayThem': instance.ngayThem.toIso8601String(),
      'giaHienThi': instance.giaHienThi,
      'coKhuyenMai': instance.coKhuyenMai,
      'conHang': instance.conHang,
    };
