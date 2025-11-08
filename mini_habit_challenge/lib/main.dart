import 'package:flutter/material.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/welcome_screen.dart';
import 'providers/habit_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/profile_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HabitProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          onGenerateTitle: (context) {
            return AppLocalizations.of(context)!.appName;
          },
          
          locale: settingsProvider.locale, 
          
          themeMode: settingsProvider.themeMode, 

          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('vi', ''), 
            Locale('en', ''), 
          ],
          
          debugShowCheckedModeBanner: false,
          //cau hinh che do sang
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.amber,
              brightness: Brightness.light,
            ),
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),

          //cau hinh che do toi
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.amber,
              brightness: Brightness.dark, 
            ),
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
