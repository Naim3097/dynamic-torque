import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../models/product_model.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _skuCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _wholesaleCtrl;
  late final TextEditingController _minWholesaleCtrl;
  late final TextEditingController _costCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _thresholdCtrl;
  late String _category;
  late bool _isActive;
  late bool _isFeatured;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _skuCtrl = TextEditingController(text: p?.sku ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _priceCtrl = TextEditingController(
        text: p != null ? p.price.toStringAsFixed(2) : '');
    _wholesaleCtrl = TextEditingController(
        text: p?.wholesalePrice?.toStringAsFixed(2) ?? '');
    _minWholesaleCtrl = TextEditingController(
        text: p?.minWholesaleQty?.toString() ?? '');
    _costCtrl = TextEditingController(
        text: p?.costPrice?.toStringAsFixed(2) ?? '');
    _stockCtrl = TextEditingController(text: p?.stockQty.toString() ?? '0');
    _thresholdCtrl = TextEditingController(
        text: p?.lowStockThreshold.toString() ?? '10');
    _category = p?.category ?? AppConstants.productCategories.first;
    _isActive = p?.isActive ?? true;
    _isFeatured = p?.isFeatured ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _wholesaleCtrl.dispose();
    _minWholesaleCtrl.dispose();
    _costCtrl.dispose();
    _stockCtrl.dispose();
    _thresholdCtrl.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    // In production this would call a service to persist.
    // For now, show confirmation and pop.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Product updated' : 'Product created'),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'New Product'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: _handleSave,
              child: Text(_isEditing ? 'Save Changes' : 'Create Product'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildMainFields()),
                    const SizedBox(width: 24),
                    Expanded(flex: 2, child: _buildSideFields()),
                  ],
                );
              }
              return Column(
                children: [
                  _buildMainFields(),
                  const SizedBox(height: 24),
                  _buildSideFields(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainFields() {
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
          const Text('Product Details',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white)),
          const SizedBox(height: 24),

          // Name
          _label('Product Name'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameCtrl,
            style: const TextStyle(color: AppColors.white, fontSize: 14),
            decoration: const InputDecoration(
                hintText: 'e.g. AT Clutch Friction Plate 3.5mm'),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 20),

          // SKU + Category row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('SKU'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _skuCtrl,
                      style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontFamily: 'monospace'),
                      decoration:
                          const InputDecoration(hintText: 'DT-CP-0001'),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Category'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      // ignore: deprecated_member_use
                      value: _category,
                      dropdownColor: AppColors.bgSecondary,
                      style: const TextStyle(
                          color: AppColors.white, fontSize: 14),
                      decoration: const InputDecoration(),
                      items: AppConstants.categoryLabels.entries
                          .map((e) => DropdownMenuItem(
                              value: e.key, child: Text(e.value)))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _category = v ?? _category),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Description
          _label('Description'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descCtrl,
            maxLines: 4,
            style: const TextStyle(color: AppColors.white, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Product description...',
              alignLabelWithHint: true,
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Required' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSideFields() {
    return Column(
      children: [
        // Pricing
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0x10FFFFFF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pricing',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white)),
              const SizedBox(height: 24),

              _label('Retail Price (RM)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.white, fontSize: 14),
                decoration: const InputDecoration(hintText: '0.00'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Wholesale (RM)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _wholesaleCtrl,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: AppColors.white, fontSize: 14),
                          decoration:
                              const InputDecoration(hintText: 'Optional'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Min Qty'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _minWholesaleCtrl,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: AppColors.white, fontSize: 14),
                          decoration:
                              const InputDecoration(hintText: 'e.g. 10'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _label('Cost Price (RM)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _costCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.white, fontSize: 14),
                decoration:
                    const InputDecoration(hintText: 'For P&L calculations'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Inventory
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0x10FFFFFF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Inventory',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Stock Qty'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _stockCtrl,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: AppColors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Low Stock Threshold'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _thresholdCtrl,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: AppColors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Toggles
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0x10FFFFFF)),
          ),
          child: Column(
            children: [
              _switchRow('Active', _isActive,
                  (v) => setState(() => _isActive = v)),
              const Divider(height: 24),
              _switchRow('Featured', _isFeatured,
                  (v) => setState(() => _isFeatured = v)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      ),
    );
  }

  Widget _switchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.blueBright,
        ),
      ],
    );
  }
}
