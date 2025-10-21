import 'package:flutter/material.dart';
import 'challenge_list_screen.dart';
import 'statistics_screen.dart';
import 'about_screen.dart';

import 'package:mini_habit_challenge/l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ChallengeListScreen(),
    StatisticsScreen(),
    AboutScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(

      body:  IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: 
          Icon(Icons.check_circle_outline),
          label: l10n.tabChallenges),
          BottomNavigationBarItem(icon: 
          Icon(Icons.bar_chart),
          label: l10n.tabStatistics),
          BottomNavigationBarItem(icon: 
          Icon(Icons.info_outline),
          label: l10n.tabAbout)
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        ),
    );
  }
}