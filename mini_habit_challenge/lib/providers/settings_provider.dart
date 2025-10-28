// lib/providers/settings_provider.dart
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  // 1. Quản lý Theme (chế độ Sáng/Tối)
  ThemeMode _themeMode = ThemeMode.system; // Mặc định: theo hệ thống
  ThemeMode get themeMode => _themeMode;

  void updateThemeMode(ThemeMode? newMode) {
    if (newMode == null || newMode == _themeMode) return;
    _themeMode = newMode;
    notifyListeners();
    // TODO: Lưu cài đặt này vào bộ nhớ (sẽ làm sau)
  }

  // 2. Quản lý Ngôn ngữ
  Locale _locale = Locale('vi'); // Mặc định: Tiếng Việt
  Locale get locale => _locale;

  void updateLocale(Locale? newLocale) {
    if (newLocale == null || newLocale == _locale) return;
    _locale = newLocale;
    notifyListeners();
    // TODO: Lưu cài đặt này vào bộ nhớ (sẽ làm sau)
  }
}