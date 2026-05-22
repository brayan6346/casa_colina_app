import 'package:casa_colina_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../data/models/product_model.dart';

enum OrderStatus {
  received,
  preparing,
  ready,
  delivered,
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

//  MODELO DE PEDIDO
class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime date; 
  final String time;
  final String payment;
  OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date, 
    required this.time,
    required this.payment,
    this.status = OrderStatus.received,
  });
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final List<Order> _orders = [];

  List<CartItem> get items => _items;
  List<Order> get orders => _orders;

  //  últimos 3 pedidos
  List<Order> get recentOrders => _orders.reversed.take(3).toList();

  //  pedido actual (último)
  Order? get currentOrder =>
      _orders.isNotEmpty ? _orders.last : null;

  int get totalItems =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  String _selectedTime = "12:30 PM";
  String _selectedPayment = "Pagar al recoger";

  String get selectedTime => _selectedTime;
  String get selectedPayment => _selectedPayment;

  double get total =>
      _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  // AGREGAR
  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product == product);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }

    notifyListeners();
  }

   
  void increaseQuantity(Product product) {
    final index = _items.indexWhere((item) => item.product == product);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  
  void decreaseQuantity(Product product) {
    final index = _items.indexWhere((item) => item.product == product);

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void setTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setPayment(String payment) {
    _selectedPayment = payment;
    notifyListeners();
  }

  //  CONFIRMAR PEDIDO
  void startOrderSimulation() {
    if (_items.isEmpty) return;

    final newOrder = Order(
      id: "ORD-${DateTime.now().millisecondsSinceEpoch}",
      items: _items
          .map((item) => CartItem(
                product: item.product,
                quantity: item.quantity,
              ))
          .toList(),
      total: total,
      date: DateTime.now(), 
      time: _selectedTime,
      payment: _selectedPayment,
    );

    _orders.add(newOrder);

    //  limpiar carrito
    _items.clear();
    notifyListeners();

    //  simular proceso individual
    _simulateOrder(newOrder);
  }

  //  PROCESO POR PEDIDO (CLAVE)
  void _simulateOrder(Order order) {
    Future.delayed(const Duration(seconds: 3), () {
      order.status = OrderStatus.preparing;
      notifyListeners();
    });

    Future.delayed(const Duration(seconds: 6), () {
      order.status = OrderStatus.ready;
      notifyListeners();
    });

    Future.delayed(const Duration(seconds: 9), () {
      order.status = OrderStatus.delivered;
      notifyListeners();


      _sendNotification(order);
    });
  }

 
  void _sendNotification(Order order) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'order_channel',
      'Pedidos',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      0,
      "Pedido entregado 🎉",
      "Tu pedido ${order.id} está listo",
      details,
    );
  }

  //  VOLVER A PEDIR
  void reorder(Order order) {
    _items.clear();

    for (var item in order.items) {
      _items.add(
        CartItem(
          product: item.product,
          quantity: item.quantity,
        ),
      );
    }

    notifyListeners();
  }

  void clearCart() {

    items.clear();

    orders.clear();

    notifyListeners();
  }
}