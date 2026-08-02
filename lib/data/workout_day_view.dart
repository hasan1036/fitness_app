import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../data/workout_plan_data.dart';
import '../../data/exercise_details_data.dart';
import '../view/exercise/edit_plan_view.dart';
import '../view/exercise/exercise_detail_view.dart';
import '../view/exercise/exercise_player_view.dart';
import '../service/workout_progress_service.dart';

class WorkoutDayView extends StatefulWidget {
  final int dayNumber;

  const WorkoutDayView({
    super.key,
    required this.dayNumber,
  });

  @override
  State<WorkoutDayView> createState() => _WorkoutDayViewState();
}

class _WorkoutDayViewState extends State<WorkoutDayView> {
  bool warmUp = false;

  late List<Map<String, dynamic>> exercises;
  WorkoutProgress _progress = const WorkoutProgress(
    started: false,
    completed: false,
    currentExerciseIndex: 0,
    totalExercises: 0,
  );

  bool _loadingProgress = true;

  @override
  void initState() {
    super.initState();

    final Map<String, dynamic> data =
    workoutPlanData[widget.dayNumber - 1];

    exercises = List<dynamic>.from(data["exercises"])
        .map<Map<String, dynamic>>(
          (item) => Map<String, dynamic>.from(item),
    )
        .toList();

    _loadProgress();
  }
  Future<void> _loadProgress() async {
    final WorkoutProgress progress =
    await WorkoutProgressService.getProgress(
      widget.dayNumber,
    );

    if (!mounted) return;

    setState(() {
      _progress = progress;
      _loadingProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data =
    workoutPlanData[widget.dayNumber - 1];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TOP HEADER
                    Container(
                      height: 330,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            TColor.purpleSoft,
                            const Color(0xffF7F1FF),
                            Colors.white,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 15,
                            top: 15,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Image.asset(
                              "assets/img/2.png",
                              width: 190,
                              height: 260,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 25,
                            top: 95,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "DAY ${data["day"]}",
                                  style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "LOSE WEIGHT IN 30 DAYS",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: TColor.primaryLight,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.lightbulb_outline,
                                        size: 18,
                                        color: TColor.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "FAQ",
                                        style: TextStyle(
                                          color: TColor.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BASIC + FOCUS AREA
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xffF8F5FC),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Basic",
                                    style: TextStyle(
                                      color: TColor.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 22),
                                  _buildInfoRow(
                                    icon: Icons.local_fire_department,
                                    text: data["calorie"].toString(),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildInfoRow(
                                    icon: Icons.access_time_filled,
                                    text: data["time"].toString(),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildInfoRow(
                                    icon: Icons.layers_rounded,
                                    text: data["level"].toString(),
                                  ),
                                  const SizedBox(height: 25),
                                  InkWell(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Workout settings",
                                            style: TextStyle(
                                              color: TColor.primary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Focus Areas",
                                    style: TextStyle(
                                      color: TColor.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    height: 180,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/img/me1.png",
                                      width: 110,
                                      height: 170,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// WARM-UP
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Text(
                            "Warm-up",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: warmUp,
                            activeColor: TColor.primary,
                            onChanged: (value) {
                              setState(() {
                                warmUp = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// EXERCISE TITLE
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Exercises (${exercises.length})",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () async {
                              final List<Map<String, dynamic>>?
                              updatedExercises =
                              await Navigator.push<
                                  List<Map<String, dynamic>>>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditPlanView(
                                    exercises: exercises,
                                  ),
                                ),
                              );

                              if (updatedExercises != null && mounted) {
                                setState(() {
                                  exercises = updatedExercises
                                      .map(
                                        (item) =>
                                    Map<String, dynamic>.from(item),
                                  )
                                      .toList();
                                });
                              }
                            },
                            child: Text(
                              "Edit >",
                              style: TextStyle(
                                color: TColor.primary,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// EXERCISE LIST
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> exercise =
                        Map<String, dynamic>.from(
                          exercises[index],
                        );

                        return _buildExerciseItem(
                          exercise,
                          index,
                        );
                      },
                    ),

                    const SizedBox(height: 110),
                  ],
                ),
              ),
            ),

            /// START BUTTON
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                18,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _loadingProgress
                      ? null
                      : () async {
                    final List<Map<String, dynamic>> playerExercises =
                    exercises.map<Map<String, dynamic>>((item) {
                      return Map<String, dynamic>.from(item);
                    }).toList();

                    int startIndex = 0;

                    if (_progress.started && !_progress.completed) {
                      startIndex = _progress.currentExerciseIndex;
                    }

                    if (startIndex < 0 ||
                        startIndex >= playerExercises.length) {
                      startIndex = 0;
                    }

                    // REPEAT করলে প্রথম exercise থেকে শুরু হবে।
                    // এখানে resetWorkout() বা markStatsCounted() call হবে না।
                    if (_progress.completed) {
                      startIndex = 0;
                    }

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExercisePlayerView(
                          exercises: playerExercises,
                          dayNumber: widget.dayNumber,
                          startIndex: startIndex,
                        ),
                      ),
                    );

                    if (!mounted) return;

                    await _loadProgress();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23),
                    ),
                  ),
                  child: Text(
                    _loadingProgress
                        ? "LOADING..."
                        : _progress.buttonText,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: 25,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseItem(
      Map<String, dynamic> exercise,
      int index,
      ) {
    /// এই exercise শেষ হয়েছে কি না
    final bool isCompleted =
        _progress.completed ||
            (_progress.started &&
                index < _progress.currentExerciseIndex);

    /// বর্তমানে এই exercise-টাই চলবে কি না
    final bool isCurrent =
        _progress.started &&
            !_progress.completed &&
            index == _progress.currentExerciseIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 7,
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(18),

        onTap: () {
          final String exerciseName =
          exercise["name"].toString();

          final Map<String, dynamic>? details =
          exerciseDetailsData[exerciseName];

          if (details == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "$exerciseName exercise-এর details পাওয়া যায়নি",
                ),
              ),
            );
            return;
          }

          final List<Map<String, dynamic>>
          fullExerciseDetails = [];

          for (final Map<String, dynamic> item
          in exercises) {
            final Map<String, dynamic> workoutExercise =
            Map<String, dynamic>.from(item);

            final String name =
            workoutExercise["name"].toString();

            final Map<String, dynamic>? detail =
            exerciseDetailsData[name];

            if (detail != null) {
              fullExerciseDetails.add({
                ...detail,
                "value": workoutExercise["value"] ??
                    detail["value"],
                "gif": workoutExercise["gif"] ??
                    detail["gif"],
              });
            }
          }

          if (fullExerciseDetails.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Exercise details পাওয়া যায়নি",
                ),
              ),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExerciseDetailView(
                exercises: fullExerciseDetails,
                initialIndex: index,
              ),
            ),
          );
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),

          padding: const EdgeInsets.all(10),

          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green.withOpacity(0.08)
                : isCurrent
                ? TColor.primaryLight
                : Colors.white,

            borderRadius: BorderRadius.circular(18),

            border: Border.all(
              width: isCurrent ? 2 : 1,

              color: isCompleted
                  ? Colors.green.withOpacity(0.35)
                  : isCurrent
                  ? TColor.primary
                  : const Color(0xffEEEAF2),
            ),

            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),

          child: Row(
            children: [
              /// GIF + CHECK MARK

              Stack(
                children: [
                  Container(
                    width: 110,
                    height: 95,

                    decoration: BoxDecoration(
                      color: const Color(0xffFAF8FD),
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),

                      child: Opacity(
                        opacity: isCompleted ? 0.45 : 1.0,

                        child: Image.asset(
                          exercise["gif"].toString(),
                          fit: BoxFit.contain,

                          errorBuilder: (
                              context,
                              error,
                              stackTrace,
                              ) {
                            return Icon(
                              Icons.fitness_center,
                              color: TColor.primary,
                              size: 35,
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  if (isCompleted)
                    Positioned(
                      right: 6,
                      top: 6,

                      child: Container(
                        width: 28,
                        height: 28,

                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ),

                  if (isCurrent)
                    Positioned(
                      left: 6,
                      top: 6,

                      child: Container(
                        width: 28,
                        height: 28,

                        decoration: BoxDecoration(
                          color: TColor.primary,
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 17),

              /// NAME + STATUS

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      exercise["name"].toString(),

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,

                        color: isCompleted
                            ? Colors.black54
                            : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      isCompleted
                          ? "Completed"
                          : isCurrent
                          ? "Current Exercise"
                          : exercise["value"].toString(),

                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isCompleted || isCurrent
                            ? FontWeight.w700
                            : FontWeight.w500,

                        color: isCompleted
                            ? Colors.green
                            : isCurrent
                            ? TColor.primary
                            : TColor.sceondarText,
                      ),
                    ),

                    if (isCompleted) ...[
                      const SizedBox(height: 4),

                      Text(
                        exercise["value"].toString(),

                        style: TextStyle(
                          fontSize: 13,
                          color: TColor.sceondarText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              Icon(
                isCompleted
                    ? Icons.check_circle_outline
                    : Icons.arrow_forward_ios,

                size: isCompleted ? 23 : 17,

                color: isCompleted
                    ? Colors.green
                    : isCurrent
                    ? TColor.primary
                    : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}