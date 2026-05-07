import 'package:casa_colina_app/presentation/screens/login_screen.dart';
import 'package:casa_colina_app/providers/cart_provider.dart';
import 'package:casa_colina_app/providers/favorite_provider.dart';
import 'package:casa_colina_app/providers/payment_provider.dart';
import 'package:casa_colina_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/home_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();    

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔔 CONFIGURACIÓN ANDROID
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings settings =
      InitializationSettings(android: androidSettings);

  await notificationsPlugin.initialize(settings);

  // 🔥 PEDIR PERMISO (Android 13+)
  await notificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'orders_channel',
    'Pedidos',
    description: 'Notificaciones de pedidos',
    importance: Importance.max,
  );

  await notificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Casa Colina',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      navigatorKey: navigatorKey, // 👈 🔥 CLAVE
      home: const LoginScreen(),
    );
  }
}