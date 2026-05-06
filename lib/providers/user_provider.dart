import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _name = "";
  String _email = "";

  String get name => _name;
  String get email => _email;

  // 🔥 SET COMPLETO (correo)
  void setUser(String name, String email) {
    _name = name;
    _email = email;
    notifyListeners();
  }

  // 🔥 SOLO NOMBRE (flujo celular)
  void setUserName(String name) {
    _name = name;
    notifyListeners();
  }

  // 🔥 SOLO EMAIL (por si lo necesitas)
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  // 🔥 LIMPIAR SESIÓN
  void clearUser() {
    _name = "";
    _email = "";
    notifyListeners();
  }
}