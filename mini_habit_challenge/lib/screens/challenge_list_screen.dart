import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'habit_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import 'completion_screen.dart';

 class ChallengeListScreen extends StatelessWidget {
  const ChallengeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      // (Menu trượt và AppBar căn giữa giữ nguyên như bước trước)
      drawer: Drawer(
        // ... (Code của Drawer giữ nguyên)
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, size: 30),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(
          l10n.tabChallenges,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      // --- (BODY MỚI) ---
      // Body bây giờ sẽ hiển thị 2 danh sách riêng biệt
      body: Consumer<HabitProvider>(
        builder: (context, provider, child) {
          final dailyHabits = provider.dailyHabits;
          final challengeHabits = provider.challengeHabits;

          final completedHabit = provider.justCompletedHabit; // Đọc 1 lần
          
          if (completedHabit != null) {
            
            // (MỚI) Kiểm tra xem đây có phải là màn hình đang xem không
            final route = ModalRoute.of(context);
            if (route != null && route.isCurrent) { 
            
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Chỉ điều hướng nếu là màn hình hiện tại
                Navigator.push( 
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompletionScreen(
                      habitName: completedHabit.name // Dùng biến local
                    ),
                  ),
                );
                provider.clearJustCompletedHabit(); // Xóa cờ
              });
            }
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Tiêu đề "Hàng ngày"
                Text(
                  "Hàng ngày", // (Sẽ thêm vào l10n sau)
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                _buildHabitList(context, dailyHabits, provider),

                SizedBox(height: 24),

                // 2. Tiêu đề "Thử thách"
                Text(
                  "Thử thách", // (Sẽ thêm vào l10n sau)
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                _buildHabitList(context, challengeHabits, provider),
              ],
            ),
          );
        },
      ),

      // Nút FAB sẽ gọi Dialog (Widget) mới
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            // (3) Gọi Dialog mới
            builder: (context) => _AddHabitDialog(),
          );
        },
        child: Icon(Icons.add),
        tooltip: l10n.addHabit,
      ),
    );
  }

  // --- (HÀM HELPER MỚI) Để vẽ danh sách ---
  // Dùng để vẽ Card thói quen (đã cập nhật logic)
  Widget _buildHabitList(BuildContext context, List<Habit> habits, HabitProvider provider) {
    if (habits.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Text(
          "Chưa có thói quen nào trong mục này.",
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return ListView.builder(
      itemCount: habits.length,
      shrinkWrap: true, // Để nằm trong SingleChildScrollView
      physics: NeverScrollableScrollPhysics(), // Không cho cuộn lồng nhau
      itemBuilder: (context, index) {
        final habit = habits[index];
        final bool isDoneToday = habit.isCompletedToday; // Logic mới

        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              children: [
                // (MỚI) Nút tick 'Hôm nay'
                IconButton(
                  icon: Icon(
                    isDoneToday ? Icons.check_box : Icons.check_box_outline_blank,
                    color: isDoneToday ? Theme.of(context).colorScheme.primary : Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    // Gọi hàm toggle mới
                    provider.toggleTodayCompletion(habit.id);
                  },
                ),
                // Phần nội dung (tên, chuỗi, tiến độ)
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // Vẫn đi đến màn hình chi tiết (dù nó đang lỗi)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HabitDetailScreen(habitId: habit.id),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        // (MỚI) Hiển thị Chuỗi (Streak)
                        Text(
                          "🔥 Chuỗi: ${habit.streak} ngày",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.deepOrange,
                          ),
                        ),
                        // (MỚI) Chỉ hiển thị tiến độ cho loại 'Challenge'
                        if (habit.type == HabitType.challenge)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: LinearPercentIndicator(
                              percent: habit.progress,
                              lineHeight: 8.0,
                              backgroundColor: Colors.grey.shade300,
                              progressColor: Theme.of(context).primaryColor,
                              barRadius: Radius.circular(4.0),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- (PHẦN 2: DIALOG THÊM MỚI - DẠNG STATEFULWIDGET) ---
// Chúng ta tạo một Widget riêng để quản lý state của Dialog
class _AddHabitDialog extends StatefulWidget {
  const _AddHabitDialog({Key? key}) : super(key: key);

  @override
  _AddHabitDialogState createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<_AddHabitDialog> {
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