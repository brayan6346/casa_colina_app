import 'package:casa_colina_app/data/models/product_model.dart';
import 'package:casa_colina_app/presentation/screens/home_screen.dart';
import 'package:casa_colina_app/providers/cart_provider.dart';
import 'package:casa_colina_app/service/plato_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';

import '../../presentation/widgets/product_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  int selectedIndex = 0;

  bool isLoading = true;

  List<Product> platos = [];

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
  void initState() {
    super.initState();

    cargarPlatos();
  }

  Future<void> cargarPlatos() async {

    try {

      final data = await PlatoService.listarPlatos();

      setState(() {

        platos = data.map<Product>((item) {

          return Product.fromJson(item);

        }).toList();

        isLoading = false;

      });

    } catch (e) {

      print(e);

      setState(() {
        isLoading = false;
      });

    }
  }

  List<Product> obtenerPlatosPorCategoria(String categoria) {

    return platos.where((plato) {

      return plato.category == categoria;

    }).toList();
  }

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

        title: const Text(
          "Nuestro Menú",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              _showDownloadDialog(context);
            },
          ),
        ],

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
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 10,
                    ),

                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),

                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.brown
                          : Colors.grey[300],

                      borderRadius: BorderRadius.circular(25),
                    ),

                    child: Center(
                      child: Text(
                        categories[index],

                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.black,

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

      body: isLoading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : buildList(
              obtenerPlatosPorCategoria(
                categories[selectedIndex],
              ),
            ),
    );
  }

  Widget buildList(List<Product> products) {

    if (products.isEmpty) {

      return const Center(
        child: Text(
          "No hay platos disponibles",
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),

      itemCount: products.length,

      itemBuilder: (context, index) {

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),

          child: ProductCard(
            product: products[index],
          ),
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

                //  ICONO GRANDE
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

                //  BOTÓN
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Descargando menú..."),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();

    final filePath = "${dir.path}/menu.pdf";

    final dio = Dio();

    const url =
        "https://drive.google.com/uc?export=download&id=14iBUm5G_968pNn6nedKTzP3mQvUp6aLa";

    await dio.download(url, filePath);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Menú descargado correctamente 📄"),
      ),
    );

    //  ABRIR PDF AUTOMÁTICAMENTE
    await OpenFilex.open(filePath);

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error al descargar: $e"),
      ),
    );
  }
}