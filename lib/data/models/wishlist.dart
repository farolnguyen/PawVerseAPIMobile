import 'package:json_annotation/json_annotation.dart';

part 'wishlist.g.dart';

@JsonSerializable()
class WishlistItem {
  final int idYeuThich;
  final int idSanPham;
  final String tenSanPham;
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
}
