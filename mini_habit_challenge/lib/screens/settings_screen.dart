// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Lấy l10n và provider
    final l10n = AppLocalizations.of(context)!;
    // Dùng 'watch' để lắng nghe thay đổi và tự động cập nhật UI
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // --- 1. CÀI ĐẶT NGÔN NGỮ ---
          _buildSettingsSection(
            context,
            icon: Icons.language,
            title: l10n.language,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Locale>(
                // Giá trị hiện tại
                value: settings.locale,
                isExpanded: true,
                items: [
                  // Lựa chọn Tiếng Việt
                  DropdownMenuItem(
                    value: Locale('vi'),
                    child: Text(l10n.vietnamese),
                  ),
                  // Lựa chọn Tiếng Anh
                  DropdownMenuItem(
                    value: Locale('en'),
                    child: Text(l10n.english),
                  ),
                ],
                // Hàm gọi khi thay đổi
                onChanged: (newLocale) {
                  settings.updateLocale(newLocale);
                },
              ),
            ),
          ),

          SizedBox(height: 20),

          // --- 2. CÀI ĐẶT GIAO DIỆN ---
          _buildSettingsSection(
            context,
            icon: Icons.brightness_6_outlined,
            title: l10n.appearance,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ThemeMode>(
                // Giá trị hiện tại
                value: settings.themeMode,
                isExpanded: true,
                items: [
                  // Lựa chọn Sáng
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(l10n.light),
                  ),
                  // Lựa chọn Tối
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(l10n.dark),
                  ),
                  // Lựa chọn Hệ thống
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(l10n.system),
                  ),
                ],
                // Hàm gọi khi thay đổi
                onChanged: (newThemeMode) {
                  settings.updateThemeMode(newThemeMode);
                },
              ),
            ),
          ),
          
          // (Bạn có thể thêm các mục cài đặt khác ở đây)
        ],
      ),
    );
  }

  // Widget helper để tạo 1 mục cài đặt (Tiêu đề + Widget con)
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
        // Bọc widget con trong 1 cái Card cho đẹp
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