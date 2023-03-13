import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const localeList = ["en", "zh"];
const themeList = [Brightness.light, Brightness.dark];

class CurrentSettings with ChangeNotifier {
  Locale _locale = const Locale('en');
  Brightness _theme = Brightness.light;

  String _localeString = 'en';
  String _themeString = '0';

  String get localeString => _localeString;
  String get themeString => _themeString;

  Locale get locale => _locale;
  Brightness get theme => _theme;

  late SharedPreferences prefs;

  CurrentSettings() {
    loadSettings();
  }

  void loadSettings() async {
    prefs = await SharedPreferences.getInstance();
    _localeString = prefs.getString('locale') ?? 'en';
    _locale = Locale(_localeString);
    _themeString = prefs.getString('theme') ?? '0';
    _theme = themeList[int.parse(_themeString)];
    notifyListeners();
  }

  void setLocale(String locale) {
    _localeString = locale;
    _locale = Locale(locale);
    notifyListeners();
    prefs.setString('locale', locale);
  }
  void setTheme(String value) {
    _themeString = value;
    _theme = themeList[int.parse(value)];
    notifyListeners();
    prefs.setString('theme', value);
  }
}
