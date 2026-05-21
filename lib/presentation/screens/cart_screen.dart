import 'package:casa_colina_app/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    if (cart.items.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[100],

        appBar: buildAppBar(context),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Tu carrito está vacío",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  HomeScreen.of(context)?.changeTab(1); // vuelve al menú
                },
                child: const Text(
                  "Ver menú",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: buildAppBar(context),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...cart.items.map((item) => cartItemCard(context, item)).toList(),

                const SizedBox(height: 20),

                // ⏰ HORA
                const Text("Hora de Recogida", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    timeChip("12:30 PM"),
                    timeChip("1:00 PM"),
                    timeChip("1:30 PM"),
                    timeChip("2:00 PM"),
                    timeChip("2:30 PM"),
                    timeChip("3:00 PM"),
                  ],
                ),

                const SizedBox(height: 20),

                // 💳 MÉTODO DE PAGO
                const Text("Método de Pago", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                const SizedBox(height: 10),

                paymentOption("Pagar al recoger"),
                paymentOption("Tarjeta de crédito"),
              ],
            ),
          ),

          // 💰 TOTAL + BOTÓN
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total"),
                    Text("S/. ${cart.total.toStringAsFixed(2)}"),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      final cart = Provider.of<CartProvider>(context, listen: false);

                      cart.startOrderSimulation();

                      HomeScreen.of(context)?.changeTab(3); // ir a Pedido
                    },
                    child: const Text(
                      "Confirmar Pedido y Tiempo",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.brown,
      elevation: 0,

      iconTheme: const IconThemeData(
        color: Colors.white,
      ),

      title: const Text(
        "Resumen del Pedido",
        style: TextStyle(color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          HomeScreen.of(context)?.changeTab(1);
        },
      ),
    );
  }

  // 🥗 CARD DE PRODUCTO
  Widget cartItemCard(BuildContext context, item) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(item.product.image, width: 70, height: 70, fit: BoxFit.cover),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("S/. ${item.product.price}"),
              ],
            ),
          ),

          Row(
            children: [
              IconButton(
                onPressed: () => cart.decreaseQuantity(item.product),
                icon: const Icon(Icons.remove_circle_outline),
              ),

              Text(item.quantity.toString()),

              IconButton(
                onPressed: () => cart.increaseQuantity(item.product),
                icon: const Icon(Icons.add_circle),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ⏰ CHIP DE HORA
  Widget timeChip(String text) {
    final cart = Provider.of<CartProvider>(context);
    final isSelected = cart.selectedTime == text;

    return GestureDetector(
      onTap: () {
        cart.setTime(text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.brown : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // 💳 OPCIÓN DE PAGO
  Widget paymentOption(String text) {
    final cart = Provider.of<CartProvider>(context);
    final isSelected = cart.selectedPayment == text;

    return GestureDetector(
      onTap: () {
        cart.setPayment(text);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.brown : const Color.fromARGB(255, 211, 211, 211),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const Icon(Icons.payments),
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}