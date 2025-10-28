// lib/screens/habit_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Import
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
import 'completion_screen.dart';

DateTime _dateOnly(DateTime dt) {
  return DateTime(dt.year, dt.month, dt.day);
}

class HabitDetailScreen extends StatefulWidget {
  final String habitId;

  const HabitDetailScreen({Key? key, required this.habitId}) : super(key: key);

  @override
  _HabitDetailScreenState createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  // Biến state để quản lý ngày đang được chọn trên lịch
  DateTime _focusedDay = _dateOnly(DateTime.now());
  DateTime? _selectedDay = _dateOnly(DateTime.now());

  // Hàm xử lý khi nhấn nút Xóa
  void _confirmDelete(BuildContext context, HabitProvider provider, Habit habit, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteHabit),
        content: Text(l10n.deleteHabitConfirm),
        actions: [
          TextButton(
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          FilledButton( // Dùng FilledButton (M3) cho nổi bật
            child: Text(l10n.delete),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            onPressed: () {
              provider.deleteHabit(habit.id);
              Navigator.of(ctx).pop(); // Đóng Dialog
              Navigator.of(context).pop(); // Quay về màn hình danh sách
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Dùng 'Consumer' để lấy dữ liệu VÀ tự động build lại khi tick
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        // Lấy thông tin thói quen mới nhất
        final habit = provider.getHabitById(widget.habitId);
        final today = _dateOnly(DateTime.now());

        return Scaffold(
          appBar: AppBar(
            title: Text(habit.name),
            centerTitle: true,
            // (MỚI) Nút Xóa (Hủy)
            actions: [
              IconButton(
                icon: Icon(Icons.delete_outline),
                tooltip: l10n.deleteHabit,
                onPressed: () => _confirmDelete(context, provider, habit, l10n),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- (MỚI) Thẻ Thông tin Thống kê ---
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildStatRow(
                          context,
                          icon: Icons.local_fire_department,
                          iconColor: Colors.orange,
                          label: l10n.currentStreak,
                          value: "${habit.streak} ${l10n.day}s",
                        ),
                        _buildStatRow(
                          context,
                          icon: Icons.calendar_today,
                          iconColor: Colors.blue,
                          label: l10n.startDate,
                          value: DateFormat.yMMMd(l10n.localeName).format(habit.startDate),
                        ),
                        _buildStatRow(
                          context,
                          icon: Icons.alarm,
                          iconColor: Colors.purple,
                          label: l10n.reminder,
                          value: habit.reminderTime?.format(context) ?? l10n.noReminderSet,
                        ),
                        // Chỉ hiển thị tiến độ cho loại 'Challenge'
                        if (habit.type == HabitType.challenge)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${l10n.progress} (${habit.completionLog.values.where((v) => v).length}/${habit.totalDays})",
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                LinearPercentIndicator(
                                  percent: habit.progress,
                                  lineHeight: 12.0,
                                  backgroundColor: Colors.grey.shade300,
                                  progressColor: theme.colorScheme.primary,
                                  barRadius: Radius.circular(6.0),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // --- (MỚI) LỊCH (TableCalendar) ---
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TableCalendar(
                      locale: l10n.localeName, // Hỗ trợ ngôn ngữ cho Lịch
                      firstDay: habit.startDate, // Chỉ cho phép xem từ ngày bắt đầu
                      lastDay: today.add(Duration(days: 365)), // Giới hạn 1 năm
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      
                      // (QUAN TRỌNG) Đánh dấu các ngày đã hoàn thành
                      eventLoader: (day) {
                        if (habit.completionLog[_dateOnly(day)] == true) {
                          return ["completed"]; // Trả về 1 sự kiện
                        }
                        return []; // Không có sự kiện
                      },

                      // (QUAN TRỌNG) Xử lý khi nhấn vào 1 ngày
                      onDaySelected: (selectedDay, focusedDay) {
                        // Không cho phép tick vào ngày tương lai
                        if (selectedDay.isAfter(today)) {
                          return;
                        }
                        
                        // Gọi hàm toggle mới trong provider
                        provider.toggleDateCompletion(habit.id, selectedDay);
                        
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      
                      // --- (Style Lịch) ---
                      calendarStyle: CalendarStyle(
                        // Style cho các ngày có sự kiện (đã hoàn thành)
                        markerDecoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        // Style cho ngày 'hôm nay'
                        todayDecoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                        // Style cho ngày 'đang chọn'
                        selectedDecoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false, // Ẩn nút "2 Weeks"
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget helper để vẽ 1 hàng thống kê
  Widget _buildStatRow(BuildContext context, {required IconData icon, required Color iconColor, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}