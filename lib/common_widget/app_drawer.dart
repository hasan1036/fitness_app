import 'dart:io';
import 'package:flutter/material.dart';
import '../reports/reports_view.dart';


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
                    backgroundImage: profileImagePath != null
                        ? FileImage(File(profileImagePath!))
                        : null,
                    child: profileImagePath == null
                        ? const Icon(
                      Icons.person,
                      size: 45,
                    )
                        : null,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    profileName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Keep pushing! 🔥",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text("My Plan"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text("Reports"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReportsView(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text("Meal Plan"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.monitor_weight),
              title: const Text("Weight"),
              onTap: () {},
            ),

            const Spacer(),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About"),
              onTap: () {},
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}