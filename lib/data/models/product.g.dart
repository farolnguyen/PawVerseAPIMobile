// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  idSanPham: (json['idSanPham'] as num).toInt(),
  tenSanPham: json['tenSanPham'] as String,
  tenAlias: json['tenAlias'] as String?,
  idDanhMuc: (json['idDanhMuc'] as num?)?.toInt(),
  tenDanhMuc: json['tenDanhMuc'] as String?,
  idThuongHieu: (json['idThuongHieu'] as num?)?.toInt(),
  tenThuongHieu: json['tenThuongHieu'] as String?,
  trongLuong: json['trongLuong'] as String?,
  mauSac: json['mauSac'] as String?,
  xuatXu: json['xuatXu'] as String?,
  moTa: json['moTa'] as String?,
  soLuongTonKho: (json['soLuongTonKho'] as num).toInt(),
  giaBan: (json['giaBan'] as num).toDouble(),
  giaVon: (json['giaVon'] as num?)?.toDouble(),
  giaKhuyenMai: (json['giaKhuyenMai'] as num?)?.toDouble(),
  hinhAnh: json['hinhAnh'] as String?,
  ngaySanXuat: json['ngaySanXuat'] == null
      ? null
      : DateTime.parse(json['ngaySanXuat'] as String),
  hanSuDung: json['hanSuDung'] == null
      ? null
      : DateTime.parse(json['hanSuDung'] as String),
  trangThai: json['trangThai'] as String,
  soLuongDaBan: (json['soLuongDaBan'] as num?)?.toInt() ?? 0,
  soLanXem: (json['soLanXem'] as num?)?.toInt() ?? 0,
  ngayTao: DateTime.parse(json['ngayTao'] as String),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'idSanPham': instance.idSanPham,
  'tenSanPham': instance.tenSanPham,
  'tenAlias': instance.tenAlias,
  'idDanhMuc': instance.idDanhMuc,
  'tenDanhMuc': instance.tenDanhMuc,
  'idThuongHieu': instance.idThuongHieu,
  'tenThuongHieu': instance.tenThuongHieu,
  'trongLuong': instance.trongLuong,
  'mauSac': instance.mauSac,
  'xuatXu': instance.xuatXu,
  'moTa': instance.moTa,
  'soLuongTonKho': instance.soLuongTonKho,
  'giaBan': instance.giaBan,
  'giaVon': instance.giaVon,
  'giaKhuyenMai': instance.giaKhuyenMai,
  'hinhAnh': instance.hinhAnh,
  'ngaySanXuat': instance.ngaySanXuat?.toIso8601String(),
  'hanSuDung': instance.hanSuDung?.toIso8601String(),
  'trangThai': instance.trangThai,
  'soLuongDaBan': instance.soLuongDaBan,
  'soLanXem': instance.soLanXem,
  'ngayTao': instance.ngayTao.toIso8601String(),
};

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
  idDanhMuc: (json['idDanhMuc'] as num).toInt(),
  tenDanhMuc: json['tenDanhMuc'] as String,
  moTa: json['moTa'] as String?,
  hinhAnh: json['hinhAnh'] as String?,
  soLuongSanPham: (json['soLuongSanPham'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'idDanhMuc': instance.idDanhMuc,
  'tenDanhMuc': instance.tenDanhMuc,
  'moTa': instance.moTa,
  'hinhAnh': instance.hinhAnh,
  'soLuongSanPham': instance.soLuongSanPham,
};

Brand _$BrandFromJson(Map<String, dynamic> json) => Brand(
  idThuongHieu: (json['idThuongHieu'] as num).toInt(),
  tenThuongHieu: json['tenThuongHieu'] as String,
  moTa: json['moTa'] as String?,
  logo: json['logo'] as String?,
  soLuongSanPham: (json['soLuongSanPham'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
  'idThuongHieu': instance.idThuongHieu,
  'tenThuongHieu': instance.tenThuongHieu,
  'moTa': instance.moTa,
  'logo': instance.logo,
  'soLuongSanPham': instance.soLuongSanPham,
};
