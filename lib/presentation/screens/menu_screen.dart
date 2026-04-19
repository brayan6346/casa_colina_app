import 'package:flutter/material.dart';
import '../../../data/mock/products.dart';
import '../../../data/mock/fondos.dart';
import '../../../data/mock/parrillas.dart';
import '../../../data/mock/cortesRes.dart';
import '../../../data/mock/ensaladas.dart';
import '../../../data/mock/hamburguesas.dart';
import '../../../data/mock/postres.dart';
import '../../../data/mock/bebidas.dart';

import '../../presentation/widgets/product_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        backgroundColor: Colors.grey[100],

        appBar: AppBar(
          title: const Text("Casa Colina"),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(text: "Entradas"),
              Tab(text: "Fondos"),
              Tab(text: "Parrillas"),
              Tab(text: "Cortes de Res"),
              Tab(text: "Ensaladas"),
              Tab(text: "Hamburguesas"),
              Tab(text: "Postres"),
              Tab(text: "Bebidas"),   
            ],
          ),
        ),

        body: TabBarView(
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
      ),
    );
  }

  Widget buildList(List products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}