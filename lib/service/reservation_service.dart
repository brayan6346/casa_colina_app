import 'dart:convert';
import 'package:http/http.dart' as http;

class ReservationService {

  static const String baseUrl =
      "https://3q3u8w62d9.execute-api.us-east-1.amazonaws.com/v1";

  static Future<bool> registrarReserva({

    required String nombre,
    required String correo,
    required String telefono,
    required String personas,
    required String fecha,
    required String hora,
    required String mensaje,

  }) async {

    final response = await http.post(

      Uri.parse("$baseUrl/reserva"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({

        "nombre": nombre,
        "correo": correo,
        "telefono": telefono,
        "personas": personas,
        "fecha": fecha,
        "hora": hora,
        "mensaje": mensaje,

      }),
    );

    print(response.body);

    return response.statusCode == 200;
  }
}