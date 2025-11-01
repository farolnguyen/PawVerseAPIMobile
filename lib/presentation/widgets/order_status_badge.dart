import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

/// Badge hiển thị trạng thái đơn hàng
/// Tự động chọn màu và icon dựa trên status
class OrderStatusBadge extends StatelessWidget {
  /// Trạng thái đơn hàng
  final String status;
  
  /// Kích thước badge (small, medium, large)
  final BadgeSize size;

  const OrderStatusBadge({
    super.key,
    required this.status,
    this.size = BadgeSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);
    final sizeConfig = _getSizeConfig(size);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizeConfig.paddingHorizontal,
        vertical: sizeConfig.paddingVertical,
      ),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
        border: Border.all(
          color: config.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: sizeConfig.iconSize,
            color: config.color,
          ),
          SizedBox(width: sizeConfig.spacing),
          Text(
            status,
            style: TextStyle(
              color: config.color,
              fontSize: sizeConfig.fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status) {
      case 'Chờ xác nhận':
        return _StatusConfig(
          color: Colors.orange,
          icon: Icons.hourglass_empty,
        );
      
      case 'Đã xác nhận':
        return _StatusConfig(
          color: Colors.blue,
          icon: Icons.check_circle_outline,
        );
      
      case 'Đang giao hàng':
      case 'Đang giao':
        return _StatusConfig(
          color: AppColors.primary,
          icon: Icons.local_shipping_outlined,
        );
      
      case 'Đã giao hàng':
      case 'Đã giao':
        return _StatusConfig(
          color: AppColors.success,
          icon: Icons.done_all,
        );
      
      case 'Đã hủy':
        return _StatusConfig(
          color: AppColors.error,
          icon: Icons.cancel_outlined,
        );
      
      default:
        return _StatusConfig(
          color: Colors.grey,
          icon: Icons.info_outline,
        );
    }
  }

  _SizeConfig _getSizeConfig(BadgeSize size) {
    switch (size) {
      case BadgeSize.small:
        return _SizeConfig(
          paddingHorizontal: 8,
          paddingVertical: 4,
          borderRadius: 12,
          iconSize: 14,
          fontSize: 11,
          spacing: 3,
        );
      
      case BadgeSize.medium:
        return _SizeConfig(
          paddingHorizontal: 12,
          paddingVertical: 6,
          borderRadius: 16,
          iconSize: 16,
          fontSize: 12,
          spacing: 4,
        );
      
      case BadgeSize.large:
        return _SizeConfig(
          paddingHorizontal: 16,
          paddingVertical: 8,
          borderRadius: 20,
          iconSize: 18,
          fontSize: 14,
          spacing: 6,
        );
    }
  }
}

/// Enum cho kích thước badge
enum BadgeSize { small, medium, large }

/// Config cho status (màu + icon)
class _StatusConfig {
  final Color color;
  final IconData icon;

  _StatusConfig({
    required this.color,
    required this.icon,
  });
}

/// Config cho size
class _SizeConfig {
  final double paddingHorizontal;
  final double paddingVertical;
  final double borderRadius;
  final double iconSize;
  final double fontSize;
  final double spacing;

  _SizeConfig({
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.borderRadius,
    required this.iconSize,
    required this.fontSize,
    required this.spacing,
  });
}
