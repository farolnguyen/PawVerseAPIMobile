// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  idDonHang: (json['idDonHang'] as num).toInt(),
  tenKhachHang: json['tenKhachHang'] as String,
  soDienThoai: json['soDienThoai'] as String,
  diaChiGiaoHang: json['diaChiGiaoHang'] as String,
  phuongThucThanhToan: json['phuongThucThanhToan'] as String,
  trangThai: json['trangThai'] as String,
  ngayDatHang: DateTime.parse(json['ngayDatHang'] as String),
  ngayGiaoHangDuKien: json['ngayGiaoHangDuKien'] == null
      ? null
      : DateTime.parse(json['ngayGiaoHangDuKien'] as String),
  ngayGiaoHang: json['ngayGiaoHang'] == null
      ? null
      : DateTime.parse(json['ngayGiaoHang'] as String),
  ngayHuy: json['ngayHuy'] == null
      ? null
      : DateTime.parse(json['ngayHuy'] as String),
  tongTienSanPham: (json['tongTienSanPham'] as num?)?.toDouble(),
  phiVanChuyen: (json['phiVanChuyen'] as num).toDouble(),
  giamGia: (json['giamGia'] as num?)?.toDouble(),
  tongTien: (json['tongTien'] as num).toDouble(),
  ghiChu: json['ghiChu'] as String?,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  soLuongSanPham: (json['soLuongSanPham'] as num).toInt(),
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'idDonHang': instance.idDonHang,
  'tenKhachHang': instance.tenKhachHang,
  'soDienThoai': instance.soDienThoai,
  'diaChiGiaoHang': instance.diaChiGiaoHang,
  'phuongThucThanhToan': instance.phuongThucThanhToan,
  'trangThai': instance.trangThai,
  'ngayDatHang': instance.ngayDatHang.toIso8601String(),
  'ngayGiaoHangDuKien': instance.ngayGiaoHangDuKien?.toIso8601String(),
  'ngayGiaoHang': instance.ngayGiaoHang?.toIso8601String(),
  'ngayHuy': instance.ngayHuy?.toIso8601String(),
  'tongTienSanPham': instance.tongTienSanPham,
  'phiVanChuyen': instance.phiVanChuyen,
  'giamGia': instance.giamGia,
  'tongTien': instance.tongTien,
  'ghiChu': instance.ghiChu,
  'items': instance.items,
  'soLuongSanPham': instance.soLuongSanPham,
};

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
  idSanPham: (json['idSanPham'] as num).toInt(),
  tenSanPham: json['tenSanPham'] as String,
  hinhAnh: json['hinhAnh'] as String?,
  soLuong: (json['soLuong'] as num).toInt(),
  donGia: (json['donGia'] as num).toDouble(),
  thanhTien: (json['thanhTien'] as num).toDouble(),
);

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
  'idSanPham': instance.idSanPham,
  'tenSanPham': instance.tenSanPham,
  'hinhAnh': instance.hinhAnh,
  'soLuong': instance.soLuong,
  'donGia': instance.donGia,
  'thanhTien': instance.thanhTien,
};
