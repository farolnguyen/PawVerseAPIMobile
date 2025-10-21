import 'package:json_annotation/json_annotation.dart';
import '../../config/app_config.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int idSanPham;
  final String tenSanPham;
  final String? tenAlias;
  final int? idDanhMuc;
  final String? tenDanhMuc;
  final int? idThuongHieu;
  final String? tenThuongHieu;
  final String? trongLuong;
  final String? mauSac;
  final String? xuatXu;
  final String? moTa;
  final int soLuongTonKho;
  final double giaBan;
  final double? giaVon;
  final double? giaKhuyenMai;
  final String? hinhAnh;
  final DateTime? ngaySanXuat;
  final DateTime? hanSuDung;
  final String trangThai;
  final int soLuongDaBan;
  final int soLanXem;
  final DateTime ngayTao;

  Product({
    required this.idSanPham,
    required this.tenSanPham,
    this.tenAlias,
    this.idDanhMuc,
    this.tenDanhMuc,
    this.idThuongHieu,
    this.tenThuongHieu,
    this.trongLuong,
    this.mauSac,
    this.xuatXu,
    this.moTa,
    required this.soLuongTonKho,
    required this.giaBan,
    this.giaVon,
    this.giaKhuyenMai,
    this.hinhAnh,
    this.ngaySanXuat,
    this.hanSuDung,
    required this.trangThai,
    this.soLuongDaBan = 0,
    this.soLanXem = 0,
    required this.ngayTao,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  // Computed properties
  double get giaHienThi => giaKhuyenMai ?? giaBan;
  
  bool get coKhuyenMai => 
      giaKhuyenMai != null && giaKhuyenMai! > 0 && giaKhuyenMai! < giaBan;
  
  bool get conHang => trangThai == "Còn hàng" && soLuongTonKho > 0;
  
  double? get phanTramGiam {
    if (coKhuyenMai) {
      return ((giaBan - giaKhuyenMai!) / giaBan * 100).roundToDouble();
    }
    return null;
  }
  
  String get imageUrl => AppConfig.getImageUrl(hinhAnh);
}

@JsonSerializable()
class Category {
  final int idDanhMuc;
  final String tenDanhMuc;
  final String? moTa;
  final String? hinhAnh;
  final int soLuongSanPham;

  Category({
    required this.idDanhMuc,
    required this.tenDanhMuc,
    this.moTa,
    this.hinhAnh,
    this.soLuongSanPham = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Brand {
  final int idThuongHieu;
  final String tenThuongHieu;
  final String? moTa;
  final String? logo;
  final int soLuongSanPham;

  Brand({
    required this.idThuongHieu,
    required this.tenThuongHieu,
    this.moTa,
    this.logo,
    this.soLuongSanPham = 0,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);
  Map<String, dynamic> toJson() => _$BrandToJson(this);
}
