import 'dart:async';
import 'package:casa_colina_app/presentation/screens/home_screen.dart';
import 'package:casa_colina_app/presentation/screens/name_input_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../main.dart';

class SmsCodeScreen extends StatefulWidget {
  final String phone;
  final bool isUpdate;

  const SmsCodeScreen({super.key, required this.phone, this.isUpdate = false});

  @override
  State<SmsCodeScreen> createState() => _SmsCodeScreenState();
}

class _SmsCodeScreenState extends State<SmsCodeScreen> {
  final TextEditingController codeController = TextEditingController();

  String generatedCode = "";
  int seconds = 60;

  @override
  void initState() {
    super.initState();

    _startTimer();
    _sendCode();
  }

  Timer? _timer;

  void _startTimer() {
    _timer?.cancel(); // 👈 evita duplicados
    seconds = 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        timer.cancel();
      } else {
        setState(() => seconds--);
      }
    });
  }

  void _sendCode() async {
    generatedCode =
        (1000 + (DateTime.now().millisecondsSinceEpoch % 9000)).toString();

    await _sendFakeSMS(generatedCode);

    // 🔥 AUTO-FILL DESPUÉS DE 2 SEGUNDOS
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        codeController.text = generatedCode;
      });
    });
  }

  void _resendCode() {
    _startTimer();   // 🔥 reinicia contador
    _sendCode();     // 🔥 manda nuevo código
  }

  bool isLoading = false;
  String? errorText;

  Future<void> _sendFakeSMS(String code) async {
    const androidDetails = AndroidNotificationDetails(
      'orders_channel',
      'Pedidos',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      1,
      "Código de verificación",
      "Tu código es: $code",
      details,
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

            const Text(
              "Ingresa el código que enviamos 👀",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "A tu número +51 ${widget.phone}",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 40),

            // 🔢 INPUT
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 10),
              decoration: const InputDecoration(
                counterText: "",
                border: OutlineInputBorder(),
              ),
            ),

            if (errorText != null) ...[
              const SizedBox(height: 10),
              Text(
                errorText!,
                style: const TextStyle(color: Colors.red),
              ),
            ],

            const SizedBox(height: 30),

            Center(
              child: seconds > 0
                  ? Text(
                      "Podrás solicitar un código nuevo en $seconds segundos",
                      style: const TextStyle(color: Colors.grey),
                    )
                  : TextButton(
                      onPressed: _resendCode,
                      child: const Text(
                        "Reenviar código",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),

            const Spacer(),

            SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                            errorText = null;
                          });

                          // ⏳ simulación de verificación
                          await Future.delayed(const Duration(seconds: 2));

                          if (codeController.text == generatedCode) {
                            // ✅ correcto
                            if (widget.isUpdate) {
                              Navigator.pop(context, true); // Retorna éxito a la pantalla anterior
                            } else {
                              navigatorKey.currentState!.pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => NameInputScreen(phone: widget.phone),
                                ),
                                (route) => false,
                              );
                            }
                          } else {
                            // ❌ incorrecto
                            setState(() {
                              isLoading = false;
                              errorText = "Código incorrecto";
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.green,
                  ),
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 10),
                            Text("Verificando...", 
                              style: TextStyle(
                              color: Colors.white),
                            ),
                          ],
                        )
                      : const Text("Verificar",
                        style: TextStyle(
                        color: Colors.white),
                      ),
                ),
              ),  
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    codeController.dispose();
    super.dispose();
  }
}