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

  //getter dung de tra ve ngay ket thuc cho challenge
  DateTime? get endDate {
    if (type == HabitType.challenge && totalDays != null) {
      return startDate.add(Duration(days: totalDays! - 1));
    }
    return null;
  }

  //getter kiem tra ngay hien tai co hoan thanh chua
  bool get isCompletedToday {
    final today = _dateOnly(DateTime.now());
    return completionLog[today] ?? false; 
  }

  //getter dem chuoi ngay lien tiep hoan thanh
  int get streak {
    int currentStreak = 0;
    
    DateTime dateToCheck = _dateOnly(DateTime.now());

    if (!isCompletedToday) {
       dateToCheck = dateToCheck.subtract(Duration(days: 1));
    }

    while (completionLog[dateToCheck] == true) {
      currentStreak++;
      dateToCheck = dateToCheck.subtract(Duration(days: 1));
    }
    return currentStreak;
  }

  //getter tien do thu thach
  double get progress {
    if (type == HabitType.daily || totalDays == null || totalDays == 0) return 0;

    int daysCompleted = completionLog.values.where((completed) => completed == true).length;
    return daysCompleted / totalDays!;
  }

  //ham private dung loai bo gio phut giai khoi DateTime
  DateTime _dateOnly(DateTime dt) {
  return DateTime(dt.year, dt.month, dt.day);
  }

  //getter kiem tra thu thach da hoan thanh chua
  bool get isChallengeFullyCompleted {
    if (type == HabitType.daily || totalDays == null || totalDays == 0) return false;
    
    int completedCount = completionLog.values.where((v) => v == true).length;
    
    return completedCount >= totalDays!;
  }
}