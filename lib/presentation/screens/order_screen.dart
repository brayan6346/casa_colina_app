import 'package:casa_colina_app/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/cart_provider.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final order = cart.currentOrder;
    if (order == null) {
      return Scaffold(
        backgroundColor: Colors.grey[100],

        appBar: AppBar(
          backgroundColor: Colors.brown,
          elevation: 0,

          iconTheme: const IconThemeData(
            color: Colors.white, // color del back
          ),

          title: const Text(
            "Estado del Pedido",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),

          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              HomeScreen.of(context)?.changeTab(2);
            },
          ),
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "No hay pedidos activos",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  //  te manda al menú
                  HomeScreen.of(context)?.changeTab(1);
                },
                child: const Text(
                  "Ver menú",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0,

        iconTheme: const IconThemeData(
          color: Colors.white, // color del back
        ),

        title: const Text(
          "Estado del Pedido",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HomeScreen.of(context)?.changeTab(2);
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //  ID
            Text("Pedido ${order.id}",
                style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 20),

            //  TIMELINE
            buildStep(
              "Pedido Recibido",
              order.status.index >= 0,
            ),

            buildStep(
              "En Preparación",
              order.status.index >= 1,
              subtitle: "Nuestro chef está preparando tu comida",
            ),

            buildStep(
              "Listo para Recoger",
              order.status.index >= 2,
            ),

            buildStep(
              "Entregado",
              order.status.index >= 3,
              subtitle: order.status == OrderStatus.delivered
                  ? "Tu pedido ya está listo 🎉"
                  : null,
            ),

            const SizedBox(height: 20),

            //  HORA
            infoCard(
              Icons.access_time,
              "Hora de Recogida",
              order.time,
            ),

            const SizedBox(height: 10),

            //  DIRECCIÓN
            infoCard(
              Icons.location_on,
              "Dirección del Restaurante",
              "Casa Colina\nSurquillo, Lima",
            ),

            const SizedBox(height: 20),

            //  RESUMEN
            const Text("Resumen del Pedido",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ...order.items.map((item) {
                    return ListTile(
                      title: Text(item.product.name),
                      subtitle: Text("x${item.quantity}"),
                      trailing: Text(
                        "S/. ${(item.product.price * item.quantity).toStringAsFixed(2)}",
                      ),
                    );
                  }),

                  const Divider(),

                  ListTile(
                    title: const Text("Total"),
                    trailing: Text("S/. ${order.total.toStringAsFixed(2)}"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //  BOTONES
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // aquí luego puedes integrar llamada real
                },
                icon: const Icon(Icons.phone, color: Colors.white),
                label: const Text("Llamar al Restaurante",
                    style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  openMap();// Google Maps
                },
                icon: const Icon(Icons.map),
                label: const Text("Ver Mapa"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  STEP TIMELINE
  Widget buildStep(String title, bool active, {String? subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: active ? const Color.fromARGB(255, 0, 242, 20) : Colors.grey[300],
              child: Icon(
                Icons.check,
                size: 16,
                color: active ? Colors.white : Colors.grey,
              ),
            ),
            Container(
              width: 2,
              height: 40,
              color: Colors.grey[300],
            ),
          ],
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: active ? Colors.black : Colors.grey,
                  )),
              if (subtitle != null)
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        )
      ],
    );
  }

  //  CARD INFO
  Widget infoCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value),
            ],
          )
        ],
      ),
    );
  }

  Future<void> openMap() async {

    final Uri url = Uri.parse(
      "https://maps.app.goo.gl/VYWB2ukzuLxXJwf89",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}