// lib/screens/about_screen.dart
import 'package:flutter/material.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context); // Lấy theme để style

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabAbout), // "Thông tin"
        centerTitle: true,
      ),
      // Dùng Center để căn giữa toàn bộ nội dung
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // Căn giữa theo chiều dọc
            mainAxisAlignment: MainAxisAlignment.center, 
            // Căn giữa theo chiều ngang
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              // 1. Icon (cho đẹp mắt)
              Icon(
                Icons.school_outlined, // Icon học đường
                size: 80,
                color: theme.colorScheme.primary,
              ),
              SizedBox(height: 24),

              // 2. Thông điệp dự án
              Text(
                "Đây là dự án Bài tập lớn",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                "Học phần: Lập trình Thiết bị Di động",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.secondary, // Màu phụ
                ),
                textAlign: TextAlign.center,
              ),
              
              // Đường kẻ phân cách
              Divider(height: 48, thickness: 1, indent: 40, endIndent: 40),

              // 3. Thông tin chi tiết
              _buildInfoRow(context, "Người xây dựng:", "Nguyễn Văn Trường"),
              _buildInfoRow(context, "Mã sinh viên:", "23010371"),
              _buildInfoRow(context, "Giảng viên hướng dẫn:", "Nguyễn Xuân Quế"),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper để vẽ một hàng thông tin (Label + Value)
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        // Căn giữa text trong cột
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          // Phần "Label" (chữ nhỏ, mờ)
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant, // Màu xám
            ),
          ),
          // Phần "Value" (chữ to, đậm)
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}