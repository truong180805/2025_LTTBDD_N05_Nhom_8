// lib/screens/statistics_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Import
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<HabitProvider>();
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3, 
      child: Column(
        children: [
          // --- 1. THANH LỌC (TABBAR) ---
          TabBar(
            labelColor: theme.colorScheme.primary, 
            unselectedLabelColor: theme.textTheme.bodySmall?.color,
            tabs: [
              Tab(text: l10n.overall),
              Tab(text: l10n.daily),
              Tab(text: l10n.challenges),
            ],
          ),

          // --- 2. NỘI DUNG TABS ---
          Expanded(
            child: TabBarView(
              children: [
                // --- Tab 1: TỔNG QUAN ---
                _buildOverallPane(context, provider, l10n),

                // --- Tab 2: HÀNG NGÀY ---
                _buildHabitListPane(context, provider.dailyHabits, l10n), // <--- SỬA LỖI 1: Thêm 'context'

                // --- Tab 3: THỬ THÁCH ---
                _buildChallengePane(context, provider, l10n), // <--- SỬA LỖI 2: Thêm 'context'
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Helper cho các Tab ---

  // Vòng tròn Tiến độ Tổng (cho Tab 1)
  Widget _buildOverallGauge(BuildContext context, HabitProvider provider, AppLocalizations l10n) {
    // (Hàm này không thay đổi)
    final theme = Theme.of(context);
    final progress = provider.overallTodayProgress;
    final progressPercent = (progress * 100).toStringAsFixed(1);

    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          l10n.todaysProgress,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        CircularPercentIndicator(
          radius: 90.0,
          lineWidth: 18.0,
          percent: progress,
          center: Text(
            "$progressPercent %",
            style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surfaceVariant,
        ),
        SizedBox(height: 12),
        Text(
          "${provider.habits.where((h) => h.isCompletedToday).length}/${provider.habits.length} ${l10n.tabChallenges}",
          style: theme.textTheme.titleMedium,
        ),
      ],
    );
  }

  // Danh sách tiến độ (cho Tab 1, 2, 3)
  Widget _buildHabitProgressList(BuildContext context, List<Habit> habits, AppLocalizations l10n) { // <--- SỬA LỖI 3: Thêm 'BuildContext context'
    if (habits.isEmpty) {
      return Center(child: Text("Không có thói quen nào."));
    }
    
    return Column(
      children: habits.map((habit) {
        return Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Theme.of(context).dividerColor), // <--- Chỗ này cần 'context'
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(habit.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                
                if (habit.type == HabitType.challenge)
                  Row(
                    children: [
                      Expanded(
                        child: LinearPercentIndicator(
                          percent: habit.progress,
                          lineHeight: 10.0,
                          barRadius: Radius.circular(5),
                          progressColor: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("${(habit.progress * 100).toStringAsFixed(0)}%")
                    ],
                  )
                else
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, color: Colors.orange),
                      SizedBox(width: 8),
                      Text("${habit.streak} ${l10n.day}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Danh sách Thử thách đã hoàn thành (cho Tab 3)
  Widget _buildCompletedList(List<Habit> completedHabits, AppLocalizations l10n, ThemeData theme) {
    // (Hàm này không thay đổi)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.completedChallenges,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        if (completedHabits.isEmpty)
          Center(child: Text("Chưa có thử thách nào hoàn thành."))
        else
          ...completedHabits.map((habit) => Card(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text(habit.name, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Đã hoàn thành ${habit.totalDays} ngày"),
            ),
          )).toList(),
      ],
    );
  }

  // --- Các Widget Pane chính ---

  // Tab 1: Tổng quan (Gauge + Tất cả thói quen)
  Widget _buildOverallPane(BuildContext context, HabitProvider provider, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildOverallGauge(context, provider, l10n),
        SizedBox(height: 32),
        Text(
          l10n.activeHabits,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildHabitProgressList(context, provider.habits, l10n), // <--- SỬA LỖI 4: Thêm 'context'
      ],
    );
  }

  // Tab 2: Hàng ngày (Chỉ danh sách Hàng ngày)
  Widget _buildHabitListPane(BuildContext context, List<Habit> dailyHabits, AppLocalizations l10n) { // <--- SỬA LỖI 5: Thêm 'BuildContext context'
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildHabitProgressList(context, dailyHabits, l10n), // <--- SỬA LỖI 6: Thêm 'context'
      ],
    );
  }
  
  // Tab 3: Thử thách (DS Thử thách + DS Hoàn thành)
  Widget _buildChallengePane(BuildContext context, HabitProvider provider, AppLocalizations l10n) { // <--- SỬA LỖI 7: Thêm 'BuildContext context'
    final theme = Theme.of(context);
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          l10n.activeHabits,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildHabitProgressList(context, provider.challengeHabits, l10n), // <--- SỬA LỖI 8: Thêm 'context'
        SizedBox(height: 32),
        _buildCompletedList(provider.completedHabits, l10n, theme),
      ],
    );
  }
}