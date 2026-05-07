import 'package:casa_colina_app/presentation/screens/home_screen.dart';
import 'package:casa_colina_app/providers/cart_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HomeScreen.of(context)?.changeTab(0);
          },
        ),
        title: const Text("Casa Colina"),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              _showDownloadDialog(context);
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
                      color: isSelected ? Colors.brown : Colors.grey[300],
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

  void _showDownloadDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // 🔥 ICONO GRANDE
                const Icon(
                  Icons.picture_as_pdf,
                  size: 60,
                  color: Colors.red,
                ),

                const SizedBox(height: 15),

                const Text(
                  "Descargar Menú",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Obtén nuestro menú completo en formato PDF",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 20),

                // 🔘 BOTÓN
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
                    icon: const Icon(Icons.download, color: Colors.white),
                    label: const Text(
                      "Descargar Menú PDF",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _downloadPDF(context);
                    },
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),  
        );
      },
    );
  }  
}

Future<void> _downloadPDF(BuildContext context) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/menu.pdf";

    final dio = Dio();

    // 🔗 CAMBIA POR TU PDF REAL
    const url = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";

    await dio.download(url, filePath);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Menú descargado correctamente 📄"),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error al descargar el archivo ❌"),
      ),
    );
  }
}