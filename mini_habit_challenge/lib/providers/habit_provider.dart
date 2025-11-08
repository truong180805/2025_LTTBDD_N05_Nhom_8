import 'package:flutter/material.dart';
import '../models/habit.dart';

//ham chi lay ngay thang nam
DateTime _dateOnly(DateTime dt) {
  return DateTime(dt.year, dt.month, dt.day);
}

class HabitProvider with ChangeNotifier {
   List<Habit> _habits = [
    Habit(
      name: "Uống 2 lít nước",
      type: HabitType.daily,
      startDate: DateTime.now().subtract(Duration(days: 2)),
      reminderTime: TimeOfDay(hour: 8, minute: 0),
    ),
    Habit(
      name: "Thử thách 7 ngày đọc sách",
      type: HabitType.challenge,
      startDate: DateTime.now().subtract(Duration(days: 1)),
      totalDays: 7,
      reminderTime: TimeOfDay(hour: 21, minute: 0),
    ),
  ];

  List<Habit> _completedHabits = [];
  Habit? _justCompletedHabit;

  //tra ve thoi quen da hoan thanh
  List<Habit> get completedHabits => _completedHabits;

  //tinh chuoi dai nhat
  int get longestOverallStreak {
  if (_habits.isEmpty) return 0;

  int longestStreak = 0;
  
  for (final habit in _habits) {
    if (habit.streak > longestStreak) {
      longestStreak = habit.streak; 
    }
  }
  return longestStreak;
  }

  //tinh tien do cac thoi quen hom nay
  double get overallTodayProgress {
  if (_habits.isEmpty) return 0;
  final completedToday = _habits.where((h) => h.isCompletedToday).length;
  return completedToday / _habits.length;
}
  //tra ve thoi quen vua hoan thanh
  Habit? get justCompletedHabit => _justCompletedHabit;

  //clear thoi quen vua hoan thanh
  void clearJustCompletedHabit() {
    _justCompletedHabit = null;
  }

  //xu ly trang thai khi 1 thu thach hoan thanh
  void _handleHabitCompletionCheck(Habit habit) {
    if (habit.isChallengeFullyCompleted) { 
      _habits.remove(habit); 
      _completedHabits.add(habit);
      _justCompletedHabit = habit; 
    }
  }

  //tra ve toan bo danh sach thoi quen
  List<Habit> get habits => _habits;
  
  //loc ra chi thoi quen hang ngay
  List<Habit> get dailyHabits {
    return _habits.where((h) => h.type == HabitType.daily).toList();
  }

  //loc ra chi thu thach
  List<Habit> get challengeHabits {
     return _habits.where((h) => h.type == HabitType.challenge).toList();
  }

  //ham lay thoi quen theo id
  Habit getHabitById(String habitId) {
    return _habits.firstWhere((h) => h.id == habitId);
  }

  //ham them mot thoi quen
  void addHabit({
    required String name,
    required HabitType type,
    int? totalDays,
    TimeOfDay? reminderTime,
  }) {
    final newHabit = Habit(
      name: name,
      type: type,
      startDate: _dateOnly(DateTime.now()), 
      totalDays: type == HabitType.challenge ? totalDays : null,
      reminderTime: reminderTime,
    );
    _habits.add(newHabit);
    notifyListeners();
  }

  //ham tick/bo tick hom nay
  void toggleTodayCompletion(String habitId) {
    try {
      final habit = getHabitById(habitId);
      final today = _dateOnly(DateTime.now());
      final bool isCompleted = habit.completionLog[today] ?? false;
      habit.completionLog[today] = !isCompleted;
      _handleHabitCompletionCheck(habit);
      notifyListeners();
    } catch (e) {
      print("Lỗi khi toggle ngày: $e");
    }
  }

  //tick mot ngay bat ky
  void toggleDateCompletion(String habitId, DateTime date) {
    try {
      final habit = getHabitById(habitId);
      final dateOnly = _dateOnly(date); 
      final bool isCompleted = habit.completionLog[dateOnly] ?? false;
      habit.completionLog[dateOnly] = !isCompleted;
      _handleHabitCompletionCheck(habit);
      notifyListeners();
    } catch (e) {
      print("Lỗi khi toggle ngày $date: $e");
    }
  }

  //xoa thoi quen
  void deleteHabit(String habitId) {
    _habits.removeWhere((h) => h.id == habitId);
    notifyListeners();
  }

  //reset du lieu
  void resetAllHabits() {
    _habits = []; 
    _completedHabits = []; 
    _justCompletedHabit = null; 
    notifyListeners();
  }
}