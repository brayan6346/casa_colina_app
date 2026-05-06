import 'dart:async';
import 'package:casa_colina_app/presentation/screens/email_form_screen.dart';
import 'package:casa_colina_app/presentation/screens/phone_input_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:flutter/services.dart';
import '../../main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🖼 FONDO
          Positioned.fill(
            child: Image.asset(
              "assets/Rectangle.jpg",
              fit: BoxFit.cover,
            ),
          ),

          // 🌑 OVERLAY
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          // CONTENIDO
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 300),

                  const Text("Bienvenido a",
                      style: TextStyle(color: Colors.white, fontSize: 22)),

                  const SizedBox(height: 10),

                  const Text(
                    "Casa Colina",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Disfruta la mejor comida sin salir de casa",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  const Spacer(),

                  // 📱 BOTÓN CELULAR
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.phone, color: Colors.white),
                      label: const Text(
                        "Continuar con celular",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>  PhoneInputScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 📧 EMAIL
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 225, 33, 20),
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.email, color: Colors.white),
                      label: const Text(
                        "Continuar con correo",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmailFormScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _goToHome(BuildContext context) {
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
      (route) => false,
    );
  }
}