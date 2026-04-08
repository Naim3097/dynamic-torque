class Product {
  final String id;
  final String name;
  final String slug;
  final String sku;
  final String category;
  final String description;
  final Map<String, String> specifications;
  final List<String> compatibleVehicles;
  final List<String> compatibleGearboxes;
  final double price;
  final String currency;
  final double? wholesalePrice;
  final int? minWholesaleQty;
  final List<String> images;
  final String thumbnailUrl;
  final int stockQty;
  final String stockStatus;
  final int lowStockThreshold;
  final double? costPrice;
  final List<String> tags;
  final bool isFeatured;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.sku,
    required this.category,
    required this.description,
    this.specifications = const {},
    this.compatibleVehicles = const [],
    this.compatibleGearboxes = const [],
    required this.price,
    this.currency = 'MYR',
    this.wholesalePrice,
    this.minWholesaleQty,
    this.images = const [],
    this.thumbnailUrl = '',
    required this.stockQty,
    required this.stockStatus,
    this.lowStockThreshold = 10,
    this.costPrice,
    this.tags = const [],
    this.isFeatured = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  Product copyWith({
    String? id,
    String? name,
    String? slug,
    String? sku,
    String? category,
    String? description,
    Map<String, String>? specifications,
    List<String>? compatibleVehicles,
    List<String>? compatibleGearboxes,
    double? price,
    String? currency,
    double? wholesalePrice,
    int? minWholesaleQty,
    List<String>? images,
    String? thumbnailUrl,
    int? stockQty,
    String? stockStatus,
    int? lowStockThreshold,
    double? costPrice,
    List<String>? tags,
    bool? isFeatured,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      sku: sku ?? this.sku,
      category: category ?? this.category,
      description: description ?? this.description,
      specifications: specifications ?? this.specifications,
      compatibleVehicles: compatibleVehicles ?? this.compatibleVehicles,
      compatibleGearboxes: compatibleGearboxes ?? this.compatibleGearboxes,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      minWholesaleQty: minWholesaleQty ?? this.minWholesaleQty,
      images: images ?? this.images,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      stockQty: stockQty ?? this.stockQty,
      stockStatus: stockStatus ?? this.stockStatus,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      costPrice: costPrice ?? this.costPrice,
      tags: tags ?? this.tags,
      isFeatured: isFeatured ?? this.isFeatured,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
