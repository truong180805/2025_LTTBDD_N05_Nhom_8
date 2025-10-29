// lib/providers/habit_provider.dart
import 'package:flutter/material.dart';
import '../models/habit.dart';

// Hàm tiện ích (private) để chuẩn hóa DateTime (chỉ lấy Ngày, bỏ Giờ/Phút)
DateTime _dateOnly(DateTime dt) {
  return DateTime(dt.year, dt.month, dt.day);
}

class HabitProvider with ChangeNotifier {
   final List<Habit> _habits = [
    Habit(
      name: "Uống 2 lít nước",
      type: HabitType.daily, // Hàng ngày
      startDate: DateTime.now().subtract(Duration(days: 2)), // Bắt đầu 2 hôm trước
      reminderTime: TimeOfDay(hour: 8, minute: 0),
    ),
    Habit(
      name: "Thử thách 7 ngày đọc sách",
      type: HabitType.challenge, // Thử thách
      startDate: DateTime.now().subtract(Duration(days: 1)), // Bắt đầu hôm qua
      totalDays: 7,
      reminderTime: TimeOfDay(hour: 21, minute: 0),
    ),
  ];

  List<Habit> _completedHabits = [];
  Habit? _justCompletedHabit;

  List<Habit> get completedHabits => _completedHabits;

  int get longestOverallStreak {
  if (_habits.isEmpty) return 0; // Nếu không có thói quen, chuỗi là 0

  int longestStreak = 0;
  // Lặp qua từng thói quen
  for (final habit in _habits) {
    // Nếu chuỗi của thói quen này lớn hơn
    if (habit.streak > longestStreak) {
      longestStreak = habit.streak; // Cập nhật
    }
  }
  return longestStreak;
  }

  double get overallTodayProgress {
  // Chỉ tính các thói quen đang hoạt động
  if (_habits.isEmpty) return 0;

  // Đếm số thói quen đã hoàn thành hôm nay
  final completedToday = _habits.where((h) => h.isCompletedToday).length;

  // Trả về tỷ lệ (ví dụ: 2/5 = 0.4)
  return completedToday / _habits.length;
}

  Habit? get justCompletedHabit => _justCompletedHabit;

  void clearJustCompletedHabit() {
    _justCompletedHabit = null;
  }

  void _handleHabitCompletionCheck(Habit habit) {
    if (habit.isChallengeFullyCompleted) { 
      _habits.remove(habit); // 2. Xóa khỏi danh sách chính
      _completedHabits.add(habit); // 3. Thêm vào danh sách hoàn thành
      _justCompletedHabit = habit; // 4. Đặt cờ để UI biết và kích hoạt confetti
    }
  }

  List<Habit> get habits => _habits;
  
  List<Habit> get dailyHabits {
    return _habits.where((h) => h.type == HabitType.daily).toList();
  }

  List<Habit> get challengeHabits {
     return _habits.where((h) => h.type == HabitType.challenge).toList();
  }
  
  Habit getHabitById(String habitId) {
    return _habits.firstWhere((h) => h.id == habitId);
  }

  // --- (HÀM CẬP NHẬT) Thêm Thói quen ---
  void addHabit({
    required String name,
    required HabitType type,
    int? totalDays,
    TimeOfDay? reminderTime,
  }) {
    final newHabit = Habit(
      name: name,
      type: type,
      startDate: _dateOnly(DateTime.now()), // Ngày bắt đầu là hôm nay
      totalDays: type == HabitType.challenge ? totalDays : null,
      reminderTime: reminderTime,
    );
    _habits.add(newHabit);
    notifyListeners();
  }

  // --- (HÀM CẬP NHẬT) Tick/Bỏ tick một ngày ---
  // Chúng ta sẽ tick cho ngày 'hôm nay'
  void toggleTodayCompletion(String habitId) {
    try {
      final habit = getHabitById(habitId);
      final today = _dateOnly(DateTime.now());

      // Lấy trạng thái hiện tại (hoặc false nếu chưa có) và đảo ngược nó
      final bool isCompleted = habit.completionLog[today] ?? false;
      habit.completionLog[today] = !isCompleted;
      _handleHabitCompletionCheck(habit);
      notifyListeners();
    } catch (e) {
      print("Lỗi khi toggle ngày: $e");
    }
  }

  void toggleDateCompletion(String habitId, DateTime date) {
    try {
      final habit = getHabitById(habitId);
      // Chuẩn hóa ngày (loại bỏ giờ/phút)
      final dateOnly = _dateOnly(date); 

      // Đảo ngược trạng thái
      final bool isCompleted = habit.completionLog[dateOnly] ?? false;
      habit.completionLog[dateOnly] = !isCompleted;
      _handleHabitCompletionCheck(habit);
      notifyListeners();
    } catch (e) {
      print("Lỗi khi toggle ngày $date: $e");
    }
  }

  // --- (HÀM MỚI) Xóa/Hủy thói quen ---
  void deleteHabit(String habitId) {
    _habits.removeWhere((h) => h.id == habitId);
    notifyListeners();
  }
}