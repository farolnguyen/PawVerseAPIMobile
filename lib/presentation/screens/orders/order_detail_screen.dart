import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../providers/order_provider.dart';
import '../../../data/models/order.dart';
import '../../../config/app_config.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  
  void _loadOrder() {
    final orderId = int.tryParse(widget.orderId);
    if (orderId != null) {
      context.read<OrderProvider>().loadOrderById(orderId);
    }
  }
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrder();
    });
  }
  
  @override
  void didUpdateWidget(OrderDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload if orderId changed
    if (oldWidget.orderId != widget.orderId) {
      _loadOrder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn hàng #${widget.orderId}'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lỗi tải thông tin đơn hàng',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    orderProvider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final orderId = int.tryParse(widget.orderId);
                      if (orderId != null) {
                        orderProvider.loadOrderById(orderId);
                      }
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final order = orderProvider.selectedOrder;
          if (order == null) {
            return const Center(child: Text('Không tìm thấy đơn hàng'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadOrder();
              // Wait for the order to load
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildOrderDetail(order),
          );
        },
      ),
    );
  }

  Widget _buildOrderDetail(Order order) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Timeline
          _buildStatusTimeline(order),
          
          const SizedBox(height: 24),

          // Order Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin đơn hàng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Mã đơn hàng:', '#${order.idDonHang}'),
                  _buildInfoRow('Ngày đặt:', dateFormat.format(order.ngayDatHang)),
                  if (order.ngayGiaoHangDuKien != null)
                    _buildInfoRow(
                      'Dự kiến giao:',
                      dateFormat.format(order.ngayGiaoHangDuKien!),
                    ),
                  _buildInfoRow('Trạng thái:', order.trangThai,
                      valueColor: _getStatusColor(order.trangThai)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Customer Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin người nhận',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Tên:', order.tenKhachHang),
                  _buildInfoRow('Số điện thoại:', order.soDienThoai),
                  _buildInfoRow('Địa chỉ:', order.diaChiGiaoHang),
                  if (order.ghiChu != null && order.ghiChu!.isNotEmpty)
                    _buildInfoRow('Ghi chú:', order.ghiChu!),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Products List
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sản phẩm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (order.items != null && order.items!.isNotEmpty)
                    ...order.items!.map((item) => _buildProductItem(item, currencyFormat)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Payment Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thanh toán',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    'Phương thức:',
                    order.phuongThucThanhToan,
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'Tạm tính',
                    currencyFormat.format(
                      (order.tongTienSanPham ?? order.tongTien) - order.phiVanChuyen + (order.giamGia ?? 0),
                    ),
                  ),
                  _buildSummaryRow(
                    'Phí vận chuyển',
                    order.phiVanChuyen == 0
                        ? 'Miễn phí'
                        : currencyFormat.format(order.phiVanChuyen),
                    valueColor: order.phiVanChuyen == 0 ? AppColors.success : null,
                  ),
                  if (order.giamGia != null && order.giamGia! > 0)
                    _buildSummaryRow(
                      'Giảm giá',
                      '-${currencyFormat.format(order.giamGia)}',
                      valueColor: AppColors.success,
                    ),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'Tổng cộng',
                    currencyFormat.format(order.tongTien),
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Cancel Button
          if (order.canCancel)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showCancelDialog(order),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Hủy đơn hàng'),
              ),
            ),

          if (order.canCancel) const SizedBox(height: 12),

          // Continue Shopping Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Tiếp tục mua sắm'),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(Order order) {
    final statuses = [
      {'status': 'Đã đặt hàng', 'completed': true},
      {
        'status': 'Đã xác nhận',
        'completed': order.isConfirmed || order.isShipping || order.isDelivered
      },
      {
        'status': 'Đang giao hàng',
        'completed': order.isShipping || order.isDelivered
      },
      {'status': 'Đã giao hàng', 'completed': order.isDelivered},
    ];

    if (order.isCancelled) {
      return Card(
        color: AppColors.error.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.cancel, color: AppColors.error, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Đơn hàng đã bị hủy',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                    if (order.ngayHuy != null)
                      Text(
                        'Ngày hủy: ${DateFormat('dd/MM/yyyy HH:mm').format(order.ngayHuy!)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: List.generate(
            statuses.length * 2 - 1,
            (index) {
              if (index.isOdd) {
                // Line connector
                final isCompleted = statuses[index ~/ 2]['completed'] as bool;
                return Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted
                        ? AppColors.primary
                        : Colors.grey[300],
                  ),
                );
              } else {
                // Status dot
                final statusIndex = index ~/ 2;
                final status = statuses[statusIndex];
                final isCompleted = status['completed'] as bool;
                
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? AppColors.primary
                            : Colors.grey[300],
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : Icons.circle,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 80,
                      child: Text(
                        status['status'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: isCompleted
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: isCompleted
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(OrderItem item, NumberFormat currencyFormat) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.hinhAnh != null
                ? Image.network(
                    AppConfig.getImageUrl(item.hinhAnh),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  )
                : Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.pets, size: 40),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.tenSanPham,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Số lượng: x${item.soLuong}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currencyFormat.format(item.donGia),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currencyFormat.format(item.thanhTien),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isTotal = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? (isTotal ? AppColors.primary : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Chờ xác nhận':
        return Colors.orange;
      case 'Đã xác nhận':
        return Colors.blue;
      case 'Đang giao hàng':
      case 'Đang giao': // Accept both formats
        return AppColors.primary;
      case 'Đã giao hàng':
      case 'Đã giao': // Accept both formats
        return AppColors.success;
      case 'Đã hủy':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  Future<void> _showCancelDialog(Order order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy đơn hàng'),
        content: Text('Bạn có chắc muốn hủy đơn hàng #${order.idDonHang}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Hủy đơn'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<OrderProvider>().cancelOrder(order.idDonHang);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã hủy đơn hàng thành công'),
              backgroundColor: AppColors.success,
            ),
          );
          
          // Reload order detail
          context.read<OrderProvider>().loadOrderById(order.idDonHang);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
