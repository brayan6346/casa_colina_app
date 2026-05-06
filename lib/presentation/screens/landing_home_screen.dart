import 'package:casa_colina_app/presentation/screens/home_screen.dart';
import 'package:casa_colina_app/presentation/screens/reservation_screen.dart';
import 'package:flutter/material.dart';

class LandingHomeScreen extends StatelessWidget {
  const LandingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // 🔥 HERO (IMAGEN PRINCIPAL)
              Stack(
                children: [
                  SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: Image.asset(
                      "assets/Rectangle.jpg", // 👈 tu imagen
                      fit: BoxFit.cover,
                    ),
                  ),

                  // overlay oscuro
                  Container(
                    height: 500,
                    color: Colors.black.withOpacity(0.5),
                  ),

                  // contenido
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Sabores con historia,\ntradición con estilo",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Una experiencia gastronómica única",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  // botones
                  Positioned(
                    bottom: 60,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            // 🔥 VER MENÚ
                            AnimatedButton(
                              color: Colors.brown,
                              onTap: () {
                                HomeScreen.of(context)?.changeTab(1);
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.restaurant_menu, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    "Ver Menú",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 15),

                            // 🔥 RESERVAR
                            AnimatedButton(
                              outlined: true,
                              color: Colors.white,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ReservationScreen(),
                                  ),
                                );
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.calendar_month, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    "Reservar",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),

              // 🔥 ACERCA DE
              Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    const Text(
                      "Acerca de Nosotros",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // imagen
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/fire.png",
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        // texto
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "Nuestra Historia",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                "Casa Colina nació en 2010 combinando tradición y modernidad.",
                              ),

                              SizedBox(height: 10),

                              Text(
                                "Misión",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),

                              Text(
                                "Brindar una experiencia gastronómica única.",
                              ),

                              SizedBox(height: 10),

                              Text(
                                "Visión",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),

                              Text(
                                "Ser un referente culinario en la ciudad.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 🔥 HORARIOS
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    const Text(
                      "Horarios y Ubicación",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [

                        // horarios
                        Expanded(
                          child: _card(
                            title: "Horarios",
                            content:
                                "Lunes - Jueves: 12:00 - 22:00\nViernes - Sábado: 12:00 - 23:00\nDomingo: 12:00 - 20:00",
                          ),
                        ),

                        const SizedBox(width: 10),

                        // ubicación
                        Expanded(
                          child: _card(
                            title: "Ubicación",
                            content:
                                "Av. Principal 123\nMiraflores\nLima, Perú",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),  
    );
  }

  Widget _card({required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(content, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color color;
  final bool outlined;

  const AnimatedButton({
    super.key,
    required this.child,
    required this.onTap,
    required this.color,
    this.outlined = false,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double scale = 1;

  void _animate(bool pressed) {
    setState(() {
      scale = pressed ? 0.95 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animate(true),
      onTapUp: (_) => _animate(false),
      onTapCancel: () => _animate(false),
      onTap: widget.onTap,

      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 16,
          ),

          decoration: BoxDecoration(
            color: widget.outlined ? Colors.transparent : widget.color,
            borderRadius: BorderRadius.circular(40),

            border: widget.outlined
                ? Border.all(color: Colors.white, width: 1.5)
                : null,

            boxShadow: [
              if (!widget.outlined)
                BoxShadow(
                  color: widget.color.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
            ],
          ),

          child: widget.child,
        ),
      ),
    );
  }
}