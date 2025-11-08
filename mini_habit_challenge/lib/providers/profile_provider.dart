import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  String? _name;
  DateTime? _dob; 
  double? _weight; 
  double? _height;

  //lay du lieu
  String? get name => _name;
  DateTime? get dob => _dob;
  double? get weight => _weight;
  double? get height => _height;

  //ham cap nhat ho so
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

    notifyListeners();
  }

  //ham reset ho so
  void resetProfile() {
    _name = null;
    _dob = null;
    _weight = null;
    _height = null;
    notifyListeners();
  }
}