import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../models/order_model.dart';
import '../../utils/formatters.dart';
import '../../widgets/common/status_badge.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final steps = ['pending', 'confirmed', 'processing', 'dispatched', 'delivered'];
    final currentStep =
        order.status == 'cancelled' ? -1 : steps.indexOf(order.status);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text(order.orderNumber),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderNumber,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Placed ${formatDateTime(order.createdAt)}',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textMuted),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    StatusBadge(status: order.status),
                    StatusBadge(status: order.paymentStatus, isPayment: true),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Progress tracker
            if (order.status != 'cancelled') ...[
              _buildProgressTracker(steps, currentStep),
              const SizedBox(height: 32),
            ],

            // Two-column layout
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildItemsSection()),
                      const SizedBox(width: 24),
                      Expanded(flex: 2, child: _buildInfoSidebar()),
                    ],
                  );
                }
                return Column(
                  children: [
                    _buildItemsSection(),
                    const SizedBox(height: 24),
                    _buildInfoSidebar(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTracker(List<String> steps, int currentStep) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // On narrow screens, show a compact version
        if (constraints.maxWidth < 400) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(steps.length, (stepIdx) {
              final completed = stepIdx <= currentStep;
              final label = AppConstants.orderStatusLabels[steps[stepIdx]] ?? steps[stepIdx];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: completed ? AppColors.blueBright : AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${stepIdx + 1}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: completed ? AppColors.white : AppColors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: completed ? AppColors.white : AppColors.textMuted,
                    ),
                  ),
                ],
              );
            }),
          );
        }

        return Row(
          children: List.generate(steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              final stepIdx = i ~/ 2;
              final completed = stepIdx < currentStep;
              return Expanded(
                child: Container(
                  height: 2,
                  color: completed ? AppColors.blueBright : AppColors.surface,
                ),
              );
            }

            final stepIdx = i ~/ 2;
            final completed = stepIdx <= currentStep;
            final label = AppConstants.orderStatusLabels[steps[stepIdx]] ?? steps[stepIdx];

            return Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: completed ? AppColors.blueBright : AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${stepIdx + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: completed ? AppColors.white : AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: completed ? AppColors.white : AppColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildItemsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x10FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Items',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.white),
          ),
          const SizedBox(height: 16),
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.sku,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${item.quantity} x ${formatPrice(item.unitPrice)}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 80,
                      child: Text(
                        formatPrice(item.total),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )),

          const Divider(height: 24),

          // Totals
          _totalRow('Subtotal', formatPrice(order.subtotal)),
          const SizedBox(height: 6),
          _totalRow('Shipping',
              order.shippingCost == 0 ? 'Free' : formatPrice(order.shippingCost)),
          const Divider(height: 20),
          _totalRow('Total', formatPrice(order.total), bold: true),
        ],
      ),
    );
  }

  Widget _totalRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: bold ? AppColors.white : AppColors.textMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 18 : 14,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSidebar() {
    return Column(
      children: [
        // Shipping info
        _infoCard(
          'Shipping',
          [
            _infoRow(null, order.shipping.fullName, bold: true),
            if (order.shipping.company != null)
              _infoRow(null, order.shipping.company!),
            _infoRow(null, order.shipping.addressLine1),
            if (order.shipping.addressLine2 != null)
              _infoRow(null, order.shipping.addressLine2!),
            _infoRow(null,
                '${order.shipping.city}, ${order.shipping.state} ${order.shipping.postalCode}'),
            _infoRow(null, order.shipping.country),
            const SizedBox(height: 8),
            _infoRow(null, order.shipping.phone),
            _infoRow(null, order.shipping.email),
          ],
        ),
        const SizedBox(height: 16),

        // Payment info
        _infoCard(
          'Payment',
          [
            _infoRow('Method',
                AppConstants.paymentMethodLabels[order.paymentMethod] ??
                    order.paymentMethod),
            _infoRow(
                'Status',
                AppConstants.paymentStatusLabels[order.paymentStatus] ??
                    order.paymentStatus),
          ],
        ),

        if (order.notes != null) ...[
          const SizedBox(height: 16),
          _infoCard('Notes', [Text(order.notes!, style: const TextStyle(fontSize: 13, color: AppColors.textMuted))]),
        ],
      ],
    );
  }

  Widget _infoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x10FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.white),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String? label, String value, {bool bold = false}) {
    if (label == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            color: bold ? AppColors.white : AppColors.textMuted,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textMuted)),
          Text(value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
                color: AppColors.white,
              )),
        ],
      ),
    );
  }
}
