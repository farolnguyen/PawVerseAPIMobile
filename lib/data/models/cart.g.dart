// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
  id: (json['id'] as num).toInt(),
  userId: json['userId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  tongSoLuong: (json['tongSoLuong'] as num).toInt(),
  tongTien: (json['tongTien'] as num).toDouble(),
  soMucHang: (json['soMucHang'] as num).toInt(),
);

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'items': instance.items,
  'tongSoLuong': instance.tongSoLuong,
  'tongTien': instance.tongTien,
  'soMucHang': instance.soMucHang,
};

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
  id: (json['id'] as num).toInt(),
  sanPhamId: (json['sanPhamId'] as num).toInt(),
  tenSanPham: json['tenSanPham'] as String,
  hinhAnh: json['hinhAnh'] as String?,
  giaBan: (json['giaBan'] as num).toDouble(),
  giaKhuyenMai: (json['giaKhuyenMai'] as num?)?.toDouble(),
  soLuong: (json['soLuong'] as num).toInt(),
  soLuongTonKho: (json['soLuongTonKho'] as num).toInt(),
  trangThai: json['trangThai'] as String,
  giaHienThi: (json['giaHienThi'] as num).toDouble(),
  thanhTien: (json['thanhTien'] as num).toDouble(),
  coKhuyenMai: json['coKhuyenMai'] as bool,
  conHang: json['conHang'] as bool,
);

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
  'id': instance.id,
  'sanPhamId': instance.sanPhamId,
  'tenSanPham': instance.tenSanPham,
  'hinhAnh': instance.hinhAnh,
  'giaBan': instance.giaBan,
  'giaKhuyenMai': instance.giaKhuyenMai,
  'soLuong': instance.soLuong,
  'soLuongTonKho': instance.soLuongTonKho,
  'trangThai': instance.trangThai,
  'giaHienThi': instance.giaHienThi,
  'thanhTien': instance.thanhTien,
  'coKhuyenMai': instance.coKhuyenMai,
  'conHang': instance.conHang,
};
