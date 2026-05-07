import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  String _cardNumber = "";
  String _expiryDate = "";
  String _cvv = "";
  String _cardHolderName = "";

  String get cardNumber => _cardNumber;
  String get expiryDate => _expiryDate;
  String get cvv => _cvv;
  String get cardHolderName => _cardHolderName;

  void saveCard(String number, String expiry, String cvvCode, String name) {
    _cardNumber = number;
    _expiryDate = expiry;
    _cvv = cvvCode;
    _cardHolderName = name;
    notifyListeners();
  }

  void clearCard() {
    _cardNumber = "";
    _expiryDate = "";
    _cvv = "";
    _cardHolderName = "";
    notifyListeners();
  }
}
