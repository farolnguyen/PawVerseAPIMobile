import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

/// Widget hiển thị trạng thái rỗng (empty state)
/// Được dùng khi không có data: Cart rỗng, Orders rỗng, Wishlist rỗng, etc.
class EmptyStateWidget extends StatelessWidget {
  /// Icon hiển thị (VD: Icons.shopping_cart_outlined)
  final IconData icon;
  
  /// Tiêu đề chính (VD: "Giỏ hàng trống")
  final String title;
  
  /// Nội dung mô tả (VD: "Hãy thêm sản phẩm vào giỏ hàng")
  final String message;
  
  /// Text của button (optional)
  final String? buttonText;
  
  /// Callback khi tap button (optional)
  final VoidCallback? onButtonPressed;
  
  /// Kích thước icon (default: 100)
  final double iconSize;
  
  /// Màu icon (default: textSecondary với opacity 0.5)
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
    this.iconSize = 100,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? AppColors.textSecondary.withOpacity(0.5),
            ),
            
            const SizedBox(height: 16),
            
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            // Message
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Button (optional)
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
