import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/common/stat_card.dart';
import '../../widgets/common/status_badge.dart';
import '../../services/product_service.dart';
import '../../services/order_service.dart';
import '../../models/product_model.dart';
import '../../models/order_model.dart';
import '../../utils/formatters.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Product> _products = [];
  List<Order> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        ProductService.instance.fetchAll(),
        OrderService.instance.fetchAll(),
      ]);
      if (!mounted) return;
      setState(() {
        _products = results[0] as List<Product>;
        _orders = results[1] as List<Order>;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Dashboard load error: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final orders = _orders;
    final products = _products;

    final totalRevenue = orders
        .where((o) => o.paymentStatus == 'paid')
        .fold(0.0, (s, o) => s + o.total);
    final pendingOrders = orders.where((o) => o.status == 'pending').length;
    final lowStock =
        products.where((p) => p.stockQty <= p.lowStockThreshold).length;
    final now = DateTime.now();
    final todayOrders = orders
        .where((o) =>
            o.createdAt.day == now.day &&
            o.createdAt.month == now.month &&
            o.createdAt.year == now.year)
        .length;

    final recentOrders = List.of(orders)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final topProducts = List.of(products)
      ..sort((a, b) => a.stockQty.compareTo(b.stockQty));
    final lowStockProducts = topProducts.take(5).toList();

    return RefreshIndicator(
      onRefresh: _load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Cards
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 900
                    ? 4
                    : constraints.maxWidth > 600
                        ? 2
                        : 1;
                final cardWidth =
                    (constraints.maxWidth - (crossAxisCount - 1) * 16) /
                        crossAxisCount;

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: StatCard(
                        title: 'Total Revenue',
                        value: formatPrice(totalRevenue),
                        icon: Icons.trending_up,
                        iconColor: AppColors.success,
                        subtitle: 'From paid orders',
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: StatCard(
                        title: 'Orders Today',
                        value: '$todayOrders',
                        icon: Icons.receipt_long,
                        iconColor: AppColors.blueBright,
                        subtitle: '${orders.length} total',
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: StatCard(
                        title: 'Low Stock Items',
                        value: '$lowStock',
                        icon: Icons.warning_amber_rounded,
                        iconColor:
                            lowStock > 0 ? AppColors.warning : AppColors.success,
                        subtitle: '${products.length} total SKUs',
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: StatCard(
                        title: 'Pending Orders',
                        value: '$pendingOrders',
                        icon: Icons.hourglass_empty_rounded,
                        iconColor: pendingOrders > 0
                            ? AppColors.warning
                            : AppColors.success,
                        subtitle: 'Awaiting confirmation',
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // Two-column layout: Recent Orders + Low Stock
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildRecentOrders(recentOrders.take(5).toList()),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: _buildLowStock(lowStockProducts),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    _buildRecentOrders(recentOrders.take(5).toList()),
                    const SizedBox(height: 16),
                    _buildLowStock(lowStockProducts),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrders(List<Order> orders) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Orders',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              Text(
                '${orders.length} orders',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (orders.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('No orders yet',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
            )
          else
            ...orders.map((order) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.orderNumber,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            order.shipping.fullName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StatusBadge(status: order.status),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 80,
                      child: Text(
                        formatPrice(order.total),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildLowStock(List<Product> products) {
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
            'Low Stock Alert',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 20),
          if (products.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'All products are well-stocked',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
            )
          else
            ...products.map((p) {
              final ratio =
                  p.stockQty / (p.lowStockThreshold * 3).clamp(1, 999);
              final barColor = ratio < 0.3
                  ? AppColors.error
                  : ratio < 0.6
                      ? AppColors.warning
                      : AppColors.success;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            p.name,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${p.stockQty} units',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: barColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: ratio.clamp(0.0, 1.0),
                        minHeight: 4,
                        backgroundColor: AppColors.surface,
                        valueColor: AlwaysStoppedAnimation(barColor),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
