import '../models/order.dart';
import '../services/api_service.dart';
import '../../config/app_config.dart';

class OrderRepository {
  final ApiService _api;

  OrderRepository(this._api);

  // Create Order (Checkout)
  Future<Order> createOrder({
    required String tenKhachHang,
    required String soDienThoai,
    required String diaChiGiaoHang,
    required String phuongThucThanhToan,
    int? idVanChuyen,
    int? idCoupon,
    String? ghiChu,
  }) async {
    final response = await _api.post(
      AppConfig.ordersEndpoint,
      data: {
        'tenKhachHang': tenKhachHang,
        'soDienThoai': soDienThoai,
        'diaChiGiaoHang': diaChiGiaoHang,
        'phuongThucThanhToan': phuongThucThanhToan,
        if (idVanChuyen != null) 'idVanChuyen': idVanChuyen,
        if (idCoupon != null) 'idCoupon': idCoupon,
        if (ghiChu != null) 'ghiChu': ghiChu,
      },
    );

    return Order.fromJson(response.data['data']);
  }

  // Get My Orders
  Future<List<Order>> getOrders({
    String? trangThai,
    DateTime? tuNgay,
    DateTime? denNgay,
    String? sortBy,
    String? sortOrder,
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    final response = await _api.get(
      AppConfig.ordersEndpoint,
      queryParameters: {
        if (trangThai != null) 'trangThai': trangThai,
        if (tuNgay != null) 'tuNgay': tuNgay.toIso8601String(),
        if (denNgay != null) 'denNgay': denNgay.toIso8601String(),
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );

    final List<dynamic> items = response.data['data']['items'];
    return items.map((json) => Order.fromJson(json)).toList();
  }

  // Get Order by ID
  Future<Order> getOrderById(int id) async {
    final response = await _api.get('${AppConfig.ordersEndpoint}/$id');
    
    return Order.fromJson(response.data['data']);
  }

  // Cancel Order
  Future<Order> cancelOrder(int id) async {
    final response = await _api.put('${AppConfig.ordersEndpoint}/$id/cancel');
    
    return Order.fromJson(response.data['data']);
  }
}
