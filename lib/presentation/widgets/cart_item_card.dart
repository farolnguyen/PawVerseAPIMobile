import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../data/models/cart.dart';
import '../../config/app_config.dart';

/// Widget hiển thị item trong giỏ hàng
/// Hỗ trợ dismissible để xóa, quantity selector
class CartItemCard extends StatelessWidget {
  /// Cart item data
  final CartItem item;
  
  /// Callback khi xóa item
  final VoidCallback? onRemove;
  
  /// Callback khi thay đổi số lượng
  final Function(int quantity)? onQuantityChanged;
  
  /// Cho phép swipe to delete
  final bool dismissible;
  
  /// Callback khi tap vào item
  final VoidCallback? onTap;
  
  /// Show quantity selector (mặc định: true)
  /// Set false khi dùng trong checkout (read-only)
  final bool showQuantitySelector;

  const CartItemCard({
    super.key,
    required this.item,
    this.onRemove,
    this.onQuantityChanged,
    this.dismissible = true,
    this.onTap,
    this.showQuantitySelector = true,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    final card = Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product Image
              _buildImage(),
              
              const SizedBox(width: 12),
              
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      item.tenSanPham,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Price
                    Text(
                      currencyFormat.format(item.giaHienThi),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    // Out of stock warning
                    if (!item.conHang)
                      const Text(
                        'Hết hàng',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              
              // Quantity Controls or Total
              if (showQuantitySelector)
                _buildQuantitySelector(context, currencyFormat)
              else
                _buildTotal(currencyFormat),
            ],
          ),
        ),
      ),
    );

    // Wrap with Dismissible if enabled
    if (dismissible) {
      return Dismissible(
        key: Key(item.id.toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 32,
          ),
        ),
        onDismissed: (_) => onRemove?.call(),
        child: card,
      );
    }

    return card;
  }

  Widget _buildImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: item.hinhAnh != null && item.hinhAnh!.isNotEmpty
            ? Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.pets,
                    size: 40,
                    color: AppColors.textSecondary,
                  );
                },
              )
            : const Icon(
                Icons.pets,
                size: 40,
                color: AppColors.textSecondary,
              ),
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context, NumberFormat currencyFormat) {
    return Column(
      children: [
        // Quantity buttons
        Row(
          children: [
            // Decrease button
            IconButton(
              onPressed: item.canDecrease
                  ? () => onQuantityChanged?.call(item.soLuong - 1)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              iconSize: 24,
              color: item.canDecrease ? AppColors.primary : AppColors.textSecondary,
            ),
            
            // Quantity
            Text(
              item.soLuong.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // Increase button
            IconButton(
              onPressed: item.canIncrease
                  ? () => onQuantityChanged?.call(item.soLuong + 1)
                  : null,
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 24,
              color: item.canIncrease ? AppColors.primary : AppColors.textSecondary,
            ),
          ],
        ),
        
        // Total price
        Text(
          currencyFormat.format(item.thanhTien),
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTotal(NumberFormat currencyFormat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'x${item.soLuong}',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          currencyFormat.format(item.thanhTien),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
