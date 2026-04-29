import 'package:casa_colina_app/providers/cart_provider.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime date;
  final String time;
  final String payment;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.time,
    required this.payment,
  });
}