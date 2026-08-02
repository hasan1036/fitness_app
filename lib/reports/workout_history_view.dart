import 'package:flutter/material.dart';

import '../common/color_extention.dart';
import '../service/workout_progress_service.dart';

class WorkoutHistoryView extends StatefulWidget {
  const WorkoutHistoryView({super.key});

  @override
  State<WorkoutHistoryView> createState() =>
      _WorkoutHistoryViewState();
}

class _WorkoutHistoryViewState
    extends State<WorkoutHistoryView> {
  bool isLoading = true;

  List<Map<String, dynamic>> workoutHistory = [];

  @override
  void initState() {
    super.initState();

    _loadWorkoutHistory();
  }

  Future<void> _loadWorkoutHistory() async {
    final List<Map<String, dynamic>> history = [];

    for (int day = 1; day <= 30; day++) {
      final WorkoutProgress progress =
      await WorkoutProgressService.getProgress(day);

      if (progress.completed &&
          progress.completedDate != null) {
        history.add({
          "day": day,
          "date": progress.completedDate!,
          "time": progress.completedTime ?? "",
        });
      }
    }

    history.sort((a, b) {
      final String first =
          "${a["date"]} ${a["time"]}";

      final String second =
          "${b["date"]} ${b["time"]}";

      return second.compareTo(first);
    });

    if (!mounted) return;

    setState(() {
      workoutHistory = history;
      isLoading = false;
    });
  }

  String _formatDate(String savedDate) {
    final DateTime? date =
    DateTime.tryParse(savedDate);

    if (date == null) {
      return savedDate;
    }

    final DateTime now = DateTime.now();

    final DateTime today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final DateTime workoutDay = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final int difference =
        today.difference(workoutDay).inDays;

    if (difference == 0) {
      return "Today";
    }

    if (difference == 1) {
      return "Yesterday";
    }

    const List<String> months = [
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

    return "${date.day} "
        "${months[date.month - 1]} "
        "${date.year}";
  }

  String _formatTime(String savedTime) {
    if (savedTime.isEmpty ||
        !savedTime.contains(":")) {
      return "";
    }

    final List<String> parts =
    savedTime.split(":");

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
          "Workout History",

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
          : workoutHistory.isEmpty
          ? _buildEmptyView()
          : RefreshIndicator(
        color: TColor.primary,

        onRefresh:
        _loadWorkoutHistory,

        child: ListView.builder(
          padding:
          const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),

          itemCount:
          workoutHistory.length,

          itemBuilder:
              (context, index) {
            final Map<String, dynamic>
            item =
            workoutHistory[index];

            return _buildHistoryCard(
              dayNumber:
              item["day"] as int,

              date: item["date"]
                  .toString(),

              time: item["time"]
                  .toString(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            Container(
              width: 105,
              height: 105,

              decoration: BoxDecoration(
                color: TColor.primaryLight,
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.history_rounded,
                color: TColor.primary,
                size: 55,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              "No Workout History",

              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Complete your first workout to see it here.",

              textAlign: TextAlign.center,

              style: TextStyle(
                color: TColor.sceondarText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required int dayNumber,
    required String date,
    required String time,
  }) {
    return Container(
      margin:
      const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(20),

        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,

            decoration: BoxDecoration(
              color: TColor.primaryLight,

              borderRadius:
              BorderRadius.circular(16),
            ),

            child: Icon(
              Icons.fitness_center_rounded,
              color: TColor.primary,
              size: 27,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  "Day $dayNumber",

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  _formatDate(date),

                  style: TextStyle(
                    color: TColor.sceondarText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (time.isNotEmpty) ...[
                  const SizedBox(height: 3),

                  Text(
                    _formatTime(time),

                    style: TextStyle(
                      color: TColor.sceondarText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 7,
            ),

            decoration: BoxDecoration(
              color:
              Colors.green.withOpacity(0.10),

              borderRadius:
              BorderRadius.circular(20),
            ),

            child: const Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 17,
                ),

                SizedBox(width: 5),

                Text(
                  "Completed",

                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}