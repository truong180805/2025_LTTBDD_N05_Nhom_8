import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
      
          _buildSettingsSection(
            context,
            icon: Icons.language,
            title: l10n.language,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Locale>(
                value: settings.locale,
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    value: Locale('vi'),
                    child: Text(l10n.vietnamese),
                  ),
                  
                  DropdownMenuItem(
                    value: Locale('en'),
                    child: Text(l10n.english),
                  ),
                ],
                
                onChanged: (newLocale) {
                  settings.updateLocale(newLocale);
                },
              ),
            ),
          ),

          SizedBox(height: 20),

         
          _buildSettingsSection(
            context,
            icon: Icons.brightness_6_outlined,
            title: l10n.appearance,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ThemeMode>(
                value: settings.themeMode,
                isExpanded: true,
                items: [
                  
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(l10n.light),
                  ),
                  
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(l10n.dark),
                  ),
                  
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(l10n.system),
                  ),
                ],
                
                onChanged: (newThemeMode) {
                  settings.updateThemeMode(newThemeMode);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper cho cac cai dat
  Widget _buildSettingsSection(BuildContext context, {required IconData icon, required String title, required Widget child}) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 20),
            SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.dividerColor),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: child,
          ),
        ),
      ],
    );
  }
}