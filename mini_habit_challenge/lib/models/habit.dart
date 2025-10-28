import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

enum HabitType {
  daily,
  challenge
}

class Habit {
  String id;
  String name;
  HabitType type;
  DateTime startDate;
  int? totalDays;
  TimeOfDay? reminderTime;
  Map <DateTime, bool> completionLog;

  Habit({
    required this.type,
    required this.name,
    required this.startDate,
    this.reminderTime,
    this.totalDays,
  }) : id = Uuid().v4(), //tao ID ngau nhien
        completionLog = {};
  
  DateTime? get endDate {
    if (type == HabitType.challenge && totalDays != null) {
      return startDate.add(Duration(days: totalDays! - 1));
    }
    return null;
  }

  bool get isCompletedToday {
    final today = _dateOnly(DateTime.now());
    return completionLog[today] ?? false; // Trả về false nếu chưa có log
  }

  int get streak {
    int currentStreak = 0;
    // Bắt đầu từ hôm nay và đi lùi về quá khứ
    DateTime dateToCheck = _dateOnly(DateTime.now());

    // Nếu hôm nay chưa hoàn thành, chuỗi chắc chắn là 0
    if (!isCompletedToday) {
       // ... nhưng nếu hôm qua hoàn thành, chuỗi là của ngày hôm qua
       dateToCheck = dateToCheck.subtract(Duration(days: 1));
    }

    while (completionLog[dateToCheck] == true) {
      currentStreak++;
      dateToCheck = dateToCheck.subtract(Duration(days: 1));
    }
    return currentStreak;
  }
  double get progress {
    if (type == HabitType.daily || totalDays == null || totalDays == 0) return 0;
    
    // Đếm số ngày đã hoàn thành
    int daysCompleted = completionLog.values.where((completed) => completed == true).length;
    return daysCompleted / totalDays!;
  }
  // Hàm tiện ích (private) để chuẩn hóa DateTime (chỉ lấy Ngày, bỏ Giờ/Phút)
DateTime _dateOnly(DateTime dt) {
  return DateTime(dt.year, dt.month, dt.day);
}
}