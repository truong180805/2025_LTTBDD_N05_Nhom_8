// lib/providers/profile_provider.dart
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  String? _name;
  DateTime? _dob; // Date of Birth (Ngày sinh)
  double? _weight; // kg
  double? _height; // cm

  // Getters (Hàm lấy dữ liệu)
  String? get name => _name;
  DateTime? get dob => _dob;
  double? get weight => _weight;
  double? get height => _height;

  // Hàm để cập nhật và lưu hồ sơ
  void updateProfile({
    String? name,
    DateTime? dob,
    double? weight,
    double? height,
  }) {
    _name = name;
    _dob = dob;
    _weight = weight;
    _height = height;

    // Thông báo cho UI cập nhật
    notifyListeners();
  }

  void resetProfile() {
    _name = null;
    _dob = null;
    _weight = null;
    _height = null;
    notifyListeners();
  }
}