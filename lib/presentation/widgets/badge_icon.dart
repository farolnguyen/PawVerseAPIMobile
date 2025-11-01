import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

/// Icon button với badge hiển thị số lượng
/// Dùng cho Cart badge, Wishlist badge, Notification badge, etc.
class BadgeIcon extends StatelessWidget {
  /// Icon chính
  final IconData icon;
  
  /// Số lượng hiển thị trong badge
  final int count;
  
  /// Callback khi tap icon
  final VoidCallback? onPressed;
  
  /// Màu của badge (default: AppColors.error)
  final Color? badgeColor;
  
  /// Màu của icon
  final Color? iconColor;
  
  /// Kích thước icon
  final double? iconSize;
  
  /// Tooltip text
  final String? tooltip;

  const BadgeIcon({
    super.key,
    required this.icon,
    required this.count,
    this.onPressed,
    this.badgeColor,
    this.iconColor,
    this.iconSize,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(icon, size: iconSize),
          color: iconColor,
          onPressed: onPressed,
          tooltip: tooltip,
        ),
        
        // Badge
        if (count > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: badgeColor ?? AppColors.error,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
