import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  final int idDonHang;
  final String tenKhachHang;
  final String soDienThoai;
  final String diaChiGiaoHang;
  final String phuongThucThanhToan;
  final String trangThai;
  final DateTime ngayDatHang;
  final DateTime? ngayGiaoHangDuKien;
  final DateTime? ngayGiaoHang;
  final DateTime? ngayHuy;
  final double? tongTienSanPham;
  final double phiVanChuyen;
  final double? giamGia;
  final double tongTien;
  final String? ghiChu;
  final List<OrderItem>? items;
  final int soLuongSanPham;

  Order({
    required this.idDonHang,
    required this.tenKhachHang,
    required this.soDienThoai,
    required this.diaChiGiaoHang,
    required this.phuongThucThanhToan,
    required this.trangThai,
    required this.ngayDatHang,
    this.ngayGiaoHangDuKien,
    this.ngayGiaoHang,
    this.ngayHuy,
    this.tongTienSanPham,
    required this.phiVanChuyen,
    this.giamGia,
    required this.tongTien,
    this.ghiChu,
    this.items,
    required this.soLuongSanPham,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  // Order status helpers
  bool get isPending => trangThai == "Chờ xác nhận";
  bool get isConfirmed => trangThai == "Đã xác nhận";
  bool get isShipping => trangThai == "Đang giao hàng" || trangThai == "Đang giao";
  bool get isDelivered => trangThai == "Đã giao hàng" || trangThai == "Đã giao";
  bool get isCancelled => trangThai == "Đã hủy";
  
  bool get canCancel => isPending;
  
  String get statusColor {
    switch (trangThai) {
      case "Chờ xác nhận":
        return "warning";
      case "Đã xác nhận":
        return "info";
      case "Đang giao hàng":
      case "Đang giao":
        return "primary";
      case "Đã giao hàng":
      case "Đã giao":
        return "success";
      case "Đã hủy":
        return "error";
      default:
        return "grey";
    }
  }
}

@JsonSerializable()
class OrderItem {
  final int idSanPham;
  final String tenSanPham;
  final String? hinhAnh;
  final int soLuong;
  final double donGia;
  final double thanhTien;

  OrderItem({
    required this.idSanPham,
    required this.tenSanPham,
    this.hinhAnh,
    required this.soLuong,
    required this.donGia,
    required this.thanhTien,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
