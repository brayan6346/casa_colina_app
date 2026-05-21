import 'package:flutter/material.dart';
import 'home_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() =>
      _AdminLoginScreenState();
}

class _AdminLoginScreenState
    extends State<AdminLoginScreen> {

  final TextEditingController codigoController =
      TextEditingController();

  String error = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(""),
      ),

      body: Padding(
        padding: const EdgeInsets.all(25),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.admin_panel_settings,
              size: 90,
              color: Colors.brown,
            ),

            const SizedBox(height: 20),

            const Text(
              "Acceso Admin",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: codigoController,
              obscureText: true,

              decoration: InputDecoration(
                labelText: "Código administrador",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 15),

            if(error.isNotEmpty)
              Text(
                error,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.all(16),
                ),

                onPressed: () {

                  if(codigoController.text == "1234") {

                    HomeScreen.adminGlobal = true;

                    Navigator.pushAndRemoveUntil(
                      context,

                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),

                      (route) => false,
                    );

                  } else {

                    setState(() {
                      error = "Código incorrecto";
                    });

                  }
                },

                child: const Text(
                  "Ingresar",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}