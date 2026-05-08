import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _name = "";
  String _email = "";
  String _phone = "";
  String _address1 = "";
  String _address2 = "";

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get address1 => _address1;
  String get address2 => _address2;

  //  SET COMPLETO (correo)
  void setUser(String name, String email) {
    _name = name;
    _email = email;
    notifyListeners();
  }

  //  ACTUALIZAR DATOS DE CONFIGURACIÓN
  void updateUserInfo({
    String? name,
    String? email,
    String? phone,
    String? address1,
    String? address2,
  }) {
    if (name != null) _name = name;
    if (email != null) _email = email;
    if (phone != null) _phone = phone;
    if (address1 != null) _address1 = address1;
    if (address2 != null) _address2 = address2;
    notifyListeners();
  }

  //  SOLO NOMBRE Y CELULAR (flujo celular)
  void setUserNameAndPhone(String name, String phone) {
    _name = name;
    _phone = phone;
    notifyListeners();
  }

  //  SOLO EMAIL (por si lo necesitas)
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  //  LIMPIAR SESIÓN
  void clearUser() {
    _name = "";
    _email = "";
    _phone = "";
    _address1 = "";
    _address2 = "";
    notifyListeners();
  }
}