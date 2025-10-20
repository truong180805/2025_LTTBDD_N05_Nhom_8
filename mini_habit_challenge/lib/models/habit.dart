import 'package:uuid/uuid.dart';

class Habit {
  String id;
  String name;
  int totalDays;
  List<bool> completionStatus; //danh sach theo doi hoan thanh

  Habit({
    required this.name,
    this.totalDays = 7,//mac dinh la 7 ngay
  }) : id = Uuid().v4(), //tao ID ngau nhien

        completionStatus = List.generate(totalDays, (index) => false);

  //ham tinh so ngay da hoan thanh
  int get daysCompleted {
    return completionStatus.where((completed) => completed == true).length;
  } 

  //ham tinh toan tien do
  double get progress {
    if (totalDays == 0) return 0;
    return daysCompleted / totalDays;
  }

  //Ham kiem tra thu thanh da hoan thanh chua
  bool get isCompleted {
    return daysCompleted == totalDays;
  }

}