import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'challenge_list_screen.dart';
import 'statistics_screen.dart';
import 'about_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import '../widgets/add_habit_dialog.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
import '../providers/habit_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/settings_provider.dart';

class MainScreen extends StatefulWidget {
    const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ChallengeListScreen(),
    StatisticsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<AppBar> _buildAppBars(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      AppBar(
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
      ),
      AppBar(
        title: Text(
          l10n.tabStatistics,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      AppBar(
        title: Text(
          l10n.profile,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ), 
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false, 
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appBars = _buildAppBars(context);

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                l10n.appName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              accountEmail: Text(
                "${l10n.version} 1.0.0",
                style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: theme.colorScheme.onPrimary,
                child: Text("🎯", style: TextStyle(fontSize: 40)),
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
              ),
            ),

            ListTile(
              leading: Icon(Icons.home_outlined),
              title: Text(l10n.tabChallenges),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                }); 
                Navigator.pop(context); 
              },
            ),

            ListTile(
              leading: Icon(Icons.bar_chart_outlined),
              title: Text(l10n.tabStatistics),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                }); 
                Navigator.pop(context); 
              },
            ),

            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text(l10n.profile), 
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                }); 
                Navigator.pop(context); 
              },
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text(l10n.settings), 
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text(l10n.tabAbout), 
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),

            
            Spacer(), 
            ListTile(
              leading: Icon(Icons.delete_sweep_outlined, color: Colors.red),
              title: Text(
                "Reset ứng dụng",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Bạn có chắc chắn?"),
                    content: Text(
                      "Toàn bộ thói quen, hồ sơ và cài đặt sẽ bị xóa vĩnh viễn.",
                    ),
                    actions: [
                      TextButton(
                        child: Text("Hủy"),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                      FilledButton(
                        child: Text("Reset"),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),

                        onPressed: () {
                          final habitProvider = Provider.of<HabitProvider>(
                            context,
                            listen: false,
                          );
                          final profileProvider = Provider.of<ProfileProvider>(
                            context,
                            listen: false,
                          );
                          final settingsProvider =
                              Provider.of<SettingsProvider>(
                                context,
                                listen: false,
                              );

                          habitProvider.resetAllHabits();
                          profileProvider.resetProfile();
                          settingsProvider.resetSettings();

                          Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),

      appBar: appBars[_selectedIndex],

      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),

      //thanh dieu huong duoi
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: l10n.tabChallenges,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: l10n.tabStatistics,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), 
            label: l10n.profile, 
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      ),

      //nut them chi hien tab thu thach
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddHabitDialog(),
                );
              },
              child: Icon(Icons.add),
              tooltip: l10n.addHabit,
            )
          : null,
    );
  }
}
