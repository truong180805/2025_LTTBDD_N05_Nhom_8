import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';


class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({Key? key}) : super(key: key);

  @override
  AddHabitDialogState createState() => AddHabitDialogState();
}
class AddHabitDialogState extends State<AddHabitDialog> {
  // Các biến state cho Dialog
  final _nameController = TextEditingController();
  final _daysController = TextEditingController(text: "7");
  HabitType _selectedType = HabitType.daily; // Mặc định là 'Hàng ngày'
  TimeOfDay? _selectedTime; // Giờ nhắc nhở (nullable)

  // Hàm hiển thị chọn giờ
  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  // Hàm xử lý khi nhấn "Tạo"
  void _submitHabit() {
    final name = _nameController.text;
    if (name.isEmpty) {
      // (Có thể thêm thông báo lỗi)
      return;
    }

    final days = int.tryParse(_daysController.text) ?? 7;
    
    // Gọi hàm addHabit mới từ Provider
    Provider.of<HabitProvider>(context, listen: false).addHabit(
      name: name,
      type: _selectedType,
      totalDays: _selectedType == HabitType.challenge ? days : null,
      reminderTime: _selectedTime,
    );

    Navigator.pop(context); // Đóng Dialog
  }

@override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.addHabit),
      // Dùng SingleChildScrollView để tránh tràn pixel khi bàn phím hiện
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Tên thói quen
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.habitName,
                hintText: l10n.habitNameHint,
              ),
              autofocus: true,
            ),
            SizedBox(height: 20),

            // 2. Chọn Loại (Hàng ngày / Thử thách)
            Text("Loại thói quen:", style: TextStyle(fontWeight: FontWeight.bold)),
            ToggleButtons(
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("Hàng ngày")),
                Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("Thử thách")),
              ],
              isSelected: [
                _selectedType == HabitType.daily,
                _selectedType == HabitType.challenge,
              ],
              onPressed: (index) {
                setState(() {
                  _selectedType = (index == 0) ? HabitType.daily : HabitType.challenge;
                });
              },
              borderRadius: BorderRadius.circular(8),
              constraints: BoxConstraints(minWidth: 100, minHeight: 40),
            ),
            SizedBox(height: 16),

            // 3. (MỚI) Chỉ hiển thị khi là 'Thử thách'
            Visibility(
              visible: _selectedType == HabitType.challenge,
              child: TextField(
                controller: _daysController,
                decoration: InputDecoration(
                  labelText: l10n.durationInDays,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 16),

            // 4. (MỚI) Chọn giờ nhắc nhở
            Text("Giờ nhắc nhở (Tùy chọn):", style: TextStyle(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: _pickTime,
              child: Text(
                _selectedTime == null
                    ? "Chọn giờ"
                    : _selectedTime!.format(context), // "10:30 AM"
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        ElevatedButton(
          onPressed: _submitHabit,
          child: Text(l10n.create),
        ),
      ],
    );
  }
}