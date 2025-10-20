import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thong Ke"),
      ),
      body: Center(
        child: Text("day la trang thong ke"),
      ),
    );
  }
}