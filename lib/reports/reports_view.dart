import 'package:flutter/material.dart';

import '../common/color_extention.dart';
import '../service/workout_progress_service.dart';
import '../service/workout_stats_service.dart';
import 'achievement_view.dart';
import 'workout_history_view.dart';
import 'weight_progress_view.dart';
import 'achievement_view.dart';
import 'workout_history_view.dart';
import 'calendar_view.dart';

import '../l10n/app_localizations.dart';
class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  int completedDays = 0;
  int totalWorkouts = 0;
  double totalCalories = 0;
  int currentStreak = 0;

  List<bool> weeklyCompleted =
  List.filled(7, false);
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    final int workouts =
    await WorkoutStatsService.getWorkout();

    final double calories =
    await WorkoutStatsService.getCalories();

    final int streak =
    await WorkoutStatsService.getStreak();

    int count = 0;

    /// Monday থেকে Sunday পর্যন্ত ৭টি item
    final List<bool> currentWeek =
    List<bool>.filled(7, false);

    final DateTime now = DateTime.now();

    /// চলতি সপ্তাহের Monday
    final DateTime startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(
      Duration(days: now.weekday - 1),
    );

    /// চলতি সপ্তাহের Sunday-এর পরের দিন
    final DateTime endOfWeek =
    startOfWeek.add(const Duration(days: 7));

    for (int day = 1; day <= 30; day++) {
      final WorkoutProgress progress =
      await WorkoutProgressService.getProgress(day);

      if (progress.completed) {
        count++;

        final String? savedDate =
            progress.completedDate;

        if (savedDate == null) {
          continue;
        }

        final DateTime? parsedDate =
        DateTime.tryParse(savedDate);

        if (parsedDate == null) {
          continue;
        }

        final DateTime completedDay = DateTime(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
        );

        /// শুধু চলতি সপ্তাহের workout দেখাবে
        final bool isInsideCurrentWeek =
            !completedDay.isBefore(startOfWeek) &&
                completedDay.isBefore(endOfWeek);

        if (isInsideCurrentWeek) {
          /// Monday = index 0, Sunday = index 6
          currentWeek[completedDay.weekday - 1] = true;
        }
      }
    }

    if (!mounted) return;

    setState(() {
      totalWorkouts = workouts;
      totalCalories = calories;
      currentStreak = streak;
      completedDays = count;
      weeklyCompleted = currentWeek;
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
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

        title: Text(context.tr('reports'),
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        top: false,

        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Workout Summary",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      icon: Icons.fitness_center_rounded,
                      title: "Workouts",
                      value: isLoading
                          ? "..."
                          : totalWorkouts.toString(),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _summaryCard(
                      icon: Icons.local_fire_department_rounded,
                      title: "Calories",
                      value: isLoading
                          ? "..."
                          : "${totalCalories.toStringAsFixed(0)} kcal",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      icon: Icons.bolt_rounded,
                      title: "Streak",
                      value: isLoading
                          ? "..."
                          : "$currentStreak Days",
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _summaryCard(
                      icon: Icons.check_circle_rounded,
                      title: "Completed",
                      value: isLoading
                          ? "..."
                          : "$completedDays / 30",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Text(
                "Weekly Progress",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),

                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 14,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                      children: const [
                        Text("Mon"),
                        Text("Tue"),
                        Text("Wed"),
                        Text("Thu"),
                        Text("Fri"),
                        Text("Sat"),
                        Text("Sun"),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                      children: List.generate(
                        7,
                            (index) {
                          final bool completed =
                          weeklyCompleted[index];

                          return AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 250,
                            ),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: completed
                                  ? TColor.primary
                                  : TColor.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              completed
                                  ? Icons.check_rounded
                                  : Icons.remove_rounded,
                              color: completed
                                  ? Colors.white
                                  : TColor.primary,
                              size: 18,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Text(
                "More Reports",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 14),

              _reportTile(
                icon: Icons.calendar_month_rounded,
                title: "Workout Calendar",
                subtitle: "See your completed workout days",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WorkoutCalendarView(),
                    ),
                  );
                },
              ),

              _reportTile(
                icon: Icons.monitor_weight_rounded,
                title: "Weight Progress",
                subtitle: "Track your weight changes",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WeightProgressView(),
                    ),
                  );
                },
              ),

              _reportTile(
                icon: Icons.history_rounded,
                title: "Workout History",
                subtitle: "View your previous workouts",

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const WorkoutHistoryView(),
                    ),
                  );
                },
              ),

              _reportTile(
                icon: Icons.emoji_events_rounded,
                title: "Achievements",
                subtitle: "See your badges and milestones",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AchievementView(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: TColor.primaryLight,
              borderRadius: BorderRadius.circular(13),
            ),

            child: Icon(
              icon,
              color: TColor.primary,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            value,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: TextStyle(
              color: TColor.sceondarText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reportTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),

        leading: Container(
          width: 46,
          height: 46,

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
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),

        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: TColor.sceondarText,
            fontSize: 12,
          ),
        ),

        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: TColor.primary,
          size: 17,
        ),

        onTap: onTap,
      ),
    );
  }
}
