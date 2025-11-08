import 'package:flutter/material.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context); 

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabAbout), 
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            //can giua theo truc doc
            mainAxisAlignment: MainAxisAlignment.center, 
            //can giua theo truc ngang
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              Icon(
                Icons.school_outlined,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              SizedBox(height: 24),

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
                  color: theme.colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              //duong ke phan cach
              Divider(height: 48, thickness: 1, indent: 40, endIndent: 40),

              //thong tin chi tiet
              _buildInfoRow(context, "Người xây dựng:", "Nguyễn Văn Trường"),
              _buildInfoRow(context, "Mã sinh viên:", "23010371"),
              _buildInfoRow(context, "Giảng viên hướng dẫn:", "Nguyễn Xuân Quế"),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper de dinh dang form cho chuoi ky tu(labe,value)
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,//mau xam
            ),
          ),
  
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