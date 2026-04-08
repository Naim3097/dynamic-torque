import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool isPayment;

  const StatusBadge({
    super.key,
    required this.status,
    this.isPayment = false,
  });

  @override
  Widget build(BuildContext context) {
    final (color, label) = isPayment ? _paymentStyle(status) : _orderStyle(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  (Color, String) _orderStyle(String status) {
    final label = AppConstants.orderStatusLabels[status] ?? status;
    switch (status) {
      case 'pending':
        return (AppColors.warning, label);
      case 'confirmed':
      case 'processing':
        return (AppColors.blueBright, label);
      case 'dispatched':
        return (AppColors.blueLight, label);
      case 'delivered':
        return (AppColors.success, label);
      case 'cancelled':
        return (AppColors.error, label);
      default:
        return (AppColors.textMuted, label);
    }
  }

  (Color, String) _paymentStyle(String status) {
    final label = AppConstants.paymentStatusLabels[status] ?? status;
    switch (status) {
      case 'paid':
        return (AppColors.success, label);
      case 'unpaid':
        return (AppColors.warning, label);
      case 'refunded':
        return (AppColors.error, label);
      default:
        return (AppColors.textMuted, label);
    }
  }
}
