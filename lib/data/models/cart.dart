import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable()
class Cart {
  final int id;
  final String userId;
  final List<CartItem> items;
  final int tongSoLuong;
  final double tongTien;
  final int soMucHang;

  Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.tongSoLuong,
    required this.tongTien,
    required this.soMucHang,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);

  // Empty cart
  factory Cart.empty() => Cart(
        id: 0,
        userId: '',
        items: [],
        tongSoLuong: 0,
        tongTien: 0,
        soMucHang: 0,
      );

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}

@JsonSerializable()
class CartItem {
  final int id;
  final int sanPhamId;
  final String tenSanPham;
  final String? hinhAnh;
  final double giaBan;
  final double? giaKhuyenMai;
  final int soLuong;
  final int soLuongTonKho;
  final String trangThai;
  final double giaHienThi;
  final double thanhTien;
  final bool coKhuyenMai;
  final bool conHang;

  CartItem({
    required this.id,
    required this.sanPhamId,
    required this.tenSanPham,
    this.hinhAnh,
    required this.giaBan,
    this.giaKhuyenMai,
    required this.soLuong,
    required this.soLuongTonKho,
    required this.trangThai,
    required this.giaHienThi,
    required this.thanhTien,
    required this.coKhuyenMai,
    required this.conHang,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  bool get canIncrease => soLuong < soLuongTonKho;
  bool get canDecrease => soLuong > 1;
}
