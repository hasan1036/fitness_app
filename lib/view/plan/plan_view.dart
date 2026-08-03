import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../data/workout_day_view.dart';
import '../../reports/reports_view.dart';
import '../../service/user_profile_service.dart';
import '../home/home_view.dart';
import '../menu/menu_view.dart';
import '../profile/me_view.dart';

class PlanView extends StatefulWidget {
  const PlanView({super.key});

  @override
  State<PlanView> createState() => _PlanViewState();
}

class _PlanViewState extends State<PlanView> {
  bool isLoading = true;
  UserProfileData? profile;

  final List<Map<String, dynamic>> planCategories = const [
    {
      "title": "Fat Burn",
      "subtitle": "Beginner • 15 min",
      "icon": Icons.local_fire_department_rounded,
    },
    {
      "title": "Full Body",
      "subtitle": "Intermediate • 20 min",
      "icon": Icons.fitness_center_rounded,
    },
    {
      "title": "HIIT",
      "subtitle": "Advanced • 12 min",
      "icon": Icons.bolt_rounded,
    },
    {
      "title": "Stretch",
      "subtitle": "Recovery • 10 min",
      "icon": Icons.self_improvement_rounded,
    },
  ];

  final List<Map<String, dynamic>> weeklyPlan = const [
    {
      "day": "Mon",
      "title": "Full Body",
      "status": "Completed",
      "icon": Icons.check_rounded,
    },
    {
      "day": "Tue",
      "title": "Leg & Glutes",
      "status": "Today",
      "icon": Icons.play_arrow_rounded,
    },
    {
      "day": "Wed",
      "title": "Recovery",
      "status": "Rest",
      "icon": Icons.spa_rounded,
    },
    {
      "day": "Thu",
      "title": "Core",
      "status": "Upcoming",
      "icon": Icons.schedule_rounded,
    },
    {
      "day": "Fri",
      "title": "Upper Body",
      "status": "Upcoming",
      "icon": Icons.schedule_rounded,
    },
    {
      "day": "Sat",
      "title": "Cardio",
      "status": "Upcoming",
      "icon": Icons.schedule_rounded,
    },
    {
      "day": "Sun",
      "title": "Recovery",
      "status": "Rest",
      "icon": Icons.spa_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final UserProfileData value =
        await UserProfileService.getProfile();

    if (!mounted) return;

    setState(() {
      profile = value;
      isLoading = false;
    });
  }

  String _goalTitle(UserProfileData data) {
    switch (data.goalType) {
      case "gain_weight":
        return "Build Muscle Plan";
      case "maintain_weight":
        return "Stay Fit Plan";
      default:
        return "Lose Weight Plan";
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
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffF7F3FD),
        elevation: 0,
        title: const Text(
          "My Plan",
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.tune_rounded,
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
                18,
                6,
                18,
                26,
              ),
              children: [
                _activePlanCard(data),
                const SizedBox(height: 22),
                _sectionTitle(
                  "Choose Your Focus",
                  "View all",
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 128,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: planCategories.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return _categoryCard(
                        planCategories[index],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _sectionTitle(
                  "This Week",
                  "7 days",
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  weeklyPlan.length,
                  (index) => _weeklyTile(
                    weeklyPlan[index],
                    index,
                  ),
                ),
                const SizedBox(height: 22),
                _goalCard(data),
              ],
            ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _activePlanCard(UserProfileData data) {
    const int completedDays = 1;
    const int totalDays = 30;
    const double progress =
        completedDays / totalDays;

    return Container(
      padding: const EdgeInsets.all(21),
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.17),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: const Text(
                  "ACTIVE PLAN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.workspace_premium_rounded,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 17),
          Text(
            _goalTitle(data),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Day $completedDays of $totalDays • Beginner",
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.white24,
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 9),
          const Row(
            children: [
              Text(
                "3% completed",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Text(
                "29 days remaining",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const WorkoutDayView(
                      dayNumber: 1,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.play_arrow_rounded,
              ),
              label: const Text(
                "CONTINUE TODAY'S WORKOUT",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: TColor.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(
    String title,
    String action,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          action,
          style: TextStyle(
            color: TColor.primary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _categoryCard(
    Map<String, dynamic> item,
  ) {
    return Container(
      width: 155,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: TColor.primaryLight,
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              item["icon"] as IconData,
              color: TColor.primary,
            ),
          ),
          const Spacer(),
          Text(
            item["title"].toString(),
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item["subtitle"].toString(),
            style: TextStyle(
              color: TColor.sceondarText,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _weeklyTile(
    Map<String, dynamic> item,
    int index,
  ) {
    final bool isToday =
        item["status"] == "Today";
    final bool completed =
        item["status"] == "Completed";

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isToday
            ? TColor.primaryLight
            : Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: isToday
              ? TColor.primary.withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: ListTile(
        onTap: isToday
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const WorkoutDayView(
                      dayNumber: 1,
                    ),
                  ),
                );
              }
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        leading: Container(
          width: 45,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isToday
                ? TColor.primary
                : TColor.primaryLight,
            borderRadius:
                BorderRadius.circular(14),
          ),
          child: Text(
            item["day"].toString(),
            style: TextStyle(
              color: isToday
                  ? Colors.white
                  : TColor.primary,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        title: Text(
          item["title"].toString(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          item["status"].toString(),
          style: TextStyle(
            color: completed
                ? Colors.green
                : isToday
                    ? TColor.primary
                    : TColor.sceondarText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        trailing: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: completed
                ? Colors.green.withOpacity(0.12)
                : TColor.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            item["icon"] as IconData,
            color: completed
                ? Colors.green
                : TColor.primary,
            size: 19,
          ),
        ),
      ),
    );
  }

  Widget _goalCard(UserProfileData data) {
    final String current =
        data.currentWeight > 0
            ? "${data.currentWeight.toStringAsFixed(1)} kg"
            : "-- kg";

    final String target =
        data.targetWeight > 0
            ? "${data.targetWeight.toStringAsFixed(1)} kg"
            : "-- kg";

    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            "My Goal",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _goalItem(
                  "Current",
                  current,
                ),
              ),
              Expanded(
                child: _goalItem(
                  "Target",
                  target,
                ),
              ),
              Expanded(
                child: _goalItem(
                  "Progress",
                  "${(data.goalProgress * 100).round()}%",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _goalItem(
    String title,
    String value,
  ) {
    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: TColor.primary,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: TColor.sceondarText,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      width: double.infinity,
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 16,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: [
            _bottomItem(
              Icons.home_rounded,
              "Home",
              false,
              () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const MenuView(),
                  ),
                  (route) => false,
                );
              },
            ),
            _bottomItem(
              Icons.assignment_rounded,
              "Plan",
              true,
              () {},
            ),
            _bottomItem(
              Icons.bar_chart_rounded,
              "Reports",
              false,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ReportsView(),
                  ),
                );
              },
            ),
            _bottomItem(
              Icons.person_outline_rounded,
              "Me",
              false,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MeView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomItem(
    IconData icon,
    String title,
    bool active,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: active
                  ? TColor.primary
                  : Colors.black,
              size: 25,
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(
                color: active
                    ? TColor.primary
                    : Colors.black,
                fontSize: 11,
                fontWeight: active
                    ? FontWeight.w800
                    : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 3),
            if (active)
              Container(
                width: 24,
                height: 3,
                decoration: BoxDecoration(
                  color: TColor.primary,
                  borderRadius:
                      BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
