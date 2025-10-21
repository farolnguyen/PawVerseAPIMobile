import 'package:flutter/material.dart';
import '../data/models/order.dart';
import '../data/repositories/order_repository.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository;

  OrderProvider(this._repository);

  // State
  List<Order> _orders = [];
  Order? _selectedOrder;
  
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;
  
  // Filters
  String? _statusFilter;
  int _currentPage = 1;
  final int _pageSize = 20;

  // Getters
  List<Order> get orders => _orders;
  Order? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;
  String? get statusFilter => _statusFilter;

  // Load Orders
  Future<void> loadOrders({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _orders = [];
      _hasMore = true;
    }

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newOrders = await _repository.getOrders(
        trangThai: _statusFilter,
        pageNumber: _currentPage,
        pageSize: _pageSize,
      );

      if (newOrders.isEmpty) {
        _hasMore = false;
      } else {
        _orders.addAll(newOrders);
        _currentPage++;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get Order by ID
  Future<void> loadOrderById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedOrder = await _repository.getOrderById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final order = await _repository.createOrder(
        tenKhachHang: tenKhachHang,
        soDienThoai: soDienThoai,
        diaChiGiaoHang: diaChiGiaoHang,
        phuongThucThanhToan: phuongThucThanhToan,
        idVanChuyen: idVanChuyen,
        idCoupon: idCoupon,
        ghiChu: ghiChu,
      );

      // Refresh orders list after creating new order
      loadOrders(refresh: true);

      return order;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cancel Order
  Future<void> cancelOrder(int orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.cancelOrder(orderId);
      
      // Update local order status
      final index = _orders.indexWhere((o) => o.idDonHang == orderId);
      if (index != -1) {
        // Reload orders to get updated status
        loadOrders(refresh: true);
      }

      // Update selected order if it's the one being cancelled
      if (_selectedOrder?.idDonHang == orderId) {
        await loadOrderById(orderId);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter by Status
  void filterByStatus(String? status) {
    _statusFilter = status;
    loadOrders(refresh: true);
  }

  // Get orders by status (for tabs)
  List<Order> getOrdersByStatus(String? status) {
    if (status == null) return _orders;
    return _orders.where((o) => o.trangThai == status).toList();
  }

  // Get order count by status
  int getOrderCountByStatus(String? status) {
    if (status == null) return _orders.length;
    return _orders.where((o) => o.trangThai == status).length;
  }

  // Clear Error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear selected order
  void clearSelectedOrder() {
    _selectedOrder = null;
    notifyListeners();
  }
}
