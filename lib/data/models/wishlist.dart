import 'package:json_annotation/json_annotation.dart';
import '../../config/app_config.dart';

part 'wishlist.g.dart';

@JsonSerializable()
class WishlistItem {
  final int idYeuThich;
  final int idSanPham;
  final String tenSanPham;
  final String? tenThuongHieu;
  final String? hinhAnh;
  final double giaBan;
  final double? giaKhuyenMai;
  final String trangThai;
  final int soLuongTonKho;
  final DateTime ngayThem;
  final double giaHienThi;
  final bool coKhuyenMai;
  final bool conHang;

  WishlistItem({
    required this.idYeuThich,
    required this.idSanPham,
    required this.tenSanPham,
    this.tenThuongHieu,
    this.hinhAnh,
    required this.giaBan,
    this.giaKhuyenMai,
    required this.trangThai,
    required this.soLuongTonKho,
    required this.ngayThem,
    required this.giaHienThi,
    required this.coKhuyenMai,
    required this.conHang,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) => 
      _$WishlistItemFromJson(json);
  Map<String, dynamic> toJson() => _$WishlistItemToJson(this);
  
  // Computed properties
  String get imageUrl => AppConfig.getImageUrl(hinhAnh);
  
  double? get phanTramGiam {
    if (coKhuyenMai && giaKhuyenMai != null) {
      return ((giaBan - giaKhuyenMai!) / giaBan * 100).roundToDouble();
    }
    return null;
  }
}
