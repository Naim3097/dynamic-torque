class OrderItem {
  final String productId;
  final String productName;
  final String sku;
  final int quantity;
  final double unitPrice;
  final double total;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'] as String,
      productName: json['name'] as String,
      sku: json['sku'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
      total: (json['line_total'] as num).toDouble(),
    );
  }
}

class ShippingAddress {
  final String fullName;
  final String? company;
  final String phone;
  final String email;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  const ShippingAddress({
    required this.fullName,
    this.company,
    required this.phone,
    required this.email,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    this.country = 'Malaysia',
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      fullName: json['fullName'] as String? ?? '',
      company: json['company'] as String?,
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      addressLine1: json['addressLine1'] as String? ?? '',
      addressLine2: json['addressLine2'] as String?,
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      country: json['country'] as String? ?? 'Malaysia',
    );
  }
}

class Order {
  final String id;
  final String orderNumber;
  final String userId;
  final String accountType;
  final List<OrderItem> items;
  final ShippingAddress shipping;
  final double subtotal;
  final double discount;
  final double shippingCost;
  final double tax;
  final double total;
  final String currency;
  final String status;
  final String? notes;
  final String paymentMethod;
  final String paymentStatus;
  final String? trackingNumber;
  final String? poNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.orderNumber,
    this.userId = '',
    this.accountType = 'b2c',
    required this.items,
    required this.shipping,
    required this.subtotal,
    this.discount = 0,
    required this.shippingCost,
    this.tax = 0,
    required this.total,
    this.currency = 'MYR',
    required this.status,
    this.notes,
    required this.paymentMethod,
    required this.paymentStatus,
    this.trackingNumber,
    this.poNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final shippingJson = json['shipping_address'];
    final shipping = shippingJson is Map<String, dynamic>
        ? ShippingAddress.fromJson(shippingJson)
        : const ShippingAddress(
            fullName: '', phone: '', email: '', addressLine1: '',
            city: '', state: '', postalCode: '');

    final itemsList = json['order_items'] as List? ?? [];
    final items = itemsList
        .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
        .toList();

    return Order(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      userId: json['user_id'] as String? ?? '',
      accountType: json['account_type'] as String? ?? 'b2c',
      items: items,
      shipping: shipping,
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      shippingCost: (json['shipping_cost'] as num?)?.toDouble() ?? 0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'MYR',
      status: json['order_status'] as String,
      notes: json['notes'] as String?,
      paymentMethod: json['payment_method'] as String? ?? 'bank_transfer',
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      trackingNumber: json['tracking_number'] as String?,
      poNumber: json['po_number'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Order copyWith({
    String? status,
    String? paymentStatus,
    String? trackingNumber,
    String? notes,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id,
      orderNumber: orderNumber,
      userId: userId,
      accountType: accountType,
      items: items,
      shipping: shipping,
      subtotal: subtotal,
      discount: discount,
      shippingCost: shippingCost,
      tax: tax,
      total: total,
      currency: currency,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      poNumber: poNumber,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
