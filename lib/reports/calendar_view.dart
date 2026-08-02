import 'package:flutter/material.dart';

import '../common/color_extention.dart';
import '../service/workout_progress_service.dart';

class WorkoutCalendarView extends StatefulWidget {
  const WorkoutCalendarView({super.key});

  @override
  State<WorkoutCalendarView> createState() =>
      _WorkoutCalendarViewState();
}

class _WorkoutCalendarViewState
    extends State<WorkoutCalendarView> {
  DateTime selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  bool isLoading = true;

  final Map<String, List<Map<String, dynamic>>>
  completedWorkoutMap = {};

  static const List<String> monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  static const List<String> weekDays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  @override
  void initState() {
    super.initState();
    _loadCompletedWorkouts();
  }

  Future<void> _loadCompletedWorkouts() async {
    final Map<String, List<Map<String, dynamic>>> result = {};

    for (int day = 1; day <= 30; day++) {
      final WorkoutProgress progress =
      await WorkoutProgressService.getProgress(day);

      if (!progress.completed ||
          progress.completedDate == null) {
        continue;
      }

      final String dateKey = progress.completedDate!;

      result.putIfAbsent(
        dateKey,
            () => [],
      );

      result[dateKey]!.add({
        "dayNumber": day,
        "completedTime": progress.completedTime ?? "",
        "totalExercises": progress.totalExercises,
      });
    }

    if (!mounted) return;

    setState(() {
      completedWorkoutMap
        ..clear()
        ..addAll(result);

      isLoading = false;
    });
  }

  String _dateKey(DateTime date) {
    return "${date.year}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  bool _isToday(DateTime date) {
    final DateTime now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  void _previousMonth() {
    setState(() {
      selectedMonth = DateTime(
        selectedMonth.year,
        selectedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      selectedMonth = DateTime(
        selectedMonth.year,
        selectedMonth.month + 1,
      );
    });
  }

  String _formatTime(String savedTime) {
    if (savedTime.isEmpty ||
        !savedTime.contains(":")) {
      return "Time unavailable";
    }

    final List<String> parts = savedTime.split(":");

    int hour = int.tryParse(parts[0]) ?? 0;
    final int minute =
        int.tryParse(parts[1]) ?? 0;

    final String period =
    hour >= 12 ? "PM" : "AM";

    hour = hour % 12;

    if (hour == 0) {
      hour = 12;
    }

    return "$hour:"
        "${minute.toString().padLeft(2, '0')} "
        "$period";
  }

  String _formatFullDate(DateTime date) {
    return "${monthNames[date.month - 1]} "
        "${date.day}, ${date.year}";
  }

  List<DateTime?> _buildCalendarDays() {
    final int totalDays =
    DateUtils.getDaysInMonth(
      selectedMonth.year,
      selectedMonth.month,
    );

    final DateTime firstDay = DateTime(
      selectedMonth.year,
      selectedMonth.month,
      1,
    );

    final int leadingEmptyDays =
        firstDay.weekday - 1;

    final List<DateTime?> calendarDays = [];

    for (int i = 0; i < leadingEmptyDays; i++) {
      calendarDays.add(null);
    }

    for (int day = 1; day <= totalDays; day++) {
      calendarDays.add(
        DateTime(
          selectedMonth.year,
          selectedMonth.month,
          day,
        ),
      );
    }

    while (calendarDays.length % 7 != 0) {
      calendarDays.add(null);
    }

    return calendarDays;
  }

  void _showDateDetails(DateTime date) {
    final String key = _dateKey(date);

    final List<Map<String, dynamic>> workouts =
        completedWorkoutMap[key] ?? [];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            30,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  _formatFullDate(date),
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 18),

                if (workouts.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xffF7F3FD),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event_available_outlined,
                          color: TColor.primary,
                          size: 48,
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          "No Workout Completed",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "No completed workout was found for this date.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TColor.sceondarText,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...workouts.map(
                        (workout) => Container(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xffF7F3FD),
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: TColor.primaryLight,
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.fitness_center_rounded,
                              color: TColor.primary,
                              size: 26,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Day ${workout["dayNumber"]}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.w800,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  _formatTime(
                                    workout["completedTime"]
                                        .toString(),
                                  ),
                                  style: TextStyle(
                                    color:
                                    TColor.sceondarText,
                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(height: 3),

                                Text(
                                  "${workout["totalExercises"]} exercises",
                                  style: TextStyle(
                                    color:
                                    TColor.sceondarText,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green
                                  .withOpacity(0.12),
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Completed",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime?> calendarDays =
    _buildCalendarDays();

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
          "Workout Calendar",
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
        onRefresh: _loadCompletedWorkouts,
        child: ListView(
          physics:
          const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10000000),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: _previousMonth,
                        icon: Icon(
                          Icons
                              .arrow_back_ios_new_rounded,
                          color: TColor.primary,
                          size: 19,
                        ),
                      ),

                      Expanded(
                        child: Text(
                          "${monthNames[selectedMonth.month - 1]} "
                              "${selectedMonth.year}",
                          textAlign:
                          TextAlign.center,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 21,
                            fontWeight:
                            FontWeight.w900,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: _nextMonth,
                        icon: Icon(
                          Icons
                              .arrow_forward_ios_rounded,
                          color: TColor.primary,
                          size: 19,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: weekDays
                        .map(
                          (day) => Expanded(
                        child: Text(
                          day,
                          textAlign:
                          TextAlign.center,
                          style: TextStyle(
                            color:
                            TColor.sceondarText,
                            fontSize: 12,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),

                  const SizedBox(height: 10),

                  GridView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemCount: calendarDays.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final DateTime? date =
                      calendarDays[index];

                      if (date == null) {
                        return const SizedBox();
                      }

                      final String key =
                      _dateKey(date);

                      final bool completed =
                      completedWorkoutMap
                          .containsKey(key);

                      final bool today =
                      _isToday(date);

                      return InkWell(
                        borderRadius:
                        BorderRadius.circular(30),
                        onTap: () {
                          _showDateDetails(date);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 220,
                          ),
                          decoration: BoxDecoration(
                            color: completed
                                ? TColor.primary
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: today ? 2 : 1,
                              color: today
                                  ? Colors.green
                                  : completed
                                  ? TColor.primary
                                  : Colors.transparent,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: completed
                                  ? Colors.white
                                  : today
                                  ? Colors.green
                                  : TColor.primaryText,
                              fontSize: 14,
                              fontWeight:
                              completed || today
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceAround,
                children: [
                  _legendItem(
                    color: TColor.primary,
                    label: "Completed",
                  ),
                  _legendItem(
                    color: Colors.green,
                    label: "Today",
                    outlined: true,
                  ),
                  _legendItem(
                    color: Colors.grey.shade300,
                    label: "No Workout",
                    outlined: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem({
    required Color color,
    required String label,
    bool outlined = false,
  }) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: outlined
                ? Colors.transparent
                : color,
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
        ),

        const SizedBox(width: 6),

        Text(
          label,
          style: TextStyle(
            color: TColor.sceondarText,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}