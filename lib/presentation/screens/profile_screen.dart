import 'package:casa_colina_app/presentation/screens/home_screen.dart';
import 'package:casa_colina_app/presentation/screens/past_orders_screen.dart';
import 'package:casa_colina_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 👤 HEADER
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 35, color: Colors.white),
                    ),

                    const SizedBox(width: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "María González",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text("maria.gonzalez@email.com"),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 📋 OPCIONES
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Consumer<CartProvider>(
                      builder: (context, cart, _) {
                        return profileOption(
                          Icons.receipt,
                          "Mis Pedidos Pasados",
                          badge: cart.orders.length.toString(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PastOrdersScreen(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    divider(),
                    profileOption(Icons.credit_card, "Métodos de Pago"),
                    divider(),
                    profileOption(Icons.favorite_border, "Mis Favoritos"),
                    divider(),
                    profileOption(Icons.settings, "Configuración de Cuenta"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🧾 PEDIDOS RECIENTES
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Pedidos Recientes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              Consumer<CartProvider>(
                builder: (context, cart, _) {

                  if (cart.orders.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No hay pedidos aún"),
                      ),
                    );
                  }

                  return Column(
                    children: cart.recentOrders.map((order) {
                      return orderCard(context, order);
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ), 
      ),
    );
  }

  // 🔘 OPCIONES PERFIL
  Widget profileOption(
    IconData icon,
    String title, {
    String? badge,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Text(
                badge,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
      onTap: onTap,
    );
  }

  // 🔹 DIVIDER
  Widget divider() {
    return const Divider(height: 1);
  }

  // 🧾 CARD PEDIDO
  Widget orderCard(BuildContext context, Order order) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 💰 TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Pedido"),
              Text("S/. ${order.total.toStringAsFixed(2)}"),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            "Hora: ${order.time}",
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 10),

          // 🧾 PRODUCTOS
          ...order.items.map((item) {
            return Text("${item.quantity}x ${item.product.name}");
          }),

          const SizedBox(height: 15),

          // 🔁 BOTÓN
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
                final cartProvider =
                    Provider.of<CartProvider>(context, listen: false);

                // 🔥 recargar carrito
                cartProvider.reorder(order);

                // 👉 ir al carrito
                HomeScreen.of(context)?.changeTab(1);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Pedido agregado al carrito"),
                  ),
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

