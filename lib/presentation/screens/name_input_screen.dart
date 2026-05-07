import 'package:casa_colina_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'home_screen.dart';

class NameInputScreen extends StatefulWidget {
  final String phone;
  const NameInputScreen({super.key, required this.phone});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController controller = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            const Text(
              "¿Cómo te llamas?",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Este nombre se usará en tus pedidos",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: controller,
              decoration: InputDecoration(
                errorText: errorText,
                border: const OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,

                    elevation: 6,

                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),

                    shadowColor: Colors.black.withValues(alpha: 0.25),
                  ),

                  onPressed: () {
                    if (controller.text.trim().isEmpty) {
                      setState(() {
                        errorText = "El nombre es obligatorio";
                      });
                      return;
                    }

                    // 🔥 GUARDAR NOMBRE Y CELULAR EN PROVIDER
                    Provider.of<UserProvider>(context, listen: false)
                        .setUserNameAndPhone(
                          controller.text.trim(),
                          widget.phone,
                        );

                    // 🚀 NAVEGAR AL HOME
                    navigatorKey.currentState!.pushAndRemoveUntil(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const HomeScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ),
                      (route) => false,
                    );
                  },

                  child: const Text(
                    "Continuar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}