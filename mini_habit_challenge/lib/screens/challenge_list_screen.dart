import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'habit_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
import '../providers/habit_provider.dart';

class ChallengeListScreen extends StatelessWidget {
  const ChallengeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);

    //dung consumer de 'lang nghe' thay doi
    return Consumer<HabitProvider>(
      builder: (context, consumerProvider, child) {
        final habits = consumerProvider.habits; //lay danh sach thoi quen

        return Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer, // Dùng màu M3
                  ),
                  child: Text(
                    l10n.appName,
                    style: TextStyle(
                      fontSize: 24,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Cài đặt'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Thông tin nhóm'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu, size: 30),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: MaterialLocalizations.of(
                    context,
                  ).openAppDrawerTooltip,
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
          body: habits.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      l10n.noHabits,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(12.0),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HabitDetailScreen(habitId: habit.id),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit.name,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 12.0),

                              LinearPercentIndicator(
                                percent: habit.progress,
                                lineHeight: 10.0,
                                backgroundColor: Colors.grey.shade300,
                                progressColor: Theme.of(context).primaryColor,
                                barRadius: Radius.circular(5.0),
                                animation: true,
                              ),
                              SizedBox(height: 8.0),

                              Text(
                                "${habit.daysCompleted}/${habit.totalDays} ${l10n.day}s",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
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

  void _showAddHabitDialog(
    BuildContext context,
    HabitProvider provider,
    AppLocalizations l10n,
  ) {
    final nameController = TextEditingController();
    final daysController = TextEditingController(text: "7");

    showDialog(
      context: context,
      builder: (context) {
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
              SizedBox(height: 16),
              TextField(
                controller: daysController,
                decoration: InputDecoration(labelText: l10n.durationInDays),
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

                if (name.isNotEmpty) {
                  provider.addHabits(name, days);
                  Navigator.pop(context);
                }
              },
              child: Text(l10n.create),
            ),
          ],
        );
      },
    );
  }
}
