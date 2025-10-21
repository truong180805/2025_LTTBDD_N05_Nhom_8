import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
import '../providers/habit_provider.dart';

class ChallengeListScreen extends StatelessWidget {
  const ChallengeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    //dung consumer de 'lang nghe' thay doi
    return Consumer<HabitProvider>(
      builder: (context, HabitProvider, child) {
        final habits = HabitProvider.habits; //lay danh sach thoi quen

        return Scaffold(
          appBar: AppBar(title: Text(l10n.tabChallenges)),
          body: habits.isEmpty
              ? Center(child: Text("Chưa có thói quen nào."))
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          habit.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          "${habit.daysCompleted}/${habit.totalDays}",
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
            tooltip: "Thêm thử thách",
          ),
        );
      },
    );
  }
}
