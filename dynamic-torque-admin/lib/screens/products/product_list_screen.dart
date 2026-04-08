import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../models/product_model.dart';
import '../../services/seed_data.dart';
import '../../utils/formatters.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _categoryFilter = 'all';
  String _stockFilter = 'all';
  String _search = '';

  @override
  Widget build(BuildContext context) {
    List<Product> products = SeedData.products;

    // Filter
    if (_categoryFilter != 'all') {
      products = products.where((p) => p.category == _categoryFilter).toList();
    }
    if (_stockFilter != 'all') {
      products = products.where((p) => p.stockStatus == _stockFilter).toList();
    }
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      products = products
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.sku.toLowerCase().contains(q))
          .toList();
    }

    return Column(
      children: [
        // Toolbar
        Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _searchField(),
                    ),
                    const SizedBox(width: 12),
                    _dropdown(
                      value: _categoryFilter,
                      items: [
                        const DropdownMenuItem(
                            value: 'all', child: Text('All Categories')),
                        ...AppConstants.categoryLabels.entries.map((e) =>
                            DropdownMenuItem(value: e.key, child: Text(e.value))),
                      ],
                      onChanged: (v) =>
                          setState(() => _categoryFilter = v ?? 'all'),
                    ),
                    const SizedBox(width: 12),
                    _dropdown(
                      value: _stockFilter,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All Stock')),
                        DropdownMenuItem(
                            value: 'in_stock', child: Text('In Stock')),
                        DropdownMenuItem(
                            value: 'low_stock', child: Text('Low Stock')),
                        DropdownMenuItem(
                            value: 'out_of_stock', child: Text('Out of Stock')),
                      ],
                      onChanged: (v) =>
                          setState(() => _stockFilter = v ?? 'all'),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ProductFormScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Product'),
                      ),
                    ),
                  ],
                );
              }
              // Narrow layout: wrap filters
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: constraints.maxWidth,
                    child: _searchField(),
                  ),
                  _dropdown(
                    value: _categoryFilter,
                    items: [
                      const DropdownMenuItem(
                          value: 'all', child: Text('All Categories')),
                      ...AppConstants.categoryLabels.entries.map((e) =>
                          DropdownMenuItem(value: e.key, child: Text(e.value))),
                    ],
                    onChanged: (v) =>
                        setState(() => _categoryFilter = v ?? 'all'),
                  ),
                  _dropdown(
                    value: _stockFilter,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All Stock')),
                      DropdownMenuItem(
                          value: 'in_stock', child: Text('In Stock')),
                      DropdownMenuItem(
                          value: 'low_stock', child: Text('Low Stock')),
                      DropdownMenuItem(
                          value: 'out_of_stock', child: Text('Out of Stock')),
                    ],
                    onChanged: (v) =>
                        setState(() => _stockFilter = v ?? 'all'),
                  ),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProductFormScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Product'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // Results count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${products.length} ${products.length == 1 ? 'product' : 'products'}',
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Product list
        Expanded(
          child: products.isEmpty
              ? const Center(
                  child: Text('No products found',
                      style:
                          TextStyle(color: AppColors.textMuted, fontSize: 14)),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _ProductRow(
                      product: product,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductFormScreen(product: product),
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

  Widget _searchField() {
    return SizedBox(
      height: 40,
      child: TextField(
        onChanged: (v) => setState(() => _search = v),
        style: const TextStyle(fontSize: 13, color: AppColors.white),
        decoration: InputDecoration(
          hintText: 'Search products...',
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
    );
  }

  Widget _dropdown({
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return SizedBox(
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
            value: value,
            dropdownColor: AppColors.bgSecondary,
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            items: items,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductRow({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final stockColor = switch (product.stockStatus) {
      'in_stock' => AppColors.success,
      'low_stock' => AppColors.warning,
      'out_of_stock' => AppColors.error,
      _ => AppColors.textMuted,
    };

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
              if (constraints.maxWidth > 750) {
                return _desktopRow(stockColor);
              }
              return _compactRow(stockColor);
            },
          ),
        ),
      ),
    );
  }

  Widget _desktopRow(Color stockColor) {
    return Row(
      children: [
        // SKU
        SizedBox(
          width: 100,
          child: Text(
            product.sku,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),

        // Name + Category
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                categoryLabel(product.category),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Price + Wholesale stacked
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatPrice(product.price),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              if (product.wholesalePrice != null) ...[
                const SizedBox(height: 2),
                Text(
                  'WS ${formatPrice(product.wholesalePrice!)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Stock
        SizedBox(
          width: 60,
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: stockColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${product.stockQty}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: stockColor,
                ),
              ),
            ],
          ),
        ),

        // Active
        SizedBox(
          width: 52,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: (product.isActive ? AppColors.success : AppColors.textMuted)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              product.isActive ? 'Active' : 'Off',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color:
                    product.isActive ? AppColors.success : AppColors.textMuted,
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),
        const Icon(Icons.chevron_right,
            size: 18, color: AppColors.textMuted),
      ],
    );
  }

  Widget _compactRow(Color stockColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                product.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: (product.isActive ? AppColors.success : AppColors.textMuted)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                product.isActive ? 'Active' : 'Off',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color:
                      product.isActive ? AppColors.success : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${product.sku} · ${categoryLabel(product.category)}',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            fontFamily: 'monospace',
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [
            Text(
              formatPrice(product.price),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            if (product.wholesalePrice != null)
              Text(
                'WS ${formatPrice(product.wholesalePrice!)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: stockColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${product.stockQty} in stock',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: stockColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
