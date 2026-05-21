import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../service/plato_service.dart';
import 'home_screen.dart';

class ProductDetailScreen extends StatefulWidget {

  final int idPlato;

  const ProductDetailScreen({
    super.key,
    required this.idPlato,
  });

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState
    extends State<ProductDetailScreen> {

  int quantity = 1;

  late Future<Product> futurePlato;

  @override
  void initState() {
    super.initState();

    futurePlato = cargarPlato();
  }

  Future<Product> cargarPlato() async {

    final data =
        await PlatoService.obtenerPlato(
      widget.idPlato,
    );

    return Product.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey[100],

      body: FutureBuilder<Product>(

        future: futurePlato,

        builder: (context, snapshot) {

          // LOADING
          if(snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ERROR
          if(snapshot.hasError) {

            return const Center(
              child: Text(
                "Error al cargar plato",
              ),
            );
          }

          final product = snapshot.data!;

          final subtotal =
              product.price * quantity;

          return Column(
            children: [

              // IMAGEN
              Stack(
                children: [

                  Hero(
                    tag: product.image,

                    child: Container(
                      height: 350,
                      width: double.infinity,

                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            product.image,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 50,
                    left: 20,

                    child: CircleAvatar(
                      backgroundColor: Colors.white,

                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                        ),

                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Container(

                  width: double.infinity,

                  padding: const EdgeInsets.all(25),

                  decoration: const BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(35),
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      // CATEGORIA
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.brown.shade100,

                          borderRadius:
                              BorderRadius.circular(30),
                        ),

                        child: Text(
                          product.category,

                          style: const TextStyle(
                            color: Colors.brown,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // NOMBRE
                      Text(
                        product.name,

                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // PRECIO
                      Text(
                        "S/ ${product.price.toStringAsFixed(2)}",

                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.brown,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // DESCRIPCIÓN
                      const Text(
                        "Descripción",

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        product.description,

                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),

                      const Spacer(),

                      // CANTIDAD + SUBTOTAL
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children: [

                          // CONTADOR
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],

                              borderRadius:
                                  BorderRadius.circular(
                                      20),
                            ),

                            child: Row(
                              children: [

                                IconButton(
                                  onPressed: () {

                                    if(quantity > 1) {

                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },

                                  icon: const Icon(
                                    Icons.remove,
                                  ),
                                ),

                                Text(
                                  quantity.toString(),

                                  style:
                                      const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {

                                    setState(() {
                                      quantity++;
                                    });

                                  },

                                  icon: const Icon(
                                    Icons.add,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // SUBTOTAL
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,

                            children: [

                              const Text(
                                "Subtotal",

                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),

                              Text(
                                "S/ ${subtotal.toStringAsFixed(2)}",

                                style:
                                    const TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // BOTON
                      SizedBox(
                        width: double.infinity,
                        height: 60,

                        child:
                            ElevatedButton.icon(

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.brown,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      20),
                            ),
                          ),

                          onPressed: () {

                            final cart =
                                Provider.of<
                                    CartProvider>(
                              context,
                              listen: false,
                            );

                            for(int i = 0;
                                i < quantity;
                                i++) {

                              cart.addToCart(
                                product,
                              );
                            }

                            ScaffoldMessenger.of(
                                    context)
                                .showSnackBar(

                              const SnackBar(
                                backgroundColor:
                                    Colors.green,

                                content: Text(
                                  "Producto agregado al carrito",
                                ),
                              ),
                            );

                            Navigator.pushAndRemoveUntil(
                              context,

                              MaterialPageRoute(
                                builder: (_) =>
                                    const HomeScreen(
                                  initialTab: 2,
                                ),
                              ),

                              (route) => false,
                            );
                          },

                          icon: const Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),

                          label: const Text(
                            "Agregar al carrito",

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}