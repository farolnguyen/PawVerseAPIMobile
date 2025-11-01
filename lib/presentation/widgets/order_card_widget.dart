import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../data/models/order.dart';
import '../../config/app_config.dart';
import 'order_status_badge.dart';

/// Widget hiển thị thẻ đơn hàng
/// Dùng trong Orders screen và Profile screen
class OrderCardWidget extends StatelessWidget {
  /// Order data
  final Order order;
  
  /// Callback khi tap vào card
  final VoidCallback? onTap;
  
  /// Callback khi hủy đơn
  final VoidCallback? onCancel;
  
  /// Hiển thị nút chi tiết (default: true)
  final bool showDetailButton;
  
  /// Số sản phẩm tối đa hiển thị preview (default: 2)
  final int maxProductsPreview;

  const OrderCardWidget({
    super.key,
    required this.order,
    this.onTap,
    this.onCancel,
    this.showDetailButton = true,
    this.maxProductsPreview = 2,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Order ID + Status Badge
              _buildHeader(),
              
              const SizedBox(height: 8),
              
              // Date
              _buildDate(dateFormat),
              
              const Divider(height: 24),
              
              // Products Preview
              if (order.items != null && order.items!.isNotEmpty)
                _buildProductsPreview(),
              
              if (order.items != null && order.items!.length > maxProductsPreview)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'và ${order.items!.length - maxProductsPreview} sản phẩm khác',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              
              const Divider(height: 24),
              
              // Footer: Total + Actions
              _buildFooter(currencyFormat),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.receipt_long,
              size: 20,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              'Đơn hàng #${order.idDonHang}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        OrderStatusBadge(status: order.trangThai),
      ],
    );
  }

  Widget _buildDate(DateFormat dateFormat) {
    return Row(
      children: [
        const Icon(
          Icons.access_time,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          dateFormat.format(order.ngayDatHang),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildProductsPreview() {
    final itemsToShow = order.items!.take(maxProductsPreview).toList();
    
    return Column(
      children: itemsToShow.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: item.hinhAnh != null
                    ? Image.network(
                        AppConfig.getImageUrl(item.hinhAnh),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported, size: 24),
                          );
                        },
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[200],
                        child: const Icon(Icons.pets, size: 24),
                      ),
              ),
              
              const SizedBox(width: 12),
              
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.tenSanPham,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'x${item.soLuong}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Price
              Text(
                NumberFormat.currency(
                  locale: 'vi_VN',
                  symbol: '₫',
                  decimalDigits: 0,
                ).format(item.donGia),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(NumberFormat currencyFormat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Total
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tổng cộng',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              currencyFormat.format(order.tongTien),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        
        // Actions
        Row(
          children: [
            // Cancel button
            if (order.canCancel && onCancel != null)
              TextButton(
                onPressed: onCancel,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
                child: const Text('Hủy đơn'),
              ),
            
            // Detail button
            if (showDetailButton) ...[
              if (order.canCancel && onCancel != null) const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onTap,
                child: const Text('Chi tiết'),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
