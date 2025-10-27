// lib/screens/habit_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Import
import '../providers/habit_provider.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';

class HabitDetailScreen extends StatelessWidget {
  final String habitId; // ID để biết đang xem thói quen nào

  const HabitDetailScreen({super.key, required this.habitId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        
        final habit = provider.getHabitById(habitId);

        return Scaffold(
          appBar: AppBar(
            title: Text(habit.name),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Vòng tròn tiến độ
                Center(
                  child: CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 15.0,
                    percent: habit.progress, // Dữ liệu từ provider
                    center: Text(
                      "${habit.daysCompleted}/${habit.totalDays}\nNgày",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    progressColor: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 30),

                
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, 
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: habit.totalDays,
                  itemBuilder: (context, index) {
                    final dayNumber = index + 1;
                    final isCompleted = habit.completionStatus[index];

                    return InkWell(
                      onTap: () {
                        
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCompleted ? Colors.blueAccent : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isCompleted ? Colors.blueAccent : Colors.grey.shade400,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Ngày $dayNumber",
                              style: TextStyle(
                                color: isCompleted ? Colors.white : Colors.black,
                              ),
                            ),
                            Icon(
                              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: isCompleted ? Colors.white : Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}