import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../data/extra_workout_data.dart';

class ExtraWorkoutPlayerView extends StatefulWidget {
  const ExtraWorkoutPlayerView({super.key, required this.workout});

  final ExtraWorkoutItem workout;

  @override
  State<ExtraWorkoutPlayerView> createState() => _ExtraWorkoutPlayerViewState();
}

class _ExtraWorkoutPlayerViewState extends State<ExtraWorkoutPlayerView> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final exercise = widget.workout.exercises[index];
    return Scaffold(
      backgroundColor: const Color(0xFF130D2D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      widget.workout.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const Spacer(),
              Container(
                height: 310,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Image.asset(
                  exercise.asset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.accessibility_new_rounded,
                    color: TColor.primary,
                    size: 110,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '${index + 1} / ${widget.workout.exercises.length}',
                style: TextStyle(color: TColor.primaryLight, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                exercise.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                exercise.duration,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filledTonal(
                    onPressed: index == 0 ? null : () => setState(() => index--),
                    icon: const Icon(Icons.skip_previous_rounded),
                  ),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: () {
                      if (index < widget.workout.exercises.length - 1) {
                        setState(() => index++);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 74,
                      height: 74,
                      decoration: BoxDecoration(
                        color: TColor.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 38),
                    ),
                  ),
                  const SizedBox(width: 24),
                  IconButton.filledTonal(
                    onPressed: () {
                      if (index < widget.workout.exercises.length - 1) {
                        setState(() => index++);
                      }
                    },
                    icon: const Icon(Icons.skip_next_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
