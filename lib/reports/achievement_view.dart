import 'package:flutter/material.dart';

import '../common/color_extention.dart';
import '../service/workout_progress_service.dart';
import '../service/workout_stats_service.dart';

class AchievementView extends StatefulWidget {
  const AchievementView({super.key});

  @override
  State<AchievementView> createState() =>
      _AchievementViewState();
}

class _AchievementViewState
    extends State<AchievementView> {
  int totalWorkouts = 0;
  double totalCalories = 0;
  int currentStreak = 0;
  int completedDays = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievementData();
  }

  Future<void> _loadAchievementData() async {
    final int workouts =
    await WorkoutStatsService.getWorkout();

    final double calories =
    await WorkoutStatsService.getCalories();

    final int streak =
    await WorkoutStatsService.getStreak();

    int completeCount = 0;

    for (int day = 1; day <= 30; day++) {
      final WorkoutProgress progress =
      await WorkoutProgressService.getProgress(day);

      if (progress.completed) {
        completeCount++;
      }
    }

    if (!mounted) return;

    setState(() {
      totalWorkouts = workouts;
      totalCalories = calories;
      currentStreak = streak;
      completedDays = completeCount;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> achievements = [
      {
        "icon": Icons.fitness_center_rounded,
        "title": "First Workout",
        "subtitle": "Complete your first workout",
        "unlocked": totalWorkouts >= 1,
        "progress": totalWorkouts.clamp(0, 1) / 1,
        "progressText": "${totalWorkouts.clamp(0, 1)} / 1",
      },
      {
        "icon": Icons.local_fire_department_rounded,
        "title": "7 Day Streak",
        "subtitle": "Keep exercising for 7 days",
        "unlocked": currentStreak >= 7,
        "progress": currentStreak.clamp(0, 7) / 7,
        "progressText": "${currentStreak.clamp(0, 7)} / 7",
      },
      {
        "icon": Icons.workspace_premium_rounded,
        "title": "30 Workouts",
        "subtitle": "Complete 30 workouts",
        "unlocked": totalWorkouts >= 30,
        "progress": totalWorkouts.clamp(0, 30) / 30,
        "progressText": "${totalWorkouts.clamp(0, 30)} / 30",
      },
      {
        "icon": Icons.emoji_events_rounded,
        "title": "100 Workouts",
        "subtitle": "Complete 100 workouts",
        "unlocked": totalWorkouts >= 100,
        "progress": totalWorkouts.clamp(0, 100) / 100,
        "progressText": "${totalWorkouts.clamp(0, 100)} / 100",
      },
      {
        "icon": Icons.whatshot_rounded,
        "title": "Burn 1000 Calories",
        "subtitle": "Burn a total of 1000 kcal",
        "unlocked": totalCalories >= 1000,
        "progress": totalCalories.clamp(0, 1000) / 1000,
        "progressText":
        "${totalCalories.clamp(0, 1000).toStringAsFixed(0)} / 1000",
      },
      {
        "icon": Icons.calendar_month_rounded,
        "title": "30 Day Champion",
        "subtitle": "Complete all 30 workout days",
        "unlocked": completedDays >= 30,
        "progress": completedDays.clamp(0, 30) / 30,
        "progressText": "${completedDays.clamp(0, 30)} / 30",
      },
    ];

    final int unlockedCount = achievements
        .where((item) => item["unlocked"] == true)
        .length;

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
        title: const Text(
          "Achievements",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: TColor.primary,
        ),
      )
          : RefreshIndicator(
        color: TColor.primary,
        onRefresh: _loadAchievementData,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TColor.primary,
                    const Color(0xff8748E8),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      color: Colors.white,
                      size: 39,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Achievements",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 7),

                        Text(
                          "$unlockedCount of ${achievements.length} unlocked",
                          style: TextStyle(
                            color:
                            Colors.white.withOpacity(0.88),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 11),

                        ClipRRect(
                          borderRadius:
                          BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: achievements.isEmpty
                                ? 0
                                : unlockedCount /
                                achievements.length,
                            minHeight: 7,
                            backgroundColor:
                            Colors.white.withOpacity(0.25),
                            valueColor:
                            const AlwaysStoppedAnimation<
                                Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Badges",
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 14),

            ...achievements.map(
                  (item) => _achievementCard(
                icon: item["icon"] as IconData,
                title: item["title"].toString(),
                subtitle: item["subtitle"].toString(),
                unlocked: item["unlocked"] as bool,
                progress:
                (item["progress"] as num).toDouble(),
                progressText:
                item["progressText"].toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _achievementCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool unlocked,
    required double progress,
    required String progressText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: unlocked
            ? Colors.white
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: unlocked
              ? TColor.primary.withOpacity(0.28)
              : Colors.grey.shade300,
        ),
        boxShadow: unlocked
            ? const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ]
            : null,
      ),

      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,

            decoration: BoxDecoration(
              color: unlocked
                  ? TColor.primaryLight
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(18),
            ),

            child: Icon(
              icon,
              color: unlocked
                  ? TColor.primary
                  : Colors.grey,
              size: 31,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: unlocked
                              ? TColor.primaryText
                              : Colors.grey.shade700,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),

                      decoration: BoxDecoration(
                        color: unlocked
                            ? Colors.green.withOpacity(0.12)
                            : Colors.grey.shade200,
                        borderRadius:
                        BorderRadius.circular(15),
                      ),

                      child: Row(
                        children: [
                          Icon(
                            unlocked
                                ? Icons.check_circle_rounded
                                : Icons.lock_rounded,
                            color: unlocked
                                ? Colors.green
                                : Colors.grey,
                            size: 15,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            unlocked
                                ? "Unlocked"
                                : "Locked",
                            style: TextStyle(
                              color: unlocked
                                  ? Colors.green
                                  : Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: TColor.sceondarText,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 11),

                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor:
                          Colors.grey.shade200,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(
                            unlocked
                                ? Colors.green
                                : TColor.primary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      progressText,
                      style: TextStyle(
                        color: unlocked
                            ? Colors.green
                            : TColor.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}