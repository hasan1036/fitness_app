import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../service/profile_service.dart';
import '../../service/user_profile_service.dart';
import '../../service/weight_unit_service.dart';
import '../meal_plan/mean_plan_view.dart';
import '../profile/profile_setup_view.dart';
import '../schedule/schedule_view.dart';
import '../water/water_tracker_view.dart';
import '../../reports/weight_progress_view.dart';

import '../../l10n/app_localizations.dart';
class MeView extends StatefulWidget {
  const MeView({super.key});

  @override
  State<MeView> createState() => _MeViewState();
}

class _MeViewState extends State<MeView> {
  bool isLoading = true;
  String profileName = "Name";
  String? profileImagePath;
  UserProfileData? profile;
  String weightUnit = WeightUnitService.kilograms;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final String name = await ProfileService.getName();
    final String? imagePath =
        await ProfileService.getImagePath();
    final UserProfileData data =
        await UserProfileService.getProfile();
    final String unit = await WeightUnitService.getUnit();

    if (!mounted) return;

    setState(() {
      profileName = name;
      profileImagePath = imagePath;
      profile = data;
      weightUnit = unit;
      isLoading = false;
    });
  }

  Future<void> _openProfileSetup() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileSetupView(),
      ),
    );

    await _loadData();
  }

  String _goalText(String goalType) {
    switch (goalType) {
      case "gain_weight":
        return "Gain Weight";
      case "maintain_weight":
        return "Maintain Weight";
      default:
        return "Lose Weight";
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProfileData data =
        profile ??
        const UserProfileData(
          startWeight: 0,
          currentWeight: 0,
          targetWeight: 0,
          heightCm: 0,
          age: 0,
          gender: "",
          goalType: "lose_weight",
          profileCompleted: false,
        );

    return Scaffold(
      backgroundColor: const Color(0xffF7F3FD),
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F3FD),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
        ),
        title: Text(context.tr('me'),
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openProfileSetup,
            icon: Icon(
              Icons.edit_rounded,
              color: TColor.primary,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: TColor.primary,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                30,
              ),
              children: [
                _buildProfileHeader(data),
                const SizedBox(height: 18),
                _buildBodySummary(data),
                const SizedBox(height: 22),
                Text(context.tr('myHealth'),
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        icon: Icons.monitor_weight_rounded,
                        value: data.currentWeight > 0
                            ? WeightUnitService.formatKg(data.currentWeight, weightUnit)
                            : "-- ${WeightUnitService.label(weightUnit)}",
                        title: "Current Weight",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _summaryCard(
                        icon: Icons.analytics_rounded,
                        value: data.bmi > 0
                            ? data.bmi.toStringAsFixed(1)
                            : "--",
                        title: "BMI",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        icon: Icons.flag_rounded,
                        value: data.targetWeight > 0
                            ? WeightUnitService.formatKg(data.targetWeight, weightUnit)
                            : "-- ${WeightUnitService.label(weightUnit)}",
                        title: "Target Weight",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _summaryCard(
                        icon: Icons.emoji_events_rounded,
                        value: "${(data.goalProgress * 100).round()}%",
                        title: "Goal Progress",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(context.tr('manage'),
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                _menuTile(
                  icon: Icons.monitor_weight_rounded,
                  title: "Weight Progress",
                  subtitle: "Track your body weight",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WeightProgressView(),
                      ),
                    );
                  },
                ),
                _menuTile(
                  icon: Icons.water_drop_rounded,
                  title: "Water Tracker",
                  subtitle: "Daily goal and history",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const WaterTrackerView(),
                      ),
                    );
                  },
                ),
                _menuTile(
                  icon: Icons.restaurant_menu_rounded,
                  title: "Meal Plan",
                  subtitle: "Meals and nutrition",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const MealPlanView(),
                      ),
                    );
                  },
                ),
                _menuTile(
                  icon: Icons.notifications_active_rounded,
                  title: "Schedule & Reminders",
                  subtitle: "Manage all reminders",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const ScheduleView(),
                      ),
                    );
                  },
                ),
                _menuTile(
                  icon: Icons.person_rounded,
                  title: "Edit Personal Information",
                  subtitle: "Age, height, gender and goal",
                  onTap: _openProfileSetup,
                ),
              ],
            ),
    );
  }

  Widget _buildProfileHeader(UserProfileData data) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColor.primary,
            const Color(0xff8748E8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.white,
            backgroundImage: profileImagePath != null &&
                    File(profileImagePath!).existsSync()
                ? FileImage(File(profileImagePath!))
                : const AssetImage("assets/img/u1.png")
                    as ImageProvider,
          ),
          const SizedBox(height: 14),
          Text(
            profileName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            data.profileCompleted
                ? _goalText(data.goalType)
                : "Complete your fitness profile",
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 17),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _openProfileSetup,
              icon: const Icon(Icons.edit_rounded),
              label: Text(
                data.profileCompleted
                    ? "EDIT PROFILE"
                    : "SET UP PROFILE",
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(
                  color: Colors.white54,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodySummary(UserProfileData data) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Row(
        children: [
          Expanded(
            child: _smallInfo(
              "Age",
              data.age > 0 ? "${data.age}" : "--",
            ),
          ),
          _divider(),
          Expanded(
            child: _smallInfo(
              "Height",
              data.heightCm > 0
                  ? "${data.heightCm.toStringAsFixed(0)} cm"
                  : "--",
            ),
          ),
          _divider(),
          Expanded(
            child: _smallInfo(
              "BMI Status",
              data.bmiStatus,
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallInfo(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: TColor.sceondarText,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 35,
      color: Colors.black12,
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String value,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: TColor.primary,
            size: 25,
          ),
          const SizedBox(height: 11),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(
              color: TColor.sceondarText,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: TColor.primaryLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: TColor.primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: TColor.sceondarText,
            fontSize: 11,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: TColor.primary,
          size: 16,
        ),
      ),
    );
  }
}
