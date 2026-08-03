import 'dart:io';

import 'package:flutter/material.dart';

import '../reports/reports_view.dart';
import '../view/about/about_view.dart';
import '../view/meal_plan/mean_plan_view.dart';
import '../view/plan/plan_view.dart';
import '../view/settings/settings_view.dart';
import '../reports/weight_progress_view.dart';

class AppDrawer extends StatelessWidget {
  final String profileName;
  final String? profileImagePath;

  const AppDrawer({
    super.key,
    required this.profileName,
    required this.profileImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 20,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff6A1B9A),
                    Color(0xff8E24AA),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundImage: profileImagePath != null &&
                            File(profileImagePath!).existsSync()
                        ? FileImage(File(profileImagePath!))
                        : null,
                    child: profileImagePath == null
                        ? const Icon(Icons.person, size: 45)
                        : null,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    profileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Keep pushing! 🔥',
                    style: TextStyle(
                      color: Colors.white.withOpacity(.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _drawerItem(
              context,
              icon: Icons.home,
              title: 'Home',
              onTap: () => Navigator.pop(context),
            ),
            _drawerItem(
              context,
              icon: Icons.fitness_center,
              title: 'My Plan',
              onTap: () => _openPage(
                context,
                const PlanView(),
              ),
            ),
            _drawerItem(
              context,
              icon: Icons.bar_chart,
              title: 'Reports',
              onTap: () => _openPage(
                context,
                const ReportsView(),
              ),
            ),
            _drawerItem(
              context,
              icon: Icons.restaurant,
              title: 'Meal Plan',
              onTap: () => _openPage(
                context,
                const MealPlanView(),
              ),
            ),
            _drawerItem(
              context,
              icon: Icons.monitor_weight,
              title: 'Weight',
              onTap: () => _openPage(
                context,
                const WeightProgressView(),
              ),
            ),
            const Spacer(),
            const Divider(height: 1),
            _drawerItem(
              context,
              icon: Icons.settings,
              title: 'Settings',
              onTap: () => _openPage(
                context,
                const SettingsView(),
              ),
            ),
            _drawerItem(
              context,
              icon: Icons.info_outline,
              title: 'About',
              onTap: () => _openPage(
                context,
                const AboutView(),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  static void _openPage(
    BuildContext context,
    Widget page,
  ) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
      ),
      onTap: onTap,
    );
  }
}
