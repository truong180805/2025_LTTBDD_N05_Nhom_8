// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          "Đây là trang Hồ sơ, đang được xây dựng.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
  }
}