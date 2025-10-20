import 'package:flutter/material.dart';

class ChallengeListScreen extends StatelessWidget {
  const ChallengeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thu thach'),
      ),
      body: Center(
        child: Text("Day la trang thu thach"),
      ),
    );
  }
}