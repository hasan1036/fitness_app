import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../data/workout_day_view.dart';
import '../../reports/reports_view.dart';
import '../../service/user_profile_service.dart';
import '../../service/weight_unit_service.dart';
import '../menu/menu_view.dart';
import '../profile/me_view.dart';

import '../../l10n/app_localizations.dart';
class PlanView extends StatefulWidget {
  const PlanView({super.key});

  @override
  State<PlanView> createState() => _PlanViewState();
}

class _PlanViewState extends State<PlanView> {
  bool isLoading = true;
  UserProfileData? profile;
  String weightUnit = WeightUnitService.kilograms;

  final List<Map<String, dynamic>> planCategories = const [
    {
      "titleKey": "fatBurn",
      "levelKey": "beginner",
      "minutes": 15,
      "icon": Icons.local_fire_department_rounded,
    },
    {
      "titleKey": "fullBody",
      "levelKey": "intermediate",
      "minutes": 20,
      "icon": Icons.fitness_center_rounded,
    },
    {
      "titleKey": "hiit",
      "levelKey": "advanced",
      "minutes": 12,
      "icon": Icons.bolt_rounded,
    },
    {
      "titleKey": "stretch",
      "levelKey": "recovery",
      "minutes": 10,
      "icon": Icons.self_improvement_rounded,
    },
  ];

  final List<Map<String, dynamic>> weeklyPlan = const [
    {
      "dayKey": "mondayShort",
      "titleKey": "fullBody",
      "statusKey": "completed",
      "icon": Icons.check_rounded,
    },
    {
      "dayKey": "tuesdayShort",
      "titleKey": "legsGlutes",
      "statusKey": "today",
      "icon": Icons.play_arrow_rounded,
    },
    {
      "dayKey": "wednesdayShort",
      "titleKey": "recovery",
      "statusKey": "rest",
      "icon": Icons.spa_rounded,
    },
    {
      "dayKey": "thursdayShort",
      "titleKey": "core",
      "statusKey": "upcoming",
      "icon": Icons.schedule_rounded,
    },
    {
      "dayKey": "fridayShort",
      "titleKey": "upperBody",
      "statusKey": "upcoming",
      "icon": Icons.schedule_rounded,
    },
    {
      "dayKey": "saturdayShort",
      "titleKey": "cardio",
      "statusKey": "upcoming",
      "icon": Icons.schedule_rounded,
    },
    {
      "dayKey": "sundayShort",
      "titleKey": "recovery",
      "statusKey": "rest",
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
    final String unit = await WeightUnitService.getUnit();

    if (!mounted) return;

    setState(() {
      profile = value;
      weightUnit = unit;
      isLoading = false;
    });
  }

  String _goalTitle(UserProfileData data) {
    switch (data.goalType) {
      case "gain_weight":
        return context.tr("buildMusclePlan");
      case "maintain_weight":
        return context.tr("stayFitPlan");
      default:
        return context.tr("loseWeightPlan");
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
        title: Text(
          context.tr('myPlan'),
          style: const TextStyle(
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
            context.tr("chooseFocus"),
            context.tr("viewAll"),
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
            context.tr("thisWeek"),
            "7 ${context.tr("days")}",
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
                child: Text(context.tr('activePlan'),
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
            "${context.tr("day")} $completedDays ${context.tr("of")} "
                "$totalDays • ${context.tr("beginner")}",
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
          Row(
            children: [
              Text(
                "3% ${context.tr("completed")}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                "29 ${context.tr("daysRemaining")}",
                style: const TextStyle(
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
              label: Text(context.tr('continueWorkout'),
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
            context.tr(item["titleKey"].toString()),
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${context.tr(item["levelKey"].toString())} • "
                "${item["minutes"]} ${context.tr("minuteShort")}",
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
        item["statusKey"] == "today";
    final bool completed =
        item["statusKey"] == "completed";

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
            context.tr(item["dayKey"].toString()),
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
          context.tr(item["titleKey"].toString()),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          context.tr(item["statusKey"].toString()),
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
        ? WeightUnitService.formatKg(data.currentWeight, weightUnit)
        : "-- ${WeightUnitService.label(weightUnit)}";

    final String target =
    data.targetWeight > 0
        ? WeightUnitService.formatKg(data.targetWeight, weightUnit)
        : "-- ${WeightUnitService.label(weightUnit)}";

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
          Text(context.tr('myGoal'),
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
                  context.tr("current"),
                  current,
                ),
              ),
              Expanded(
                child: _goalItem(
                  context.tr("target"),
                  target,
                ),
              ),
              Expanded(
                child: _goalItem(
                  context.tr("progress"),
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
              context.tr("home"),
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
              context.tr("plan"),
              true,
                  () {},
            ),
            _bottomItem(
              Icons.bar_chart_rounded,
              context.tr("reports"),
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
              context.tr("me"),
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
