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
}

class Order {
  final String id;
  final String orderNumber;
  final List<OrderItem> items;
  final ShippingAddress shipping;
  final double subtotal;
  final double shippingCost;
  final double total;
  final String currency;
  final String status;
  final String? notes;
  final String paymentMethod;
  final String paymentStatus;
  final String? trackingNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.shipping,
    required this.subtotal,
    required this.shippingCost,
    required this.total,
    this.currency = 'MYR',
    required this.status,
    this.notes,
    required this.paymentMethod,
    required this.paymentStatus,
    this.trackingNumber,
    required this.createdAt,
    required this.updatedAt,
  });

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
      items: items,
      shipping: shipping,
      subtotal: subtotal,
      shippingCost: shippingCost,
      total: total,
      currency: currency,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
