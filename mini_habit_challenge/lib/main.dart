import 'package:flutter/material.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context){
        return AppLocalizations.of(context)!.appName;
      },
      //cau hinh ngon ngu
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales:[
        Locale('vi', ''),
        Locale('en', ''),
      ],

      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
