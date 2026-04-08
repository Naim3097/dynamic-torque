import 'package:intl/intl.dart';

String formatPrice(double amount, {String symbol = 'RM'}) {
  return '$symbol ${amount.toStringAsFixed(2)}';
}

String formatDate(DateTime date) {
  return DateFormat('d MMM yyyy').format(date);
}

String formatDateTime(DateTime date) {
  return DateFormat('d MMM yyyy, h:mm a').format(date);
}

String formatDateShort(DateTime date) {
  return DateFormat('d MMM').format(date);
}

String categoryLabel(String slug) {
  return slug
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
      .join(' ');
}
