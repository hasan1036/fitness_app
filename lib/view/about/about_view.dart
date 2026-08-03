import 'package:flutter/material.dart';

import '../../common/color_extention.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

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
          'About',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [TColor.primary, const Color(0xff8748E8)],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.fitness_center_rounded, color: TColor.primary, size: 42),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Fitness Workout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                const Text('Version 1.0.0', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _infoCard(
            icon: Icons.info_outline_rounded,
            title: 'About This App',
            text: 'Fitness Workout helps users follow workout plans, track weight and water, manage meals, and create healthy reminders.',
          ),
          _infoCard(
            icon: Icons.favorite_rounded,
            title: 'Our Mission',
            text: 'Make healthy habits simple, consistent and accessible from one easy-to-use fitness app.',
          ),
          _infoCard(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy',
            text: 'Your locally saved fitness information remains on your device unless cloud backup is added later.',
          ),
          const SizedBox(height: 12),
          Text(
            'Made with dedication for a healthier life.',
            textAlign: TextAlign.center,
            style: TextStyle(color: TColor.sceondarText, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: TColor.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: TColor.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(text, style: TextStyle(color: TColor.sceondarText, fontSize: 12, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
