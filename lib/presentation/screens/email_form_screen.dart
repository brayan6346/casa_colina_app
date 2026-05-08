import 'package:casa_colina_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'home_screen.dart';

class EmailFormScreen extends StatefulWidget {
  const EmailFormScreen({super.key});

  @override
  State<EmailFormScreen> createState() => _EmailFormScreenState();
}

class _EmailFormScreenState extends State<EmailFormScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();

  String? nameError;
  String? emailError;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    //  Escuchar focus para actualizar UI
    nameFocus.addListener(() => setState(() {}));
    emailFocus.addListener(() => setState(() {}));
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
  }

  void _validateAndContinue() async {
    setState(() {
      nameError = null;
      emailError = null;
    });

    bool isValid = true;

    if (nameController.text.trim().isEmpty) {
      nameError = "Ingresa tu nombre";
      isValid = false;
    }

    if (emailController.text.trim().isEmpty) {
      emailError = "Ingresa tu correo";
      isValid = false;
    } else if (!isValidEmail(emailController.text.trim())) {
      emailError = "Correo inválido";
      isValid = false;
    }

    if (!isValid) {
      setState(() {});
      return;
    }

    setState(() => isLoading = true);

    //  GUARDAR USUARIO
    Provider.of<UserProvider>(context, listen: false).setUser(
      nameController.text.trim(),
      emailController.text.trim(),
    );

    await Future.delayed(const Duration(seconds: 1));

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
  }

  Widget _inputField({
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    String? error,
    TextInputType? keyboardType,
  }) {
    final isFocused = focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isFocused ? const Color.fromARGB(255, 255, 2, 150) : Colors.grey.shade300, //  cambia color
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: isFocused
                    ? const Color.fromARGB(255, 255, 206, 231)   //  color cuando está activo
                    : Colors.grey.shade500,  //  color normal
              ),
            ),
          ),
        ),

        if (error != null) ...[
          const SizedBox(height: 5),
          Text(
            error,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            const Text(
              "Completa tus datos",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Usaremos esta información para tus pedidos",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 40),

            //  NOMBRE
            _inputField(
              hint: "Tu nombre",
              controller: nameController,
              focusNode: nameFocus,
              error: nameError,
            ),

            const SizedBox(height: 20),

            //  EMAIL
            _inputField(
              hint: "correo@email.com",
              controller: emailController,
              focusNode: emailFocus,
              error: emailError,
              keyboardType: TextInputType.emailAddress,
            ),

            const Spacer(),

            SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _validateAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 2, 150),
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Confirmar",
                          style: TextStyle(fontSize: 16, color: Colors.white),
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