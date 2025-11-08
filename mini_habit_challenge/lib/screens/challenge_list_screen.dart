import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'habit_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import 'completion_screen.dart';

 class ChallengeListScreen extends StatelessWidget {
  const ChallengeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Consumer<HabitProvider>(
        builder: (context, provider, child) {

          final dailyHabits = provider.dailyHabits;
          final challengeHabits = provider.challengeHabits;
          final completedHabit = provider.justCompletedHabit;
          
          //kiem tra xem co thoi quen vua hoan thanh ko 
          if (completedHabit != null) {
            final route = ModalRoute.of(context);
            if (route != null && route.isCurrent) { 
            
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push( 
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompletionScreen(
                      habitName: completedHabit.name 
                    ),
                  ),
                );
                provider.clearJustCompletedHabit();
              });
            }
          }
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset('assets/images/imapp.png',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

                Text(
                  l10n.daily,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),
                _buildHabitList(context, dailyHabits, provider),

                SizedBox(height: 24),
                Text(
                  l10n.challenges,
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
      );
  }

  
  //widget helper dung de hien thi 1 thoi quen
  Widget _buildHabitList(BuildContext context, List<Habit> habits, HabitProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    //kiem tra danh sach trong
    if (habits.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Text(
          l10n.noHabitsInThisSection,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return ListView.builder(
      itemCount: habits.length,
      shrinkWrap: true, 
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = habits[index];
        final bool isDoneToday = habit.isCompletedToday; //kiem tra hom nay da tick chua

        return Card(
          elevation: theme.brightness == Brightness.light ? 1 : 0,
          color: theme.brightness == Brightness.dark
          ? theme.colorScheme.surfaceContainerHighest
          : theme.colorScheme.surface,
          margin: EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.5),
              width: 1.0,
            ),
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isDoneToday ? Icons.check_box : Icons.check_box_outline_blank,
                    color: isDoneToday ? Theme.of(context).colorScheme.primary : Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    provider.toggleTodayCompletion(habit.id);
                  },
                ),
                
                Expanded(
                  child: InkWell(
                    //toi man hinh chi tiet
                    onTap: () {
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
                        Text(
                          "🔥 Chuỗi: ${habit.streak} ngày",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        //chi hien thi tien do cho thu thach
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


//Lop Tao cua so de them thoi quen moi
class _AddHabitDialog extends StatefulWidget {
  const _AddHabitDialog({Key? key}) : super(key: key);

  @override
  _AddHabitDialogState createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<_AddHabitDialog> {
  // nhap cac gia tri
  final _nameController = TextEditingController();
  final _daysController = TextEditingController(text: "7");
  HabitType _selectedType = HabitType.daily; 
  TimeOfDay? _selectedTime; 

  // ham chon gio
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

  // ham xu ly khi nhan tao
  void _submitHabit() {
    final name = _nameController.text;
    if (name.isEmpty) {
      return;
    }
    final days = int.tryParse(_daysController.text) ?? 7;
    
    //goi ham them thoi quen tu provider
    Provider.of<HabitProvider>(context, listen: false).addHabit(
      name: name,
      type: _selectedType,
      totalDays: _selectedType == HabitType.challenge ? days : null,
      reminderTime: _selectedTime,
    );

    Navigator.pop(context); //dong cua so
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(// hop thoai(cua so) hien thi giua man hinh
      title: Text(l10n.addHabit),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.habitName,
                hintText: l10n.habitNameHint,
              ),
              autofocus: true,
            ),
            SizedBox(height: 20),

            
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

            //chi hien thi so ngay nay khi la thu thach
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

            Text("Giờ nhắc nhở (Tùy chọn):", style: TextStyle(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: _pickTime,
              child: Text(
                _selectedTime == null
                    ? "Chọn giờ"
                    : _selectedTime!.format(context),
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