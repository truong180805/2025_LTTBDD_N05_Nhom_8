import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mini_habit_challenge/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  DateTime? _selectedDob;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {//nap du lieu ban dau
    super.didChangeDependencies();
    if (!_isInitialized) {
      final profile = Provider.of<ProfileProvider>(context, listen: false);

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
  void dispose() {//giai phong tai nguyen 
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  //ham chon ngay sinh
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

  // ham luu profile
  void _saveProfile() {
    final profile = Provider.of<ProfileProvider>(context, listen: false);

    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    profile.updateProfile(
      name: _nameController.text,
      dob: _selectedDob,
      weight: weight,
      height: height,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đã lưu hồ sơ!"), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: EdgeInsets.all(24),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),

            child: Image.asset(
              'assets/images/anha.png',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover, 
            ),
          ),
        ),
        
        _buildTextField(
          controller: _nameController,
          label: l10n.name, 
          icon: Icons.person_outline,
        ),
        SizedBox(height: 20),

        _buildDatePicker(context, l10n),
        SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _weightController,
                label: l10n.weightInKg, 
                icon: Icons.monitor_weight_outlined,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _heightController,
                label: l10n.heightInCm, 
                icon: Icons.height_outlined,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(height: 40),

        ElevatedButton(
          onPressed: _saveProfile,
          child: Text(l10n.saveChanges), 
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Widget helper cho o nhap du lieu
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

  // Widget helper cho o chon ngay
  Widget _buildDatePicker(BuildContext context, AppLocalizations l10n) {
    final dateFormat = DateFormat.yMd(l10n.localeName);

    return InkWell(
      onTap: _pickDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.dateOfBirth, 
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
