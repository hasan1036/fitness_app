import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../profile/profile_setup_view.dart';
import '../schedule/schedule_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool notificationsEnabled = true;
  bool soundEnabled = true;
  bool vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3FD),
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F3FD),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          _sectionTitle('General'),
          _tile(
            icon: Icons.person_outline_rounded,
            title: 'Personal Information',
            subtitle: 'Age, height, weight and fitness goal',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileSetupView(),
                ),
              );
            },
          ),
          _tile(
            icon: Icons.notifications_active_outlined,
            title: 'Schedule & Reminders',
            subtitle: 'Manage workout, water, meal and sleep reminders',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ScheduleView(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          _sectionTitle('Notifications'),
          _switchTile(
            icon: Icons.notifications_rounded,
            title: 'Notifications',
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() => notificationsEnabled = value);
            },
          ),
          _switchTile(
            icon: Icons.volume_up_rounded,
            title: 'Notification Sound',
            value: soundEnabled,
            onChanged: notificationsEnabled
                ? (value) => setState(() => soundEnabled = value)
                : null,
          ),
          _switchTile(
            icon: Icons.vibration_rounded,
            title: 'Vibration',
            value: vibrationEnabled,
            onChanged: notificationsEnabled
                ? (value) => setState(() => vibrationEnabled = value)
                : null,
          ),
          const SizedBox(height: 20),
          _sectionTitle('App'),
          _tile(
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: 'English',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('More languages will be added later')),
              );
            },
          ),
          _tile(
            icon: Icons.straighten_rounded,
            title: 'Weight Unit',
            subtitle: 'Kilograms (kg)',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Unit settings will be added later')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          color: TColor.primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        leading: _iconBox(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle, style: TextStyle(color: TColor.sceondarText, fontSize: 11)),
        trailing: Icon(Icons.arrow_forward_ios_rounded, color: TColor.primary, size: 16),
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: TColor.primary,
        secondary: _iconBox(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: TColor.primaryLight,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, color: TColor.primary),
    );
  }
}
