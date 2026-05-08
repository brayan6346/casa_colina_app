import 'package:casa_colina_app/presentation/screens/account_settings_screen.dart';
import 'package:casa_colina_app/presentation/screens/favorites_screen.dart';
import 'package:casa_colina_app/presentation/screens/home_screen.dart';
import 'package:casa_colina_app/presentation/screens/login_screen.dart';
import 'package:casa_colina_app/presentation/screens/past_orders_screen.dart';
import 'package:casa_colina_app/presentation/screens/payment_methods_screen.dart';
import 'package:casa_colina_app/providers/cart_provider.dart';
import 'package:casa_colina_app/providers/favorite_provider.dart';
import 'package:casa_colina_app/providers/payment_provider.dart';
import 'package:casa_colina_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //  HEADER
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
                      children: [
                        Text(
                          user.name.isEmpty ? "Invitado" : user.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user.email.isNotEmpty 
                            ? user.email 
                            : (user.phone.isNotEmpty ? user.phone : "Sin contacto"),
                          style: const TextStyle(color: Colors.grey),
                        ),

                        if (user.name.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () {
                              user.clearUser();
                              Provider.of<PaymentProvider>(context, listen: false).clearCard();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              "Cerrar sesión",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              //  OPCIONES
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
                    profileOption(
                      Icons.credit_card,
                      "Métodos de Pago",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PaymentMethodsScreen(),
                          ),
                        );
                      },
                    ),
                    divider(),
                    Consumer<FavoriteProvider>(
                      builder: (context, fav, _) {
                        return profileOption(
                          Icons.favorite_border,
                          "Mis Favoritos",
                          badge: fav.favorites.length.toString(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FavoritesScreen(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    divider(),
                    profileOption(
                      Icons.settings,
                      "Configuración de Cuenta",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AccountSettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

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

  Widget divider() {
    return const Divider(height: 1);
  }

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
          ...order.items.map((item) {
            return Text("${item.quantity}x ${item.product.name}");
          }),
          const SizedBox(height: 15),
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
                final cartProvider = Provider.of<CartProvider>(context, listen: false);
                cartProvider.reorder(order);
                HomeScreen.of(context)?.changeTab(2);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Pedido agregado al carrito")),
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

