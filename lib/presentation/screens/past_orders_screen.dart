import 'package:casa_colina_app/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class PastOrdersScreen extends StatelessWidget {
  const PastOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedidos Pasados"),
      ),
      backgroundColor: Colors.grey[100],

      body: cart.orders.isEmpty
          ? const Center(
              child: Text("No hay pedidos realizados",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.orders.length,
              itemBuilder: (context, index) {
                final order = cart.orders.reversed.toList()[index];

                return orderCard(context, order);
              },
            ),
    );
  }

  // 🧾 CARD DE PEDIDO
  Widget orderCard(BuildContext context, Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🧾 ID + TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.id),
              Text("S/. ${order.total.toStringAsFixed(2)}"),
            ],
          ),

          const SizedBox(height: 5),

          // 📅 FECHA + HORA
          Text(
            "${order.date.day}/${order.date.month}/${order.date.year} • ${order.time}",
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 10),

          // 📦 PRODUCTOS
          ...order.items.map((item) {
            return Text("${item.quantity}x ${item.product.name}");
          }),

          const SizedBox(height: 15),

          // 🔁 BOTÓN REORDENAR
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                padding: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                final cart = Provider.of<CartProvider>(context, listen: false);

                // 🔁 recargar carrito
                cart.reorder(order);

                // 🧭 ir directo al carrito
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(initialTab: 2),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.refresh, color: Colors.black),
              label: const Text(
                "Volver a pedir",
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}