class AppUser {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String? company;
  final bool isTradeAccount;
  final bool isVerified;
  final int totalOrders;
  final double totalSpent;
  final DateTime createdAt;

  String get accountType => isTradeAccount ? 'trade' : 'standard';

  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.company,
    this.isTradeAccount = false,
    this.isVerified = true,
    this.totalOrders = 0,
    this.totalSpent = 0,
    required this.createdAt,
  });
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
