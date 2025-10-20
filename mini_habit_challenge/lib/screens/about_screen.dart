import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thong tin"),
      ),
      body: Center(
        child: Text("Day la trang thong tin"),
      ),
    );
  }
}