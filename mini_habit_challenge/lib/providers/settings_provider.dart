import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  //ham doi che do sang/toi
  void updateThemeMode(ThemeMode? newMode) {
    if (newMode == null || newMode == _themeMode) return;
    _themeMode = newMode;
    notifyListeners();
  }

  Locale _locale = Locale('vi');
  Locale get locale => _locale;

  //ham thay doi ngon ngu vi/en
  void updateLocale(Locale? newLocale) {
    if (newLocale == null || newLocale == _locale) return;
    _locale = newLocale;
    notifyListeners();
  }

  //ham reset cai dat
  void resetSettings() {
    _themeMode = ThemeMode.system; 
    _locale = Locale('vi'); 
    notifyListeners();
  }
}