import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/user_model.dart';
import '../../services/customer_service.dart';
import '../../utils/formatters.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  String _search = '';
  String _typeFilter = 'all';
  List<AppUser> _allCustomers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await CustomerService.instance.fetchAll();
      if (!mounted) return;
      setState(() {
        _allCustomers = data;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Customer fetch error: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  List<AppUser> get _filtered {
    var list = _allCustomers;
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list
          .where((c) =>
              c.fullName.toLowerCase().contains(q) ||
              c.email.toLowerCase().contains(q) ||
              (c.company?.toLowerCase().contains(q) ?? false))
          .toList();
    }
    if (_typeFilter != 'all') {
      list = list.where((c) => c.accountType == _typeFilter).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final customers = _filtered;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Customers',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    fontFamily: 'Rajdhani',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.bgSecondary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0x10FFFFFF)),
                ),
                child: Text(
                  '${customers.length} customer${customers.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Filters
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 280,
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: const TextStyle(
                      color: AppColors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Search customers...',
                    prefixIcon:
                        Icon(Icons.search, color: AppColors.textMuted),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0x15FFFFFF)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _typeFilter,
                    dropdownColor: AppColors.bgSecondary,
                    style: const TextStyle(
                        color: AppColors.white, fontSize: 14),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.textMuted, size: 20),
                    items: const [
                      DropdownMenuItem(
                          value: 'all', child: Text('All Types')),
                      DropdownMenuItem(
                          value: 'trade', child: Text('Trade (B2B)')),
                      DropdownMenuItem(
                          value: 'standard', child: Text('Standard (B2C)')),
                    ],
                    onChanged: (v) =>
                        setState(() => _typeFilter = v ?? 'all'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Table
          Expanded(
            child: customers.isEmpty
                ? const Center(
                    child: Text('No customers found',
                        style: TextStyle(
                            color: AppColors.textMuted, fontSize: 14)),
                  )
                : ListView.separated(
                    itemCount: customers.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0x10FFFFFF)),
                    itemBuilder: (context, i) =>
                        _CustomerRow(customer: customers[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CustomerRow extends StatelessWidget {
  final AppUser customer;
  const _CustomerRow({required this.customer});

  @override
  Widget build(BuildContext context) {
    final isTrade = customer.accountType == 'trade';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 700) {
            return Row(
              children: [
                // Avatar + name
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: isTrade
                            ? AppColors.blueBright.withValues(alpha: 0.15)
                            : AppColors.textMuted.withValues(alpha: 0.15),
                        child: Text(
                          customer.fullName.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: isTrade
                                ? AppColors.blueBright
                                : AppColors.textMuted,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(customer.fullName,
                                style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text(customer.email,
                                style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12),
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Account type
                _typeBadge(isTrade),
                const SizedBox(width: 12),
                // Company
                Expanded(
                  flex: 2,
                  child: Text(
                    customer.company ?? '—',
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // Orders
                SizedBox(
                  width: 40,
                  child: Text(
                    '${customer.totalOrders}',
                    style: const TextStyle(
                        color: AppColors.white, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 8),
                // Spent
                SizedBox(
                  width: 90,
                  child: Text(
                    formatPrice(customer.totalSpent),
                    style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Verified
                const SizedBox(width: 12),
                Icon(
                  customer.isVerified
                      ? Icons.verified
                      : Icons.remove_circle_outline,
                  color: customer.isVerified
                      ? AppColors.green
                      : AppColors.textMuted,
                  size: 18,
                ),
              ],
            );
          }

          // Mobile
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: isTrade
                        ? AppColors.blueBright.withValues(alpha: 0.15)
                        : AppColors.textMuted.withValues(alpha: 0.15),
                    child: Text(
                      customer.fullName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: isTrade
                            ? AppColors.blueBright
                            : AppColors.textMuted,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(customer.fullName,
                            style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                        Text(customer.email,
                            style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  _typeBadge(isTrade),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(customer.company ?? '—',
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12)),
                  Text(
                    '${customer.totalOrders} orders · ${formatPrice(customer.totalSpent)}',
                    style: const TextStyle(
                        color: AppColors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _typeBadge(bool isTrade) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isTrade
            ? AppColors.blueBright.withValues(alpha: 0.12)
            : AppColors.textMuted.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isTrade ? 'Trade' : 'Standard',
        style: TextStyle(
          color: isTrade ? AppColors.blueBright : AppColors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
