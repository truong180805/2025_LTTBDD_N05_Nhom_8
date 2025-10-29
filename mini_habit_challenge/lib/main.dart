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
          
          // --- (PHẦN CẬP NHẬT QUAN TRỌNG) ---
          
          // 4. Lắng nghe Ngôn ngữ
          locale: settingsProvider.locale, 
          
          // 5. Lắng nghe Chế độ Sáng/Tối
          themeMode: settingsProvider.themeMode, 
          
          // --- (HẾT PHẦN CẬP NHẬT) ---

          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('vi', ''), // Tiếng Việt
            Locale('en', ''), // Tiếng Anh
          ],
          
          debugShowCheckedModeBanner: false,

          // --- (Theme Sáng - Light) ---
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.amber,
              brightness: Brightness.light,
            ),
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),

          // --- (Theme Tối - Dark) ---
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.amber,
              brightness: Brightness.dark, // <-- Chế độ tối
            ),
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
