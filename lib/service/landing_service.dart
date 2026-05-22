import 'dart:convert';
import 'package:http/http.dart' as http;

class LandingService {

  static const String baseUrl =
      "https://3q3u8w62d9.execute-api.us-east-1.amazonaws.com/v1";


  static Future<Map<String, dynamic>> obtenerLanding() async {

    final response = await http.get(
      Uri.parse("$baseUrl/landing"),
    );

    print(response.body);

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return data["data"];

    } else {

      throw Exception(
        "Error al obtener información del landing",
      );

    }
  }
}