import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              const Text(
                "🎯", 
                style: TextStyle(fontSize: 120),
              ),
              const SizedBox(height: 40),

              Text(
                l10n.welcomeTo,
                style: theme.textTheme.headlineSmall,
              ),
              Text(
                l10n.appName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.welcomeMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),

              const Spacer(flex: 3),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _navigateToHome(context),

                  style: ElevatedButton.styleFrom(
                  
                    backgroundColor: const Color(0xFF333333),
         
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(l10n.getStarted),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
