class AppUser {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String? company;
  final String accountType; // 'b2c' or 'b2b'
  final bool isTradeAccount;
  final bool isVerified;
  final int totalOrders;
  final double totalSpent;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.company,
    this.accountType = 'b2c',
    this.isTradeAccount = false,
    this.isVerified = true,
    this.totalOrders = 0,
    this.totalSpent = 0,
    required this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final acctType = json['account_type'] as String? ?? 'b2c';
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['display_name'] as String? ?? '',
      phone: json['phone'] as String?,
      company: json['business_name'] as String?,
      accountType: acctType,
      isTradeAccount: acctType == 'b2b',
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class AdminUser {
  final String id;
  final String email;
  final String fullName;
  final String role; // super_admin, manager, sales, warehouse

  const AdminUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
  });
}
