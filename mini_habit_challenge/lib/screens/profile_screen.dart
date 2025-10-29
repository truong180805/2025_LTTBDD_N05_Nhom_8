// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Bộ điều khiển cho các ô nhập liệu
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  // Biến state để lưu ngày sinh
  DateTime? _selectedDob;

  bool _isInitialized = false;

  // 1. Tải dữ liệu từ Provider VÀO các ô nhập liệu
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      // Lấy provider (không lắng nghe)
      final profile = Provider.of<ProfileProvider>(context, listen: false);

      // Đặt giá trị cho các controller
      _nameController.text = profile.name ?? "";
      _weightController.text = profile.weight?.toString() ?? "";
      _heightController.text = profile.height?.toString() ?? "";
      setState(() {
        _selectedDob = profile.dob;
      });

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    // 2. Hủy các controller khi màn hình bị tắt
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  // 3. Hàm hiển thị chọn ngày
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (date != null) {
      setState(() {
        _selectedDob = date;
      });
    }
  }

  // 4. Hàm xử lý khi nhấn "Lưu"
  void _saveProfile() {
    // Lấy provider (không lắng nghe, vì chỉ gọi hàm)
    final profile = Provider.of<ProfileProvider>(context, listen: false);

    // Chuyển đổi text sang số (hoặc null nếu rỗng)
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    // Gọi hàm cập nhật
    profile.updateProfile(
      name: _nameController.text,
      dob: _selectedDob,
      weight: weight,
      height: height,
    );

    // Hiển thị thông báo đã lưu
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đã lưu hồ sơ!"), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Chỉ trả về nội dung (vì Scaffold/AppBar đã ở main_screen)
    return ListView(
      padding: EdgeInsets.all(24),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),

            // Ảnh [Image] bình thường với BoxFit.cover
            child: Image.asset(
              'assets/images/anha.png',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover, // <-- Theo đúng yêu cầu của bạn
            ),
          ),
        ),
        // 1. Tên
        _buildTextField(
          controller: _nameController,
          label: l10n.name, // (Sẽ thêm l10n sau)
          icon: Icons.person_outline,
        ),
        SizedBox(height: 20),

        // 2. Ngày sinh
        _buildDatePicker(context, l10n),
        SizedBox(height: 20),

        // 3. Cân nặng & Chiều cao (đặt trên 1 hàng)
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _weightController,
                label: l10n.weightInKg, // (Sẽ thêm l10n sau)
                icon: Icons.monitor_weight_outlined,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _heightController,
                label: l10n.heightInCm, // (Sẽ thêm l10n sau)
                icon: Icons.height_outlined,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(height: 40),

        // 4. Nút Lưu
        ElevatedButton(
          onPressed: _saveProfile,
          child: Text(l10n.saveChanges), // (Sẽ thêm l10n sau)
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Widget helper cho ô nhập liệu
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Widget helper cho ô chọn ngày
  Widget _buildDatePicker(BuildContext context, AppLocalizations l10n) {
    // Định dạng ngày (ví dụ: 29/10/2025)
    final dateFormat = DateFormat.yMd(l10n.localeName);

    return InkWell(
      onTap: _pickDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.dateOfBirth, // (Sẽ thêm l10n sau)
          prefixIcon: Icon(Icons.calendar_today_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          _selectedDob == null
              ? l10n.noDateSelected
              : dateFormat.format(_selectedDob!),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
