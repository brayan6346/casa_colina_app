import 'package:flutter/material.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen>
    with SingleTickerProviderStateMixin {

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();

  DateTime? selectedDate;
  String? selectedTime;
  String? selectedPeople;

  bool isLoading = false;

  final List<String> peopleOptions = [
    "1 Persona",
    "2 Personas",
    "3 Personas",
    "4 Personas",
    "5 Personas",
    "6+ Personas",
  ];

  final List<String> timeOptions = [
    "12:00 PM",
    "1:00 PM",
    "2:00 PM",
    "3:00 PM",
    "7:00 PM",
    "8:00 PM",
    "9:00 PM",
  ];

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
  }

  void submitReservation() async {

    if (!formKey.currentState!.validate()) return;

    if (selectedDate == null) {
      showError("Selecciona una fecha");
      return;
    }

    if (selectedPeople == null) {
      showError("Selecciona el número de personas");
      return;
    }

    if (selectedTime == null) {
      showError("Selecciona una hora");
      return;
    }

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => isLoading = false);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TweenAnimationBuilder(
                  tween: Tween(begin: 0.5, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 60,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "¡Reserva enviada!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Tu solicitud fue enviada exitosamente.\nTe contactaremos pronto.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Aceptar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.all(18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.brown,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //  HEADER
                Row(
                  children: [

                    // LOGO
                    Image.asset(
                      "assets/logo.png",
                      width: 90,
                    ),

                    const Spacer(),

                    // CERRAR
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Center(
                  child: Column(
                    children: [

                      Text(
                        "Reservaciones",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        "Reserve su mesa y disfrute una experiencia gastronómica inolvidable",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Haga su reserva",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 30),

                      //  NOMBRE
                      TextFormField(
                        controller: nameController,
                        decoration:
                            inputDecoration("Ingrese su nombre completo"),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Ingresa tu nombre";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      //  EMAIL
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            inputDecoration("Ingrese su correo electrónico"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Ingresa tu correo";
                          }

                          if (!isValidEmail(value)) {
                            return "Correo inválido";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      //  TELÉFONO
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration:
                            inputDecoration("Ingrese su teléfono"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Ingresa tu teléfono";
                          }

                          if (value.length < 9) {
                            return "Número inválido";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      //  PERSONAS
                      DropdownButtonFormField<String>(
                        value: selectedPeople,
                        decoration: inputDecoration("Número de personas"),
                        items: peopleOptions.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPeople = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      //  FECHA
                      GestureDetector(
                        onTap: pickDate,
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month),

                              const SizedBox(width: 10),

                              Text(
                                selectedDate == null
                                    ? "Seleccionar fecha"
                                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      //  HORA
                      DropdownButtonFormField<String>(
                        value: selectedTime,
                        decoration: inputDecoration("Selecciona una hora"),
                        items: timeOptions.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTime = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      //  MENSAJE
                      TextFormField(
                        controller: messageController,
                        maxLines: 4,
                        decoration: inputDecoration(
                          "Solicitud especial o comentario",
                        ),
                      ),

                      const SizedBox(height: 30),

                      //  BOTÓN
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                          ),
                          onPressed: isLoading
                              ? null
                              : submitReservation,
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Enviar Reserva",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}