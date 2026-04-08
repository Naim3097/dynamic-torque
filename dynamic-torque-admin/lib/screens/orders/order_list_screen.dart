import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/order_model.dart';
import '../../services/seed_data.dart';
import '../../utils/formatters.dart';
import '../../widgets/common/status_badge.dart';
import 'order_detail_screen.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  String _statusFilter = 'all';
  String _search = '';

  @override
  Widget build(BuildContext context) {
    List<Order> orders = SeedData.orders;

    // Filter
    if (_statusFilter != 'all') {
      orders = orders.where((o) => o.status == _statusFilter).toList();
    }
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      orders = orders
          .where((o) =>
              o.orderNumber.toLowerCase().contains(q) ||
              o.shipping.fullName.toLowerCase().contains(q) ||
              o.shipping.email.toLowerCase().contains(q))
          .toList();
    }

    // Sort newest first
    orders = List.of(orders)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      children: [
        // Toolbar
        Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Row(
            children: [
              // Search
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    style: const TextStyle(fontSize: 13, color: AppColors.white),
                    decoration: InputDecoration(
                      hintText: 'Search orders...',
                      prefixIcon: const Icon(Icons.search,
                          size: 18, color: AppColors.textMuted),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0x0DFFFFFF)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Status filter
              SizedBox(
                height: 40,
                child: DropdownButtonHideUnderline(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0x0DFFFFFF)),
                    ),
                    child: DropdownButton<String>(
                      value: _statusFilter,
                      dropdownColor: AppColors.bgSecondary,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textMuted),
                      items: const [
                        DropdownMenuItem(
                            value: 'all', child: Text('All Status')),
                        DropdownMenuItem(
                            value: 'pending', child: Text('Pending')),
                        DropdownMenuItem(
                            value: 'confirmed', child: Text('Confirmed')),
                        DropdownMenuItem(
                            value: 'processing', child: Text('Processing')),
                        DropdownMenuItem(
                            value: 'dispatched', child: Text('Dispatched')),
                        DropdownMenuItem(
                            value: 'delivered', child: Text('Delivered')),
                        DropdownMenuItem(
                            value: 'cancelled', child: Text('Cancelled')),
                      ],
                      onChanged: (v) =>
                          setState(() => _statusFilter = v ?? 'all'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Results count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${orders.length} ${orders.length == 1 ? 'order' : 'orders'}',
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Order list
        Expanded(
          child: orders.isEmpty
              ? const Center(
                  child: Text('No orders found',
                      style:
                          TextStyle(color: AppColors.textMuted, fontSize: 14)),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _OrderRow(
                      order: order,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                OrderDetailScreen(order: order),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _OrderRow extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const _OrderRow({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgSecondary,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        hoverColor: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 700) {
                return _desktopRow();
              }
              return _compactRow();
            },
          ),
        ),
      ),
    );
  }

  Widget _desktopRow() {
    return Row(
      children: [
        // Order number + customer
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.orderNumber,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  fontFamily: 'monospace',
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                order.shipping.fullName,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Date
        Expanded(
          flex: 2,
          child: Text(
            formatDateTime(order.createdAt),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),

        // Status + Payment
        Expanded(
          flex: 2,
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              StatusBadge(status: order.status),
              StatusBadge(status: order.paymentStatus, isPayment: true),
            ],
          ),
        ),

        // Total
        SizedBox(
          width: 90,
          child: Text(
            formatPrice(order.total),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ),

        const SizedBox(width: 8),
        const Icon(Icons.chevron_right,
            size: 18, color: AppColors.textMuted),
      ],
    );
  }

  Widget _compactRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                order.orderNumber,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  fontFamily: 'monospace',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              formatPrice(order.total),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${order.shipping.fullName} · ${formatDateShort(order.createdAt)} · ${order.items.length} items',
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          children: [
            StatusBadge(status: order.status),
            StatusBadge(status: order.paymentStatus, isPayment: true),
          ],
        ),
      ],
    );
  }
}
