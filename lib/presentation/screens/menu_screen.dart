import 'package:casa_colina_app/presentation/screens/home_screen.dart';
import 'package:casa_colina_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/mock/products.dart';
import '../../../data/mock/fondos.dart';
import '../../../data/mock/parrillas.dart';
import '../../../data/mock/cortesRes.dart';
import '../../../data/mock/ensaladas.dart';
import '../../../data/mock/hamburguesas.dart';
import '../../../data/mock/postres.dart';
import '../../../data/mock/bebidas.dart';
import '../screens/cart_screen.dart';

import '../../presentation/widgets/product_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedIndex = 0;

  final List<String> categories = [
    "Entradas",
    "Fondos",
    "Parrillas",
    "Cortes",
    "Ensaladas",
    "Hamburguesas",
    "Postres",
    "Bebidas",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Casa Colina"),
        centerTitle: true,

        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      HomeScreen.of(context)?.changeTab(1);
                    },
                  ),

                  // 🔴 BADGE
                  if (cart.totalItems > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          cart.totalItems.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],

        // 🔥 CHIPS PRO
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.grey[300],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),

      // 🔥 CONTENIDO SEGÚN CHIP
      body: IndexedStack(
        index: selectedIndex,
        children: [
          buildList(entradas),
          buildList(fondos),
          buildList(parrillas),
          buildList(cortesRes),
          buildList(ensaladas),
          buildList(hamburguesas),
          buildList(postres),
          buildList(bebidas),
        ],
      ),
    );
  }

  Widget buildList(List products) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ProductCard(product: products[index]),
        );
      },
    );
  }
}