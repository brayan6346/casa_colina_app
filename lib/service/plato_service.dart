import 'dart:convert';
import 'package:http/http.dart' as http;

class PlatoService {

  static const String baseUrl =
      "https://3q3u8w62d9.execute-api.us-east-1.amazonaws.com/v1";


  //  LISTAR PLATOS

  static Future<List<dynamic>> listarPlatos() async {

    final response = await http.get(
      Uri.parse("$baseUrl/platos"),
    );

    print(response.body);

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return data["data"];

    } else {

      throw Exception("Error al listar platos");

    }
  }

 
  //  OBTENER PLATO

  static Future<dynamic> obtenerPlato(int idPlato) async {

    final response = await http.get(
      Uri.parse("$baseUrl/plato?id_plato=$idPlato"),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return data["data"][0];

    } else {

      throw Exception("Error al obtener plato");

    }
  }

 
  //  REGISTRAR PLATO

  static Future<bool> registrarPlato({
    required int idCategoria,
    required String nombre,
    required String descripcion,
    required double precio,
    required int importancia,
    required String imagen,
  }) async {

    final response = await http.post(
      Uri.parse("$baseUrl/plato"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({

        "id_categoria": idCategoria,
        "nombre": nombre,
        "descripcion": descripcion,
        "precio": precio,
        "importancia": importancia,
        "imagen": imagen,

      }),
    );

    print(response.body);

    if (response.statusCode == 200) {

      return true;

    } else {

      return false;

    }
  }
}