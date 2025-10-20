import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitProvider with ChangeNotifier {
  // Danh sach thoi quen , luu tam trong bo nho

  List<Habit>_habits = [
    Habit(name: "Uống 2 lít nước", totalDays: 7),
    Habit(name: "Đọc sách 30 phút", totalDays: 5),
  ];

  List<Habit> get habits => _habits;

  //ham them thoi quen moi
  void addHabits(String name, int totalDays) {
    final newHabit = Habit(name: name, totalDays: totalDays);
    _habits.add(newHabit);

    //de cac widget cap nhap
    notifyListeners();
  }

  //ham khi nguoi dung tich hoac untick 1 ngay
  void toggleDayCompletion(String habitId, int dayIndex) {
    try{
      // tim thoi quen theo ID
      final habit = _habits.firstWhere((h) => h.id == habitId);

      //dao trang thai true,false
      habit.completionStatus[dayIndex] = !habit.completionStatus[dayIndex];

      //thong bao cap nhap
      notifyListeners();

    } catch (e){
      print("Lỗi: Không tìm thấy thói quen với ID $habitId");
    }
  }

  // Ham lay thoi quen
  Habit getHabitById(String habitId){
    return _habits.firstWhere((h)=> h.id == habitId);
  }
}