import 'package:flutter/material.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
  
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabStatistics),
      ),
      body: Center(
        child: Text(l10n.tabStatistics),
      ),
    );
  }
}