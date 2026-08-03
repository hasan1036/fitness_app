import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/color_extention.dart';
import '../../service/water_history_service.dart';
import '../../models/water_history_model.dart';
import '../reminder/water_reminder_view.dart';

class WaterTrackerView extends StatefulWidget {
  const WaterTrackerView({super.key});

  @override
  State<WaterTrackerView> createState() =>
      _WaterTrackerViewState();
}

class _WaterTrackerViewState
    extends State<WaterTrackerView> {
  static const String _waterDateKey =
      "water_tracker_date";

  static const String _waterCountKey =
      "water_tracker_count";

  static const String _waterGoalKey =
      "water_tracker_goal";

  int waterCount = 0;
  int dailyGoal = 8;

  bool isLoading = true;

  List<WaterHistoryModel> waterHistory = [];
  int weeklyTotalMl = 0;
  int weeklyAverageMl = 0;
  String bestDay = "No data";
  int currentStreak = 0;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  String _todayDate() {
    final DateTime now = DateTime.now();

    return "${now.year}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.day.toString().padLeft(2, '0')}";
  }

  Future<void> _loadAllData() async {
    await _loadWaterData();
    await _loadWaterHistory();
  }

  Future<void> _loadWaterHistory() async {
    final List<WaterHistoryModel> history =
    await WaterHistoryService.loadHistory();

    history.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    final DateTime today = DateTime.now();
    final DateTime startDate = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(
      const Duration(days: 6),
    );

    final List<WaterHistoryModel> lastSevenDays =
    history.where((item) {
      final DateTime? parsedDate =
      DateTime.tryParse(item.date);

      if (parsedDate == null) {
        return false;
      }

      final DateTime cleanDate = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
      );

      return !cleanDate.isBefore(startDate) &&
          !cleanDate.isAfter(
            DateTime(
              today.year,
              today.month,
              today.day,
            ),
          );
    }).toList();

    int total = 0;
    int bestAmount = 0;
    String bestDate = "No data";

    for (final WaterHistoryModel item
    in lastSevenDays) {
      total += item.milliliters;

      if (item.milliliters > bestAmount) {
        bestAmount = item.milliliters;
        bestDate = item.date;
      }
    }

    final int average = lastSevenDays.isEmpty
        ? 0
        : (total / lastSevenDays.length).round();

    int streak = 0;
    for (int i = 0; i < 365; i++) {
      final DateTime date = DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(
        Duration(days: i),
      );

      final String dateKey =
          "${date.year}-"
          "${date.month.toString().padLeft(2, '0')}-"
          "${date.day.toString().padLeft(2, '0')}";

      WaterHistoryModel? entry;

      for (final WaterHistoryModel item in history) {
        if (item.date == dateKey) {
          entry = item;
          break;
        }
      }

      if (entry == null || entry.glasses <= 0) {
        break;
      }

      streak++;
    }

    if (!mounted) return;

    setState(() {
      waterHistory = history.take(7).toList();
      weeklyTotalMl = total;
      weeklyAverageMl = average;
      bestDay = bestDate == "No data"
          ? "No data"
          : _formatHistoryDate(bestDate);
      currentStreak = streak;
    });
  }

  Future<void> _loadWaterData() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    final String today = _todayDate();

    final String savedDate =
        prefs.getString(_waterDateKey) ?? "";

    int savedCount =
        prefs.getInt(_waterCountKey) ?? 0;

    final int savedGoal =
        prefs.getInt(_waterGoalKey) ?? 8;

    if (savedDate != today) {
      savedCount = 0;

      await prefs.setString(
        _waterDateKey,
        today,
      );

      await prefs.setInt(
        _waterCountKey,
        0,
      );
    }

    if (!mounted) return;

    setState(() {
      waterCount = savedCount;
      dailyGoal = savedGoal;
      isLoading = false;
    });
  }

  Future<void> _saveWaterData() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      _waterDateKey,
      _todayDate(),
    );

    await prefs.setInt(
      _waterCountKey,
      waterCount,
    );

    await prefs.setInt(
      _waterGoalKey,
      dailyGoal,
    );

    await WaterHistoryService.saveToday(
      glasses: waterCount,
    );

    await _loadWaterHistory();
  }
  Future<void> _addWater() async {
    if (waterCount >= dailyGoal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Daily water goal already completed",
          ),
        ),
      );
      return;
    }

    setState(() {
      waterCount++;
    });

    await _saveWaterData();

    if (!mounted) return;

    if (waterCount == dailyGoal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Congratulations! Daily water goal completed.",
          ),
        ),
      );
    }
  }

  Future<void> _removeWater() async {
    if (waterCount <= 0) {
      return;
    }

    setState(() {
      waterCount--;
    });

    await _saveWaterData();
  }

  Future<void> _resetToday() async {
    final bool? confirm =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Reset Today's Water?",
          ),
          content: const Text(
            "Today's water progress will become zero.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text("Reset"),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) {
      return;
    }

    setState(() {
      waterCount = 0;
    });

    await _saveWaterData();
  }

  Future<void> _showGoalDialog() async {
    int selectedGoal = dailyGoal;

    final int? result =
    await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {
            return AlertDialog(
              title: const Text(
                "Set Daily Water Goal",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$selectedGoal Glasses",
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: selectedGoal > 1
                            ? () {
                          setDialogState(() {
                            selectedGoal--;
                          });
                        }
                            : null,
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          size: 34,
                        ),
                      ),
                      const SizedBox(width: 25),
                      IconButton(
                        onPressed: selectedGoal < 20
                            ? () {
                          setDialogState(() {
                            selectedGoal++;
                          });
                        }
                            : null,
                        icon: const Icon(
                          Icons.add_circle_outline,
                          size: 34,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      selectedGoal,
                    );
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      dailyGoal = result;

      if (waterCount > dailyGoal) {
        waterCount = dailyGoal;
      }
    });

    await _saveWaterData();
  }

  double get progress {
    if (dailyGoal <= 0) {
      return 0;
    }

    return (waterCount / dailyGoal)
        .clamp(0.0, 1.0);
  }

  int get waterMilliliters {
    return waterCount * 250;
  }

  int get goalMilliliters {
    return dailyGoal * 250;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xffF7F3FD),

      appBar: AppBar(
        backgroundColor:
        const Color(0xffF7F3FD),
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
          "Water Tracker",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),

        actions: [
          IconButton(
            onPressed: _resetToday,
            icon: Icon(
              Icons.restart_alt_rounded,
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
        padding:
        const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),
        children: [
          _buildHeader(),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  icon:
                  Icons.water_drop_rounded,
                  title: "Drunk",
                  value:
                  "$waterMilliliters ml",
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _summaryCard(
                  icon:
                  Icons.flag_rounded,
                  title: "Daily Goal",
                  value:
                  "$goalMilliliters ml",
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          Row(
            children: [
              Expanded(
                child: Text(
                  "Today's Glasses",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 21,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),

              TextButton.icon(
                onPressed:
                _showGoalDialog,
                icon: Icon(
                  Icons.edit_rounded,
                  color: TColor.primary,
                  size: 18,
                ),
                label: Text(
                  "Edit Goal",
                  style: TextStyle(
                    color: TColor.primary,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildGlassGrid(),

          const SizedBox(height: 26),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed:
                    _removeWater,
                    icon: const Icon(
                      Icons.remove_rounded,
                    ),
                    label: const Text(
                      "Remove",
                    ),
                    style:
                    OutlinedButton.styleFrom(
                      foregroundColor:
                      TColor.primary,
                      side: BorderSide(
                        color: TColor.primary,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _addWater,
                    icon: const Icon(
                      Icons.add_rounded,
                    ),
                    label: const Text(
                      "ADD 1 GLASS",
                      style: TextStyle(
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      TColor.primary,
                      foregroundColor:
                      Colors.white,
                      elevation: 0,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          Text(
            "Water History",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          _buildHistorySection(),

          const SizedBox(height: 28),

          Text(
            "Weekly Statistics",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          _buildWeeklyStatistics(),

          const SizedBox(height: 20),

          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WaterReminderView(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: TColor.primaryLight,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.notifications_active_rounded,
                      color: TColor.primary,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Water Reminder",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Set water reminder time",
                          style: TextStyle(
                            color: TColor.sceondarText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: TColor.primary,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
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
        borderRadius:
        BorderRadius.circular(24),
      ),

      child: Column(
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 138,
                  height: 138,
                  child:
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor:
                    Colors.white24,
                    valueColor:
                    const AlwaysStoppedAnimation<
                        Color>(
                      Colors.white,
                    ),
                  ),
                ),

                Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.water_drop_rounded,
                      color: Colors.white,
                      size: 38,
                    ),

                    const SizedBox(height: 7),

                    Text(
                      "$waterCount / $dailyGoal",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight:
                        FontWeight.w900,
                      ),
                    ),

                    const Text(
                      "Glasses",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            waterCount >= dailyGoal
                ? "Daily Goal Completed!"
                : "Keep drinking water",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            waterCount >= dailyGoal
                ? "Great job! You reached today's target."
                : "${dailyGoal - waterCount} glasses remaining today.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
              Colors.white.withOpacity(0.85),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: TColor.primaryLight,
              borderRadius:
              BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: TColor.primary,
            ),
          ),

          const SizedBox(height: 13),

          Text(
            value,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: TextStyle(
              color: TColor.sceondarText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassGrid() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(22),
      ),

      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: List.generate(
          dailyGoal,
              (index) {
            final bool completed =
                index < waterCount;

            return AnimatedContainer(
              duration: const Duration(
                milliseconds: 220,
              ),
              width: 52,
              height: 64,
              decoration: BoxDecoration(
                color: completed
                    ? TColor.primary
                    : TColor.primaryLight,
                borderRadius:
                BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.local_drink_rounded,
                color: completed
                    ? Colors.white
                    : TColor.primary,
                size: 29,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    if (waterHistory.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Icon(
              Icons.history_rounded,
              color: TColor.primary,
              size: 42,
            ),
            const SizedBox(height: 10),
            const Text(
              "No Water History Yet",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Add water to start building your daily history.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TColor.sceondarText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: List.generate(
          waterHistory.length,
              (index) {
            final WaterHistoryModel item =
            waterHistory[index];

            final bool completedGoal =
                item.glasses >= dailyGoal;

            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: TColor.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.water_drop_rounded,
                      color: TColor.primary,
                    ),
                  ),
                  title: Text(
                    _historyDateLabel(item.date),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Text(
                    "${item.glasses} glasses",
                    style: TextStyle(
                      color: TColor.sceondarText,
                      fontSize: 12,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    crossAxisAlignment:
                    CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${item.milliliters} ml",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (completedGoal)
                        const Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green,
                            size: 17,
                          ),
                        ),
                    ],
                  ),
                ),
                if (index != waterHistory.length - 1)
                  const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWeeklyStatistics() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _statRowItem(
                  icon: Icons.water_drop_rounded,
                  title: "Total",
                  value:
                  "${(weeklyTotalMl / 1000).toStringAsFixed(1)} L",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statRowItem(
                  icon: Icons.calculate_rounded,
                  title: "Average",
                  value: "$weeklyAverageMl ml",
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _statRowItem(
                  icon: Icons.emoji_events_rounded,
                  title: "Best Day",
                  value: bestDay,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statRowItem(
                  icon: Icons.local_fire_department_rounded,
                  title: "Streak",
                  value: "$currentStreak days",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statRowItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffF7F3FD),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: TColor.primary,
            size: 23,
          ),
          const SizedBox(height: 9),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(
              color: TColor.sceondarText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _historyDateLabel(String savedDate) {
    final DateTime? date = DateTime.tryParse(savedDate);

    if (date == null) {
      return savedDate;
    }

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final DateTime cleanDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    if (cleanDate == today) {
      return "Today";
    }

    if (cleanDate ==
        today.subtract(const Duration(days: 1))) {
      return "Yesterday";
    }

    return _formatHistoryDate(savedDate);
  }

  String _formatHistoryDate(String savedDate) {
    final DateTime? date = DateTime.tryParse(savedDate);

    if (date == null) {
      return savedDate;
    }

    const List<String> weekdays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    return weekdays[date.weekday - 1];
  }

}