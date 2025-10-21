import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
import '../providers/habit_provider.dart';

class ChallengeListScreen extends StatelessWidget {
  const ChallengeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final habitProvider = Provider.of<HabitProvider>(context, listen: false );

    //dung consumer de 'lang nghe' thay doi
    return Consumer<HabitProvider>(
      builder: (context, consumerProvider, child) {
        final habits = consumerProvider.habits; //lay danh sach thoi quen

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.tabChallenges)
            ),
          body: habits.isEmpty
              ? Center(child: Text(l10n.noHabits))
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
            onPressed: () {
            _showAddHabitDialog(context, habitProvider, l10n);
            },
            child: Icon(Icons.add),
            tooltip: l10n.addHabit,
          ),
        );
      },
    );
  }
  void _showAddHabitDialog(BuildContext context, HabitProvider provider, AppLocalizations l10n){
    final nameController = TextEditingController();
    final daysController = TextEditingController(text: "7");

    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text(l10n.addHabit),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.habitName,
                  hintText: l10n.habitNameHint,
                ),
                autocorrect: true,
              ),
              SizedBox(height: 16,),
              TextField(
                controller: daysController,
                decoration: InputDecoration(
                  labelText: l10n.durationInDays,
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              ),
              ElevatedButton(
                onPressed: () {
                final name = nameController.text;
                final days = int.tryParse(daysController.text) ?? 7;

                if (name.isNotEmpty){
                  provider.addHabits(name, days);
                  Navigator.pop(context);
                  }
                },
                child: Text(l10n.create),
              ),
          ],
        );
      }
    );
  }
}

