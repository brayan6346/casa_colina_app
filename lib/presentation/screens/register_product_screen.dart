import 'package:flutter/material.dart';
import '../../service/plato_service.dart';

class RegisterProductScreen extends StatefulWidget {
  const RegisterProductScreen({super.key});

  @override
  State<RegisterProductScreen> createState() =>
      _RegisterProductScreenState();
}

class _RegisterProductScreenState
    extends State<RegisterProductScreen> {

  final TextEditingController nombreController =
      TextEditingController();

  final TextEditingController descripcionController =
      TextEditingController();

  final TextEditingController precioController =
      TextEditingController();

  final TextEditingController imagenController =
      TextEditingController();

  int categoriaSeleccionada = 1;

  bool isLoading = false;

  final List<Map<String, dynamic>> categorias = [

    {
      "id": 1,
      "nombre": "Entradas",
    },

    {
      "id": 2,
      "nombre": "Fondos",
    },

    {
      "id": 3,
      "nombre": "Parrillas",
    },

    {
      "id": 4,
      "nombre": "Cortes",
    },

    {
      "id": 5,
      "nombre": "Ensaladas",
    },

    {
      "id": 6,
      "nombre": "Hamburguesas",
    },

    {
      "id": 7,
      "nombre": "Postres",
    },

    {
      "id": 8,
      "nombre": "Bebidas",
    },
  ];

  Future<void> registrarProducto() async {

    if(nombreController.text.isEmpty ||
        descripcionController.text.isEmpty ||
        precioController.text.isEmpty ||
        imagenController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Completa todos los campos",
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final response =
          await PlatoService.registrarPlato(

        idCategoria: categoriaSeleccionada,

        nombre: nombreController.text,

        descripcion: descripcionController.text,

        precio: double.parse(
          precioController.text,
        ),

        importancia: 1,

        imagen: imagenController.text,
      );

      if(response) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "✅ Plato registrado correctamente",
            ),
          ),
        );

        nombreController.clear();
        descripcionController.clear();
        precioController.clear();
        imagenController.clear();

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Error al registrar plato",
            ),
          ),
        );
      }

    } catch(e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Error: $e",
          ),
        ),
      );

    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.brown,

        title: const Text(
          "Registrar Plato",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),

              child: Column(
                children: [

                  // PREVIEW IMAGEN
                  Container(
                    height: 200,
                    width: double.infinity,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),

                    child: imagenController.text.isEmpty

                        ? const Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [

                              Icon(
                                Icons.image,
                                size: 60,
                                color: Colors.grey,
                              ),

                              SizedBox(height: 10),

                              Text(
                                "Vista previa de imagen",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )

                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(20),

                            child: Image.network(
                              imagenController.text,
                              fit: BoxFit.cover,

                              errorBuilder:
                                  (_, __, ___) {

                                return const Center(
                                  child: Text(
                                    "URL inválida",
                                  ),
                                );
                              },
                            ),
                          ),
                  ),

                  const SizedBox(height: 25),

                  // NOMBRE
                  TextField(
                    controller: nombreController,

                    decoration: InputDecoration(
                      labelText: "Nombre del plato",

                      prefixIcon:
                          const Icon(Icons.restaurant),

                      filled: true,
                      fillColor: Colors.grey[100],

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CATEGORIA
                  DropdownButtonFormField<int>(

                    value: categoriaSeleccionada,

                    items: categorias.map((categoria) {

                      return DropdownMenuItem<int>(
                        value: categoria["id"],

                        child: Text(
                          categoria["nombre"],
                        ),
                      );

                    }).toList(),

                    onChanged: (value) {

                      setState(() {
                        categoriaSeleccionada = value!;
                      });

                    },

                    decoration: InputDecoration(
                      labelText: "Categoría",

                      prefixIcon:
                          const Icon(Icons.category),

                      filled: true,
                      fillColor: Colors.grey[100],

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // DESCRIPCION
                  TextField(
                    controller: descripcionController,
                    maxLines: 3,

                    decoration: InputDecoration(
                      labelText: "Descripción",

                      prefixIcon:
                          const Icon(Icons.description),

                      filled: true,
                      fillColor: Colors.grey[100],

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // PRECIO
                  TextField(
                    controller: precioController,

                    keyboardType:
                        TextInputType.number,

                    decoration: InputDecoration(
                      labelText: "Precio",

                      prefixIcon:
                          const Icon(Icons.attach_money),

                      filled: true,
                      fillColor: Colors.grey[100],

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // URL IMAGEN
                  TextField(
                    controller: imagenController,

                    onChanged: (_) {
                      setState(() {});
                    },

                    decoration: InputDecoration(
                      labelText: "URL imagen S3",

                      prefixIcon:
                          const Icon(Icons.link),

                      filled: true,
                      fillColor: Colors.grey[100],

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // BOTON
                  SizedBox(
                    width: double.infinity,
                    height: 60,

                    child: ElevatedButton.icon(

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                      ),

                      onPressed: isLoading
                          ? null
                          : registrarProducto,

                      icon: isLoading

                          ? const SizedBox(
                              height: 20,
                              width: 20,

                              child:
                                  CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )

                          : const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),

                      label: Text(
                        isLoading
                            ? "Registrando..."
                            : "Registrar Producto",

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}