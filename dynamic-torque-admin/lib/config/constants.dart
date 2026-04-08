class AppConstants {
  static const String appName = 'Dynamic Torque Admin';
  static const String companyName = 'MNA Dynamic Torque Sdn Bhd';
  static const String currency = 'MYR';
  static const String currencySymbol = 'RM';
  static const double freeShippingThreshold = 500.0;
  static const double flatShippingRate = 15.0;

  static const List<String> productCategories = [
    'clutch_plate',
    'steel_plate',
    'auto_filter',
    'forward_drum',
    'oil_pump',
    'piston_seal',
    'overhaul_kit',
    'lubricants',
  ];

  static const Map<String, String> categoryLabels = {
    'clutch_plate': 'Clutch Plate',
    'steel_plate': 'Steel Plate',
    'auto_filter': 'Auto Filter',
    'forward_drum': 'Forward Drum',
    'oil_pump': 'Oil Pump',
    'piston_seal': 'Piston Seal',
    'overhaul_kit': 'Overhaul Kit',
    'lubricants': 'Lubricants',
  };

  static const Map<String, String> orderStatusLabels = {
    'pending': 'Pending',
    'confirmed': 'Confirmed',
    'processing': 'Processing',
    'dispatched': 'Dispatched',
    'delivered': 'Delivered',
    'cancelled': 'Cancelled',
  };

  static const Map<String, String> paymentMethodLabels = {
    'bank_transfer': 'Bank Transfer',
    'cod': 'Cash on Delivery',
    'online': 'Online Payment',
  };

  static const Map<String, String> paymentStatusLabels = {
    'unpaid': 'Unpaid',
    'paid': 'Paid',
    'refunded': 'Refunded',
  };
}
