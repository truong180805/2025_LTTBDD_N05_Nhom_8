import 'package:flutter/material.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    // Dùng 'watch' để lắng nghe thay đổi
    final provider = context.watch<HabitProvider>(); 
    final completedHabits = provider.completedHabits;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabStatistics),
        automaticallyImplyLeading: false, 
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // --- (PHẦN MỚI) ---
          Text(
            "Thử thách đã hoàn thành", // (Sẽ thêm l10n sau)
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          
          if (completedHabits.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Chưa có thử thách nào hoàn thành."),
              ),
            )
          else
            // Xây dựng danh sách từ _completedHabits
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: completedHabits.length,
              itemBuilder: (context, index) {
                final habit = completedHabits[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green, size: 30),
                    title: Text(habit.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Đã hoàn thành ${habit.totalDays} ngày"),
                  ),
                );
              },
            ),

          // (Bạn có thể thêm các thống kê khác ở đây sau)
          // Ví dụ: Thống kê chuỗi, v.v.
        ],
      ),
    );
  }
}