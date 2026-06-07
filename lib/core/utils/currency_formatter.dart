import 'package:intl/intl.dart';

String formatVnd(int amount) {
  final f = NumberFormat.decimalPattern('vi');
  return '${f.format(amount)}₫';
}

/// Formats [amount] for the given [currency]. VND keeps the `₫` suffix; other
/// currencies append the ISO code (e.g. `1.000 USD`).
String formatMoney(int amount, String currency) {
  final value = NumberFormat.decimalPattern('vi').format(amount);
  return currency == 'VND' ? '$value₫' : '$value $currency';
}
