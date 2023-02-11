import 'package:flutter/material.dart';

class CurrentLocale with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get value => _locale;

  void setLocale(locale) {
    _locale = locale;
    notifyListeners();
  }
}
