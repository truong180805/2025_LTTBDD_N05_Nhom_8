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
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 2. Cập nhật danh sách Widget (thay About bằng Profile)
  static const List<Widget> _widgetOptions = <Widget>[
    ChallengeListScreen(),
    StatisticsScreen(),
    ProfileScreen(), // <--- Thay đổi ở đây
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<AppBar> _buildAppBars(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      // AppBar cho Tab 0: Thử thách (CÓ NÚT MENU)
      AppBar(
        leading: Builder(
          builder: (context) {
            // Builder này lấy context BÊN TRONG Scaffold của MainScreen
            return IconButton(
              icon: Icon(Icons.menu, size: 30),
              onPressed: () {
                // Lệnh này giờ sẽ tìm đúng Scaffold và MỞ ĐƯỢC
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(l10n.tabChallenges, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        elevation: 0,
      ),
      // AppBar cho Tab 1: Thống kê
      AppBar(
        title: Text(l10n.tabStatistics, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false, // Tắt nút back/menu
      ),
      // AppBar cho Tab 2: Hồ sơ
      AppBar(
        title: Text("Hồ sơ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)), // (Sẽ thêm l10n sau)
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false, // Tắt nút back/menu
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appBars = _buildAppBars(context);

    return Scaffold(
      // --- (3. THÊM DRAWER VÀO ĐÂY) ---
      drawer: Drawer(
        child: Column(
          children: [
            // Header của Drawer
            UserAccountsDrawerHeader(
              accountName: Text(
                l10n.appName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text("${l10n.version} 1.0.0"), // Gợi ý của tôi
              currentAccountPicture: CircleAvatar(
                backgroundColor: theme.colorScheme.onPrimary,
                child: Text(
                  "🎯",
                  style: TextStyle(fontSize: 40),
                ),
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
              ),
            ),
            
            // Các mục menu
            ListTile(
              leading: Icon(Icons.home_outlined),
              title: Text(l10n.tabChallenges),
              onTap: () {
                setState(() { _selectedIndex = 0; }); // Chuyển về Tab 0
                Navigator.pop(context); // Đóng menu
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart_outlined),
              title: Text(l10n.tabStatistics),
              onTap: () {
                setState(() { _selectedIndex = 1; }); // Chuyển về Tab 1
                Navigator.pop(context); // Đóng menu
              },
            ),
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text(l10n.profile), // (Sẽ thêm l10n sau)
              onTap: () {
                setState(() { _selectedIndex = 2; }); // Chuyển về Tab 2
                Navigator.pop(context); // Đóng menu
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text(l10n.settings), // (Sẽ thêm l10n sau)
              onTap: () {
                Navigator.pop(context); // Đóng menu
                // (Điều hướng đến màn hình Cài đặt)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text(l10n.tabAbout), // "Thông tin"
              onTap: () {
                Navigator.pop(context); // Đóng menu
                // (Điều hướng đến màn hình Thông tin)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
            
            // Gợi ý của tôi: Nút Reset dữ liệu
            Spacer(), // Đẩy mục này xuống cuối
            ListTile(
              leading: Icon(Icons.delete_sweep_outlined, color: Colors.red),
              title: Text("Reset ứng dụng", style: TextStyle(color: Colors.red)),
              onTap: () {
                // Đóng menu trước
                Navigator.pop(context); 
                
                // Hiển thị Dialog xác nhận
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Bạn có chắc chắn?"),
                    content: Text("Toàn bộ thói quen, hồ sơ và cài đặt sẽ bị xóa vĩnh viễn."),
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
                          // Lấy TẤT CẢ provider (listen: false)
                          final habitProvider = Provider.of<HabitProvider>(context, listen: false);
                          final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                          final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
                          
                          // Gọi các hàm reset
                          habitProvider.resetAllHabits();
                          profileProvider.resetProfile();
                          settingsProvider.resetSettings();
                          
                          // Đóng Dialog
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

      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      
      // --- (4. CẬP NHẬT BOTTOM NAV BAR) ---
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
            icon: Icon(Icons.person_outline), // <-- Icon mới
            label: l10n.profile, // <-- Tên mới (sẽ thêm l10n sau)
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        
        // (Gợi ý): Fix giao diện khi dùng 3 tab với M3
        type: BottomNavigationBarType.fixed, 
      ),

      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // Gọi Dialog đã được tách ra
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