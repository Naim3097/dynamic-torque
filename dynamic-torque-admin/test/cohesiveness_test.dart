/// Comprehensive feature parity & cohesiveness test
/// Validates that the Flutter admin dashboard is consistent with
/// the React web app in data models, seed data, design tokens,
/// categories, statuses, and business logic.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dynamic_torque_admin/config/theme.dart';
import 'package:dynamic_torque_admin/config/constants.dart';
import 'package:dynamic_torque_admin/models/product_model.dart';
import 'package:dynamic_torque_admin/models/order_model.dart';
import 'package:dynamic_torque_admin/models/user_model.dart';
import 'package:dynamic_torque_admin/services/seed_data.dart';
import 'package:dynamic_torque_admin/services/auth_service.dart';
import 'package:dynamic_torque_admin/utils/formatters.dart';

// ───────────────────────────────────────────────────────────────────
// Reference values taken from the React web app source code.
// Any mismatch here means the two apps have drifted out of sync.
// ───────────────────────────────────────────────────────────────────

void main() {
  // ═══════════════════════════════════════════════════════════════
  // 1. DESIGN TOKENS — COLORS
  // ═══════════════════════════════════════════════════════════════
  group('Design tokens — colors match web app CSS variables', () {
    test('--color-bg-primary = #0B1A2E', () {
      expect(AppColors.bgPrimary, const Color(0xFF0B1A2E));
    });
    test('--color-bg-secondary = #132D4A', () {
      expect(AppColors.bgSecondary, const Color(0xFF132D4A));
    });
    test('--color-blue-mid = #1E5F8C', () {
      expect(AppColors.blueMid, const Color(0xFF1E5F8C));
    });
    test('--color-blue-bright = #2A8FD4', () {
      expect(AppColors.blueBright, const Color(0xFF2A8FD4));
    });
    test('--color-blue-light = #6BB8E0', () {
      expect(AppColors.blueLight, const Color(0xFF6BB8E0));
    });
    test('--color-red-accent = #D42B2B', () {
      expect(AppColors.redAccent, const Color(0xFFD42B2B));
    });
    test('--color-red-hover = #B52222', () {
      expect(AppColors.redHover, const Color(0xFFB52222));
    });
    test('--color-surface = #162E48', () {
      expect(AppColors.surface, const Color(0xFF162E48));
    });
    test('--color-text-muted = #A0B4C8', () {
      expect(AppColors.textMuted, const Color(0xFFA0B4C8));
    });
    test('--color-steel = #8FAABE', () {
      expect(AppColors.steel, const Color(0xFF8FAABE));
    });
    test('--color-success = #22C55E', () {
      expect(AppColors.success, const Color(0xFF22C55E));
    });
    test('--color-warning = #F59E0B', () {
      expect(AppColors.warning, const Color(0xFFF59E0B));
    });
    test('--color-error = #EF4444', () {
      expect(AppColors.error, const Color(0xFFEF4444));
    });
    test('white = #FFFFFF', () {
      expect(AppColors.white, const Color(0xFFFFFFFF));
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 2. THEME — DARK MODE & FONT FAMILY
  // ═══════════════════════════════════════════════════════════════
  group('Theme settings match web app', () {
    late ThemeData theme;
    setUpAll(() => theme = AppTheme.build());

    test('Dark brightness (web app has no light mode)', () {
      expect(theme.brightness, Brightness.dark);
    });
    test('Scaffold bg = bgPrimary', () {
      expect(theme.scaffoldBackgroundColor, AppColors.bgPrimary);
    });
    test('Primary color = blueBright', () {
      expect(theme.primaryColor, AppColors.blueBright);
    });
    test('Font family is Inter (web app body font)', () {
      // ThemeData.textTheme defaults inherit the fontFamily from AppTheme
      expect(theme.textTheme.bodyMedium?.fontFamily, 'Inter');
    });
    test('AppBar bg = bgSecondary', () {
      expect(theme.appBarTheme.backgroundColor, AppColors.bgSecondary);
    });
    test('AppBar elevation = 0', () {
      expect(theme.appBarTheme.elevation, 0);
    });
    test('Card elevation = 0', () {
      expect(theme.cardTheme.elevation, 0);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 3. BRAND CONSTANTS
  // ═══════════════════════════════════════════════════════════════
  group('Brand constants match web app', () {
    test('Company name', () {
      expect(AppConstants.companyName, 'MNA Dynamic Torque Sdn Bhd');
    });
    test('Currency code', () {
      expect(AppConstants.currency, 'MYR');
    });
    test('Currency symbol', () {
      expect(AppConstants.currencySymbol, 'RM');
    });
    test('Free shipping threshold is RM 500', () {
      expect(AppConstants.freeShippingThreshold, 500.0);
    });
    test('Flat shipping rate is RM 15', () {
      expect(AppConstants.flatShippingRate, 15.0);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 4. PRODUCT CATEGORIES (all 8)
  // ═══════════════════════════════════════════════════════════════
  group('Product categories — exact match with web app', () {
    const webCategories = {
      'clutch_plate': 'Clutch Plate',
      'steel_plate': 'Steel Plate',
      'auto_filter': 'Auto Filter',
      'forward_drum': 'Forward Drum',
      'oil_pump': 'Oil Pump',
      'piston_seal': 'Piston Seal',
      'overhaul_kit': 'Overhaul Kit',
      'lubricants': 'Lubricants',
    };

    test('Category count is 8', () {
      expect(AppConstants.categoryLabels.length, 8);
      expect(AppConstants.productCategories.length, 8);
    });

    for (final entry in webCategories.entries) {
      test('Category "${entry.key}" → "${entry.value}"', () {
        expect(AppConstants.categoryLabels[entry.key], entry.value);
      });
    }

    test('Category slug list matches keys', () {
      expect(
        AppConstants.productCategories.toSet(),
        webCategories.keys.toSet(),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 5. ORDER STATUSES (all 6)
  // ═══════════════════════════════════════════════════════════════
  group('Order statuses — exact match with web app', () {
    const webStatuses = {
      'pending': 'Pending',
      'confirmed': 'Confirmed',
      'processing': 'Processing',
      'dispatched': 'Dispatched',
      'delivered': 'Delivered',
      'cancelled': 'Cancelled',
    };

    test('Status count is 6', () {
      expect(AppConstants.orderStatusLabels.length, 6);
    });

    for (final entry in webStatuses.entries) {
      test('Status "${entry.key}" → "${entry.value}"', () {
        expect(AppConstants.orderStatusLabels[entry.key], entry.value);
      });
    }
  });

  // ═══════════════════════════════════════════════════════════════
  // 6. PAYMENT METHODS (all 3) & PAYMENT STATUSES (all 3)
  // ═══════════════════════════════════════════════════════════════
  group('Payment methods — exact match with web app', () {
    const webMethods = {
      'bank_transfer': 'Bank Transfer',
      'cod': 'Cash on Delivery',
      'online': 'Online Payment',
    };

    test('Method count is 3', () {
      expect(AppConstants.paymentMethodLabels.length, 3);
    });

    for (final entry in webMethods.entries) {
      test('Method "${entry.key}" → "${entry.value}"', () {
        expect(AppConstants.paymentMethodLabels[entry.key], entry.value);
      });
    }
  });

  group('Payment statuses — exact match with web app', () {
    const webPayStatuses = {
      'unpaid': 'Unpaid',
      'paid': 'Paid',
      'refunded': 'Refunded',
    };

    test('Payment status count is 3', () {
      expect(AppConstants.paymentStatusLabels.length, 3);
    });

    for (final entry in webPayStatuses.entries) {
      test('Payment status "${entry.key}" → "${entry.value}"', () {
        expect(AppConstants.paymentStatusLabels[entry.key], entry.value);
      });
    }
  });

  // ═══════════════════════════════════════════════════════════════
  // 7. PRODUCT MODEL — FIELD PARITY
  // ═══════════════════════════════════════════════════════════════
  group('Product model fields match web app Product type', () {
    late Product sample;
    setUpAll(() => sample = SeedData.products.first);

    // Every field present in the web app's TypeScript interface
    // must be accessible on the Flutter Product class.
    test('has id', () => expect(sample.id, isNotEmpty));
    test('has name', () => expect(sample.name, isNotEmpty));
    test('has slug', () => expect(sample.slug, isNotEmpty));
    test('has sku', () => expect(sample.sku, isNotEmpty));
    test('has category', () => expect(sample.category, isNotEmpty));
    test('has description', () => expect(sample.description, isNotEmpty));
    test('has specifications (Map)', () {
      expect(sample.specifications, isA<Map<String, String>>());
    });
    test('has compatibleVehicles (List)', () {
      expect(sample.compatibleVehicles, isA<List<String>>());
    });
    test('has compatibleGearboxes (List)', () {
      expect(sample.compatibleGearboxes, isA<List<String>>());
    });
    test('has price (double)', () => expect(sample.price, isA<double>()));
    test('has currency', () => expect(sample.currency, 'MYR'));
    test('has wholesalePrice', () {
      expect(sample.wholesalePrice, isA<double>());
    });
    test('has minWholesaleQty', () {
      expect(sample.minWholesaleQty, isA<int>());
    });
    test('has images (List)', () {
      expect(sample.images, isA<List<String>>());
    });
    test('has thumbnailUrl', () {
      expect(sample.thumbnailUrl, isA<String>());
    });
    test('has stockQty', () => expect(sample.stockQty, isA<int>()));
    test('has stockStatus', () {
      expect(sample.stockStatus, isIn(['in_stock', 'low_stock', 'out_of_stock']));
    });
    test('has lowStockThreshold', () {
      expect(sample.lowStockThreshold, isA<int>());
    });
    test('has tags (List)', () {
      expect(sample.tags, isA<List<String>>());
    });
    test('has isFeatured', () => expect(sample.isFeatured, isA<bool>()));
    test('has isActive', () => expect(sample.isActive, isA<bool>()));
    test('has createdAt', () => expect(sample.createdAt, isA<DateTime>()));
    test('has updatedAt', () => expect(sample.updatedAt, isA<DateTime>()));

    // Admin-only extension
    test('has costPrice (admin-only field)', () {
      expect(sample.costPrice, isA<double>());
    });

    test('copyWith works', () {
      final updated = sample.copyWith(name: 'Updated');
      expect(updated.name, 'Updated');
      expect(updated.sku, sample.sku);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 8. ORDER MODEL — FIELD PARITY
  // ═══════════════════════════════════════════════════════════════
  group('Order model fields match web app Order type', () {
    late Order sample;
    setUpAll(() => sample = SeedData.orders.first);

    test('has id', () => expect(sample.id, isNotEmpty));
    test('has orderNumber (DT-YYMMDD-XXXX format)', () {
      expect(sample.orderNumber, matches(RegExp(r'^DT-\d{6}-\d{4}$')));
    });
    test('has items (List<OrderItem>)', () {
      expect(sample.items, isA<List<OrderItem>>());
      expect(sample.items, isNotEmpty);
    });
    test('has shipping (ShippingAddress)', () {
      expect(sample.shipping, isA<ShippingAddress>());
    });
    test('has subtotal', () => expect(sample.subtotal, isA<double>()));
    test('has shippingCost', () {
      expect(sample.shippingCost, isA<double>());
    });
    test('has total', () => expect(sample.total, isA<double>()));
    test('has currency = MYR', () => expect(sample.currency, 'MYR'));
    test('has status (valid enum string)', () {
      expect(sample.status,
          isIn(['pending', 'confirmed', 'processing', 'dispatched', 'delivered', 'cancelled']));
    });
    test('has paymentMethod', () {
      expect(sample.paymentMethod,
          isIn(['bank_transfer', 'cod', 'online']));
    });
    test('has paymentStatus', () {
      expect(sample.paymentStatus, isIn(['unpaid', 'paid', 'refunded']));
    });
    test('has createdAt', () => expect(sample.createdAt, isA<DateTime>()));
    test('has updatedAt', () => expect(sample.updatedAt, isA<DateTime>()));

    // Admin-only extension
    test('has trackingNumber (admin field)', () {
      // trackingNumber is nullable — just verify the field exists
      expect(() => sample.trackingNumber, returnsNormally);
    });

    test('copyWith works', () {
      final updated = sample.copyWith(status: 'dispatched');
      expect(updated.status, 'dispatched');
      expect(updated.orderNumber, sample.orderNumber);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 9. ORDER ITEM — FIELD PARITY
  // ═══════════════════════════════════════════════════════════════
  group('OrderItem fields match web app', () {
    late OrderItem item;
    setUpAll(() => item = SeedData.orders.first.items.first);

    test('has productId', () => expect(item.productId, isNotEmpty));
    test('has productName', () => expect(item.productName, isNotEmpty));
    test('has sku', () => expect(item.sku, isNotEmpty));
    test('has quantity > 0', () => expect(item.quantity, greaterThan(0)));
    test('has unitPrice > 0', () {
      expect(item.unitPrice, greaterThan(0));
    });
    test('has total = quantity × unitPrice', () {
      expect(item.total, item.quantity * item.unitPrice);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 10. SHIPPING ADDRESS — FIELD PARITY
  // ═══════════════════════════════════════════════════════════════
  group('ShippingAddress fields match web app', () {
    late ShippingAddress addr;
    setUpAll(() => addr = SeedData.orders.first.shipping);

    test('has fullName', () => expect(addr.fullName, isNotEmpty));
    test('has phone', () => expect(addr.phone, isNotEmpty));
    test('has email', () => expect(addr.email, isNotEmpty));
    test('has addressLine1', () => expect(addr.addressLine1, isNotEmpty));
    test('addressLine2 is nullable', () {
      expect(() => addr.addressLine2, returnsNormally);
    });
    test('has city', () => expect(addr.city, isNotEmpty));
    test('has state', () => expect(addr.state, isNotEmpty));
    test('has postalCode', () => expect(addr.postalCode, isNotEmpty));
    test('country defaults to Malaysia', () {
      expect(addr.country, 'Malaysia');
    });
    test('company is nullable', () {
      expect(() => addr.company, returnsNormally);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 11. USER MODEL — FIELD PARITY
  // ═══════════════════════════════════════════════════════════════
  group('AppUser fields match web app User type', () {
    late AppUser user;
    setUpAll(() => user = SeedData.customers.first);

    test('has id', () => expect(user.id, isNotEmpty));
    test('has email', () => expect(user.email, isNotEmpty));
    test('has fullName', () => expect(user.fullName, isNotEmpty));
    test('phone is nullable', () {
      expect(() => user.phone, returnsNormally);
    });
    test('company is nullable', () {
      expect(() => user.company, returnsNormally);
    });
    test('has isTradeAccount', () {
      expect(user.isTradeAccount, isA<bool>());
    });
    test('has createdAt', () => expect(user.createdAt, isA<DateTime>()));

    // Admin-only extensions
    test('has isVerified (admin view)', () {
      expect(user.isVerified, isA<bool>());
    });
    test('has totalOrders (admin view)', () {
      expect(user.totalOrders, isA<int>());
    });
    test('has totalSpent (admin view)', () {
      expect(user.totalSpent, isA<double>());
    });
    test('accountType getter returns trade or standard', () {
      expect(user.accountType, isIn(['trade', 'standard']));
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 12. SEED PRODUCTS — EXACT VALUE MATCH (all 16)
  // ═══════════════════════════════════════════════════════════════
  group('Seed products — 16 products matching web app', () {
    late List<Product> products;
    setUpAll(() => products = SeedData.products);

    test('Total product count is 16', () {
      expect(products.length, 16);
    });

    // Web app reference: exact name/sku/category/price/wholesale/stock for all 16
    final webProducts = <Map<String, dynamic>>[
      {'sku': 'DT-CP-0001', 'name': 'AT Clutch Friction Plate 3.5mm', 'category': 'clutch_plate', 'price': 28.0, 'wholesale': 22.0, 'stock': 150, 'featured': true},
      {'sku': 'DT-CP-0002', 'name': 'HD Clutch Disc A750E', 'category': 'clutch_plate', 'price': 35.0, 'wholesale': 28.0, 'stock': 85, 'featured': false},
      {'sku': 'DT-SP-0001', 'name': 'Steel Separator Plate 1.8mm', 'category': 'steel_plate', 'price': 16.0, 'wholesale': 12.0, 'stock': 200, 'featured': false},
      {'sku': 'DT-SP-0002', 'name': 'Waved Steel Plate A340', 'category': 'steel_plate', 'price': 20.0, 'wholesale': 15.0, 'stock': 120, 'featured': false},
      {'sku': 'DT-AF-0001', 'name': 'ATF Inline Filter Universal', 'category': 'auto_filter', 'price': 12.0, 'wholesale': 9.0, 'stock': 300, 'featured': true},
      {'sku': 'DT-AF-0002', 'name': 'Pan Transmission Filter Kit', 'category': 'auto_filter', 'price': 25.0, 'wholesale': 19.0, 'stock': 95, 'featured': false},
      {'sku': 'DT-FD-0001', 'name': 'Forward Clutch Drum A750E', 'category': 'forward_drum', 'price': 120.0, 'wholesale': 95.0, 'stock': 25, 'featured': true},
      {'sku': 'DT-FD-0002', 'name': 'Forward Drum Shell Assembly', 'category': 'forward_drum', 'price': 105.0, 'wholesale': 85.0, 'stock': 18, 'featured': false},
      {'sku': 'DT-OP-0001', 'name': 'Front Oil Pump Body A340', 'category': 'oil_pump', 'price': 150.0, 'wholesale': 120.0, 'stock': 15, 'featured': true},
      {'sku': 'DT-OP-0002', 'name': 'Oil Pump Gear Set', 'category': 'oil_pump', 'price': 85.0, 'wholesale': 68.0, 'stock': 30, 'featured': false},
      {'sku': 'DT-PS-0001', 'name': 'Bonded Piston Seal Kit A750E', 'category': 'piston_seal', 'price': 14.0, 'wholesale': 10.0, 'stock': 250, 'featured': false},
      {'sku': 'DT-PS-0002', 'name': 'D-Ring Seal Assortment', 'category': 'piston_seal', 'price': 10.0, 'wholesale': 7.5, 'stock': 400, 'featured': false},
      {'sku': 'DT-OK-0001', 'name': 'Master Rebuild Kit A750E', 'category': 'overhaul_kit', 'price': 250.0, 'wholesale': 195.0, 'stock': 20, 'featured': true},
      {'sku': 'DT-OK-0002', 'name': 'Banner Kit A340', 'category': 'overhaul_kit', 'price': 160.0, 'wholesale': 128.0, 'stock': 35, 'featured': false},
      {'sku': 'DT-LB-0001', 'name': 'ATF Dexron VI 1L', 'category': 'lubricants', 'price': 18.0, 'wholesale': 14.0, 'stock': 500, 'featured': true},
      {'sku': 'DT-LB-0002', 'name': 'CVT Fluid NS-3 1L', 'category': 'lubricants', 'price': 22.0, 'wholesale': 17.0, 'stock': 350, 'featured': false},
    ];

    for (var i = 0; i < webProducts.length; i++) {
      final ref = webProducts[i];
      group('Product ${i + 1}: ${ref['sku']}', () {
        late Product p;
        setUpAll(() {
          p = products.firstWhere((x) => x.sku == ref['sku'],
              orElse: () => throw StateError('Missing SKU ${ref['sku']}'));
        });

        test('name matches', () => expect(p.name, ref['name']));
        test('category matches', () => expect(p.category, ref['category']));
        test('price matches', () => expect(p.price, ref['price']));
        test('wholesalePrice matches', () {
          expect(p.wholesalePrice, ref['wholesale']);
        });
        test('stockQty matches', () => expect(p.stockQty, ref['stock']));
        test('isFeatured matches', () {
          expect(p.isFeatured, ref['featured']);
        });
        test('isActive is true', () => expect(p.isActive, true));
        test('currency is MYR', () => expect(p.currency, 'MYR'));
        test('has costPrice (admin extra)', () {
          expect(p.costPrice, isNotNull);
          expect(p.costPrice, greaterThan(0));
        });
      });
    }

    test('All 8 categories are represented', () {
      final cats = products.map((p) => p.category).toSet();
      expect(cats, AppConstants.productCategories.toSet());
    });

    test('Each category has exactly 2 products', () {
      for (final cat in AppConstants.productCategories) {
        final count = products.where((p) => p.category == cat).length;
        expect(count, 2, reason: 'Category $cat should have 2 products');
      }
    });

    test('6 products are featured (matching web app)', () {
      final featured = products.where((p) => p.isFeatured).length;
      expect(featured, 6);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 13. SEED PRODUCTS — SPECIFICATIONS & COMPATIBILITY
  // ═══════════════════════════════════════════════════════════════
  group('Seed products — specifications match web app', () {
    late List<Product> products;
    setUpAll(() => products = SeedData.products);

    test('Product 1 specs: thickness, material, diameter', () {
      final p = products.firstWhere((x) => x.sku == 'DT-CP-0001');
      expect(p.specifications['thickness'], '3.5mm');
      expect(p.specifications['material'], 'Organic Friction');
      expect(p.specifications['diameter'], '165mm');
    });

    test('Product 1 compatible vehicles', () {
      final p = products.firstWhere((x) => x.sku == 'DT-CP-0001');
      expect(p.compatibleVehicles, containsAll(['Toyota Hilux', 'Toyota Fortuner', 'Isuzu D-Max']));
    });

    test('Product 1 compatible gearboxes', () {
      final p = products.firstWhere((x) => x.sku == 'DT-CP-0001');
      expect(p.compatibleGearboxes, containsAll(['A750E', 'A750F']));
    });

    test('Product 5 (Universal) compatibility', () {
      final p = products.firstWhere((x) => x.sku == 'DT-AF-0001');
      expect(p.compatibleVehicles, contains('Universal'));
      expect(p.compatibleGearboxes, contains('Universal'));
    });

    test('Product 13 (overhaul kit) specs', () {
      final p = products.firstWhere((x) => x.sku == 'DT-OK-0001');
      expect(p.specifications['coverage'], 'Full overhaul');
    });

    test('All products have non-empty descriptions', () {
      for (final p in products) {
        expect(p.description, isNotEmpty,
            reason: '${p.sku} missing description');
      }
    });

    test('All products have specifications', () {
      for (final p in products) {
        expect(p.specifications, isNotEmpty,
            reason: '${p.sku} missing specifications');
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 14. SEED ORDERS — EXACT VALUE MATCH (all 5)
  // ═══════════════════════════════════════════════════════════════
  group('Seed orders — 5 orders matching web-app-scale data', () {
    late List<Order> orders;
    setUpAll(() => orders = SeedData.orders);

    test('Total order count is 5', () {
      expect(orders.length, 5);
    });

    test('Order 1 (DT-260405-0001): confirmed / paid / bank_transfer', () {
      final o = orders.firstWhere((x) => x.orderNumber == 'DT-260405-0001');
      expect(o.status, 'confirmed');
      expect(o.paymentStatus, 'paid');
      expect(o.paymentMethod, 'bank_transfer');
      expect(o.subtotal, 460.0);
      expect(o.shippingCost, 15.0);
      expect(o.total, 475.0);
      expect(o.items.length, 2);
    });

    test('Order 2 (DT-260406-0001): pending / unpaid', () {
      final o = orders.firstWhere((x) => x.orderNumber == 'DT-260406-0001');
      expect(o.status, 'pending');
      expect(o.paymentStatus, 'unpaid');
      expect(o.total, 337.0);
    });

    test('Order 3 (DT-260407-0001): processing / paid / 3 items', () {
      final o = orders.firstWhere((x) => x.orderNumber == 'DT-260407-0001');
      expect(o.status, 'processing');
      expect(o.paymentStatus, 'paid');
      expect(o.items.length, 3);
      expect(o.subtotal, 480.0);
      expect(o.total, 495.0);
    });

    test('Order 4 (DT-260408-0001): pending / cod / unpaid', () {
      final o = orders.firstWhere((x) => x.orderNumber == 'DT-260408-0001');
      expect(o.status, 'pending');
      expect(o.paymentMethod, 'cod');
      expect(o.paymentStatus, 'unpaid');
      expect(o.total, 165.0);
    });

    test('Order 5 (DT-260401-0001): delivered / free shipping (>500)', () {
      final o = orders.firstWhere((x) => x.orderNumber == 'DT-260401-0001');
      expect(o.status, 'delivered');
      expect(o.paymentStatus, 'paid');
      expect(o.shippingCost, 0);
      expect(o.subtotal, 620.0);
      expect(o.total, 620.0);
    });

    test('All order numbers match DT-YYMMDD-XXXX format', () {
      for (final o in orders) {
        expect(o.orderNumber, matches(RegExp(r'^DT-\d{6}-\d{4}$')),
            reason: 'Order ${o.id} has bad number: ${o.orderNumber}');
      }
    });

    test('All orders have valid statuses', () {
      final validStatuses = AppConstants.orderStatusLabels.keys.toSet();
      for (final o in orders) {
        expect(validStatuses, contains(o.status),
            reason: 'Order ${o.orderNumber} has invalid status: ${o.status}');
      }
    });

    test('All orders have valid payment methods', () {
      final validMethods = AppConstants.paymentMethodLabels.keys.toSet();
      for (final o in orders) {
        expect(validMethods, contains(o.paymentMethod),
            reason: 'Order ${o.orderNumber} has invalid method: ${o.paymentMethod}');
      }
    });

    test('All orders have valid payment statuses', () {
      final validStatuses = AppConstants.paymentStatusLabels.keys.toSet();
      for (final o in orders) {
        expect(validStatuses, contains(o.paymentStatus),
            reason: 'Order ${o.orderNumber} has invalid payment status: ${o.paymentStatus}');
      }
    });

    test('Subtotal + shippingCost = total for every order', () {
      for (final o in orders) {
        expect(o.subtotal + o.shippingCost, o.total,
            reason: 'Order ${o.orderNumber} totals don\'t add up');
      }
    });

    test('Item totals sum to subtotal for each order', () {
      for (final o in orders) {
        final itemSum = o.items.fold<double>(0, (s, i) => s + i.total);
        expect(itemSum, o.subtotal,
            reason: 'Order ${o.orderNumber} item sum mismatch');
      }
    });

    test('Free shipping applied when subtotal >= 500', () {
      for (final o in orders) {
        if (o.subtotal >= AppConstants.freeShippingThreshold) {
          expect(o.shippingCost, 0,
              reason: 'Order ${o.orderNumber} should have free shipping');
        } else {
          expect(o.shippingCost, AppConstants.flatShippingRate,
              reason: 'Order ${o.orderNumber} should have flat rate shipping');
        }
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 15. SEED ORDERS — ITEM-LEVEL DETAIL
  // ═══════════════════════════════════════════════════════════════
  group('Seed order items reference valid products', () {
    late List<Product> products;
    late List<Order> orders;
    setUpAll(() {
      products = SeedData.products;
      orders = SeedData.orders;
    });

    test('Every order item references a real product ID', () {
      final validIds = products.map((p) => p.id).toSet();
      for (final o in orders) {
        for (final item in o.items) {
          expect(validIds, contains(item.productId),
              reason: 'Order ${o.orderNumber} item ${item.sku} references unknown product ${item.productId}');
        }
      }
    });

    test('Every order item SKU matches the referenced product', () {
      for (final o in orders) {
        for (final item in o.items) {
          final product = products.firstWhere((p) => p.id == item.productId);
          expect(item.sku, product.sku,
              reason: 'Order ${o.orderNumber} item SKU mismatch for ${item.productId}');
        }
      }
    });

    test('Every order item name matches the referenced product', () {
      for (final o in orders) {
        for (final item in o.items) {
          final product = products.firstWhere((p) => p.id == item.productId);
          expect(item.productName, product.name,
              reason: 'Order ${o.orderNumber} item name mismatch for ${item.sku}');
        }
      }
    });

    test('Item total = quantity × unitPrice', () {
      for (final o in orders) {
        for (final item in o.items) {
          expect(item.total, item.quantity * item.unitPrice,
              reason: 'Order ${o.orderNumber} item ${item.sku} total mismatch');
        }
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 16. SEED CUSTOMERS (all 5)
  // ═══════════════════════════════════════════════════════════════
  group('Seed customers — 5 customers', () {
    late List<AppUser> customers;
    setUpAll(() => customers = SeedData.customers);

    test('Total customer count is 5', () {
      expect(customers.length, 5);
    });

    test('Customer 1: Ahmad Razak (trade)', () {
      final c = customers.firstWhere((x) => x.email == 'ahmad@razakgearbox.com');
      expect(c.fullName, 'Ahmad Razak');
      expect(c.company, 'Razak Gearbox Workshop');
      expect(c.isTradeAccount, true);
      expect(c.isVerified, true);
      expect(c.totalOrders, 12);
      expect(c.totalSpent, 8450.0);
    });

    test('Customer 2: Lee Wei Ming (standard)', () {
      final c = customers.firstWhere((x) => x.email == 'wm.lee@gmail.com');
      expect(c.fullName, 'Lee Wei Ming');
      expect(c.isTradeAccount, false);
      expect(c.totalOrders, 3);
    });

    test('Customer 3: Muthu Samy (trade)', () {
      final c = customers.firstWhere((x) => x.email == 'muthu@mskauto.com.my');
      expect(c.fullName, 'Muthu Samy');
      expect(c.company, 'MSK Auto Parts Sdn Bhd');
      expect(c.isTradeAccount, true);
    });

    test('Customer 4: Tan Ah Kow (standard)', () {
      final c = customers.firstWhere((x) => x.email == 'tankow@outlook.com');
      expect(c.fullName, 'Tan Ah Kow');
      expect(c.isTradeAccount, false);
      expect(c.totalOrders, 1);
    });

    test('Customer 5: Fatimah Zahra (trade, unverified)', () {
      final c = customers.firstWhere((x) => x.email == 'fatimah@ymail.com');
      expect(c.fullName, 'Fatimah Zahra');
      expect(c.isTradeAccount, true);
      expect(c.isVerified, false);
      expect(c.totalOrders, 0);
    });

    test('Order shipping emails map to known customers', () {
      final customerEmails = customers.map((c) => c.email).toSet();
      final orders = SeedData.orders;
      for (final o in orders) {
        expect(customerEmails, contains(o.shipping.email),
            reason: 'Order ${o.orderNumber} shipping email ${o.shipping.email} is not a known customer');
      }
    });

    test('Mix of trade and standard accounts', () {
      final tradeCount = customers.where((c) => c.isTradeAccount).length;
      final stdCount = customers.where((c) => !c.isTradeAccount).length;
      expect(tradeCount, greaterThan(0));
      expect(stdCount, greaterThan(0));
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 17. AUTH SERVICE — DEMO LOGIN
  // ═══════════════════════════════════════════════════════════════
  group('Auth service — demo credentials & state', () {
    late AuthService auth;
    setUp(() => auth = AuthService());

    test('Starts unauthenticated', () {
      expect(auth.isAuthenticated, false);
      expect(auth.user, isNull);
      expect(auth.currentAdmin, isNull);
    });

    test('Login with correct demo credentials succeeds', () async {
      final ok = await auth.login('admin@dynamictorque.com', 'admin123');
      expect(ok, true);
      expect(auth.isAuthenticated, true);
      expect(auth.user?.email, 'admin@dynamictorque.com');
      expect(auth.user?.fullName, 'Admin User');
      expect(auth.user?.role, 'super_admin');
    });

    test('Login with wrong password fails', () async {
      final ok = await auth.login('admin@dynamictorque.com', 'wrong');
      expect(ok, false);
      expect(auth.isAuthenticated, false);
    });

    test('Login with wrong email fails', () async {
      final ok = await auth.login('test@test.com', 'admin123');
      expect(ok, false);
      expect(auth.isAuthenticated, false);
    });

    test('logout clears user', () async {
      await auth.login('admin@dynamictorque.com', 'admin123');
      expect(auth.isAuthenticated, true);
      auth.logout();
      expect(auth.isAuthenticated, false);
      expect(auth.user, isNull);
    });

    test('signOut is an alias for logout', () async {
      await auth.login('admin@dynamictorque.com', 'admin123');
      auth.signOut();
      expect(auth.isAuthenticated, false);
    });

    test('currentAdmin is same as user', () async {
      await auth.login('admin@dynamictorque.com', 'admin123');
      expect(auth.currentAdmin, auth.user);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 18. FORMATTERS — CURRENCY & DATE
  // ═══════════════════════════════════════════════════════════════
  group('Formatters match web app conventions', () {
    test('formatPrice uses RM prefix (matching web app)', () {
      expect(formatPrice(28.0), 'RM 28.00');
      expect(formatPrice(1234.5), 'RM 1234.50');
      expect(formatPrice(0), 'RM 0.00');
    });

    test('formatPrice with custom symbol', () {
      expect(formatPrice(10.0, symbol: 'USD'), 'USD 10.00');
    });

    test('formatDate produces d MMM yyyy', () {
      final d = DateTime(2026, 4, 5);
      expect(formatDate(d), '5 Apr 2026');
    });

    test('formatDateTime produces d MMM yyyy, h:mm a', () {
      final d = DateTime(2026, 4, 5, 9, 30);
      final result = formatDateTime(d);
      expect(result, contains('5 Apr 2026'));
      expect(result, contains('9:30'));
      expect(result, contains('AM'));
    });

    test('formatDateShort produces d MMM', () {
      final d = DateTime(2026, 4, 5);
      expect(formatDateShort(d), '5 Apr');
    });

    test('categoryLabel converts slug to title case', () {
      expect(categoryLabel('clutch_plate'), 'Clutch Plate');
      expect(categoryLabel('oil_pump'), 'Oil Pump');
      expect(categoryLabel('lubricants'), 'Lubricants');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 19. BUSINESS LOGIC — SHIPPING RULES
  // ═══════════════════════════════════════════════════════════════
  group('Shipping rules consistent with web app checkout', () {
    test('Flat rate is RM 15 for orders under RM 500', () {
      // Verified against web: FLAT_SHIPPING = 15, FREE_SHIPPING_MIN = 500
      expect(AppConstants.flatShippingRate, 15.0);
    });

    test('Free shipping threshold is RM 500', () {
      expect(AppConstants.freeShippingThreshold, 500.0);
    });

    test('Seed data respects shipping rules', () {
      for (final o in SeedData.orders) {
        if (o.subtotal >= 500) {
          expect(o.shippingCost, 0,
              reason: '${o.orderNumber}: subtotal ${o.subtotal} >= 500 but shipping is ${o.shippingCost}');
        } else {
          expect(o.shippingCost, 15.0,
              reason: '${o.orderNumber}: subtotal ${o.subtotal} < 500 but shipping is ${o.shippingCost}');
        }
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 20. STOCK STATUS LOGIC
  // ═══════════════════════════════════════════════════════════════
  group('Stock status consistent with web app logic', () {
    test('All products have valid stock status strings', () {
      for (final p in SeedData.products) {
        expect(p.stockStatus, isIn(['in_stock', 'low_stock', 'out_of_stock']),
            reason: '${p.sku} has invalid stockStatus: ${p.stockStatus}');
      }
    });

    test('Stock status is coherent with stockQty and threshold', () {
      for (final p in SeedData.products) {
        if (p.stockQty == 0) {
          expect(p.stockStatus, 'out_of_stock',
              reason: '${p.sku} has 0 stock but status is ${p.stockStatus}');
        } else if (p.stockQty <= p.lowStockThreshold) {
          expect(p.stockStatus, 'low_stock',
              reason: '${p.sku} has ${p.stockQty} <= threshold ${p.lowStockThreshold} but status is ${p.stockStatus}');
        } else {
          expect(p.stockStatus, 'in_stock',
              reason: '${p.sku} has ${p.stockQty} > threshold ${p.lowStockThreshold} but status is ${p.stockStatus}');
        }
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 21. SKU FORMAT
  // ═══════════════════════════════════════════════════════════════
  group('SKU format consistent with web app', () {
    test('All SKUs follow DT-XX-XXXX pattern', () {
      for (final p in SeedData.products) {
        expect(p.sku, matches(RegExp(r'^DT-[A-Z]{2}-\d{4}$')),
            reason: '${p.name} has non-standard SKU: ${p.sku}');
      }
    });

    test('All SKUs are unique', () {
      final skus = SeedData.products.map((p) => p.sku).toList();
      expect(skus.toSet().length, skus.length);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 22. SLUG FORMAT
  // ═══════════════════════════════════════════════════════════════
  group('Slug format consistent with web app URLs', () {
    test('All slugs are kebab-case', () {
      for (final p in SeedData.products) {
        expect(p.slug, matches(RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$')),
            reason: '${p.name} has non-kebab slug: ${p.slug}');
      }
    });

    test('All slugs are unique', () {
      final slugs = SeedData.products.map((p) => p.slug).toList();
      expect(slugs.toSet().length, slugs.length);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // 23. CROSS-CUTTING DATA INTEGRITY
  // ═══════════════════════════════════════════════════════════════
  group('Cross-cutting data integrity', () {
    test('All product categories are in the constants list', () {
      for (final p in SeedData.products) {
        expect(AppConstants.productCategories, contains(p.category),
            reason: '${p.sku} has unknown category: ${p.category}');
      }
    });

    test('All product categories have a display label', () {
      for (final cat in AppConstants.productCategories) {
        expect(AppConstants.categoryLabels[cat], isNotNull,
            reason: 'Category $cat has no label');
      }
    });

    test('All order statuses have a display label', () {
      final statuses = SeedData.orders.map((o) => o.status).toSet();
      for (final s in statuses) {
        expect(AppConstants.orderStatusLabels[s], isNotNull,
            reason: 'Status $s has no label');
      }
    });

    test('All payment methods have a display label', () {
      final methods = SeedData.orders.map((o) => o.paymentMethod).toSet();
      for (final m in methods) {
        expect(AppConstants.paymentMethodLabels[m], isNotNull,
            reason: 'Payment method $m has no label');
      }
    });

    test('All payment statuses have a display label', () {
      final statuses = SeedData.orders.map((o) => o.paymentStatus).toSet();
      for (final s in statuses) {
        expect(AppConstants.paymentStatusLabels[s], isNotNull,
            reason: 'Payment status $s has no label');
      }
    });

    test('Wholesale price is always less than retail price', () {
      for (final p in SeedData.products) {
        if (p.wholesalePrice != null) {
          expect(p.wholesalePrice!, lessThan(p.price),
              reason: '${p.sku} wholesale (${p.wholesalePrice}) >= retail (${p.price})');
        }
      }
    });

    test('Cost price is always less than retail price', () {
      for (final p in SeedData.products) {
        if (p.costPrice != null) {
          expect(p.costPrice!, lessThan(p.price),
              reason: '${p.sku} cost (${p.costPrice}) >= retail (${p.price})');
        }
      }
    });

    test('Cost price is less than wholesale price', () {
      for (final p in SeedData.products) {
        if (p.costPrice != null && p.wholesalePrice != null) {
          expect(p.costPrice!, lessThan(p.wholesalePrice!),
              reason: '${p.sku} cost (${p.costPrice}) >= wholesale (${p.wholesalePrice})');
        }
      }
    });

    test('Order item unitPrices use wholesale pricing where applicable', () {
      // In seed data, trade customers order at wholesale prices
      // Verify the price used in orders makes sense
      for (final o in SeedData.orders) {
        for (final item in o.items) {
          final product = SeedData.products.firstWhere(
              (p) => p.id == item.productId);
          expect(item.unitPrice, lessThanOrEqualTo(product.price),
              reason: '${o.orderNumber} item ${item.sku} unitPrice exceeds retail');
        }
      }
    });

    test('All IDs are unique across their type', () {
      final productIds = SeedData.products.map((p) => p.id).toList();
      expect(productIds.toSet().length, productIds.length, reason: 'Duplicate product IDs');

      final orderIds = SeedData.orders.map((o) => o.id).toList();
      expect(orderIds.toSet().length, orderIds.length, reason: 'Duplicate order IDs');

      final customerIds = SeedData.customers.map((c) => c.id).toList();
      expect(customerIds.toSet().length, customerIds.length, reason: 'Duplicate customer IDs');
    });
  });
}
