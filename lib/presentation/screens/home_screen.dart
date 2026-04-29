import 'package:flutter/material.dart';
import '../screens/menu_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/order_screen.dart';
import '../screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialTab;

  const HomeScreen({super.key, this.initialTab = 0});

  static _HomeScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<_HomeScreenState>();
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int currentIndex;

  final List<Widget> screens = [
    const MenuScreen(),
    const CartScreen(),
    const OrderScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialTab;
  }

   // 👇 método para cambiar de tab
  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.brown,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Menú"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Carrito"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Pedido"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}