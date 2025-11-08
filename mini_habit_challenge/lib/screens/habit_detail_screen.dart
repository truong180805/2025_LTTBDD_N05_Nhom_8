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

  const HabitDetailScreen({super.key,required this.habitId});

  @override
  _HabitDetailScreenState createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  DateTime _focusedDay = _dateOnly(DateTime.now());
  DateTime? _selectedDay = _dateOnly(DateTime.now());

  //ham xoa thoi quen
  void _confirmDelete(BuildContext context, HabitProvider provider, Habit habit, AppLocalizations l10n) {
    showDialog(//hien thi cua so 
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteHabit),
        content: Text(l10n.deleteHabitConfirm),
        actions: [

          TextButton(
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            onPressed: () => Navigator.of(ctx).pop(),
          ),

          FilledButton( 
            child: Text(l10n.delete),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            onPressed: () {
              provider.deleteHabit(habit.id);
              Navigator.of(ctx).pop(); 
              Navigator.of(context).pop(); 
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

    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        final habit = provider.getHabitById(widget.habitId);
        final today = _dateOnly(DateTime.now());

        //kiem tra xem thoi quen da hoan thanh chua
        if (provider.justCompletedHabit != null && provider.justCompletedHabit!.id == habit.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement( 
              context,
              MaterialPageRoute(
                builder: (context) => CompletionScreen(
                  habitName: provider.justCompletedHabit!.name
                ),
              ),
            );
            provider.clearJustCompletedHabit();
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(habit.name),
            centerTitle: true,

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

                        //neu la thu thach thi hien thi tien do
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

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    //hien thi lich co the tick
                    child: TableCalendar(
                      locale: l10n.localeName, 
                      firstDay: habit.startDate, 
                      lastDay: today.add(Duration(days: 365)), 
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      
                      //danh dau ngay hoan thanh
                      eventLoader: (day) {
                        if (habit.completionLog[_dateOnly(day)] == true) {
                          return ["completed"]; 
                        }
                        return []; 
                      },

                      //khi an vao 1 ngay goi ham tick/bo tick
                      onDaySelected: (selectedDay, focusedDay) {
                        provider.toggleDateCompletion(habit.id, selectedDay);
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      
                      calendarStyle: CalendarStyle(//cham tron cho ngay hoan thanh
                        markerDecoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        
                        todayDecoration: BoxDecoration(//nen cho ngay hom nay
                          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                        
                        selectedDecoration: BoxDecoration(//ngay minh chon
                          color: theme.colorScheme.primary.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                      ),

                      headerStyle: HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false, 
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //nut tick co goi ham tick
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              provider.toggleTodayCompletion(habit.id);
            },
            label: Text(
              habit.isCompletedToday ? "Đã tick Hôm nay" : "Tick Hôm nay",
            ),
            icon: Icon(
              habit.isCompletedToday ? Icons.check_box : Icons.check_box_outline_blank
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