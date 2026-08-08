import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../data/extra_workout_data.dart';

class ExtraExerciseDetailView extends StatelessWidget {
  const ExtraExerciseDetailView({
    super.key,
    required this.exercise,
    required this.workoutName,
  });

  final ExtraExerciseItem exercise;
  final String workoutName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFAFE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded, color: TColor.primary),
        ),
        title: Text(
          workoutName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF17131F),
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF3ECFF),
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
            const SizedBox(height: 22),
            Text(
              exercise.name,
              style: const TextStyle(
                color: Color(0xFF17131F),
                fontSize: 27,
                height: 1.08,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            _chip(Icons.timer_outlined, exercise.duration),
            const SizedBox(height: 26),
            _title('How to do it'),
            const SizedBox(height: 8),
            _body(exercise.instruction),
            const SizedBox(height: 22),
            _title('Benefits'),
            const SizedBox(height: 8),
            _body(exercise.benefit),
            const SizedBox(height: 22),
            _title('Focus areas'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: exercise.focusAreas.map((area) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: TColor.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    area,
                    style: TextStyle(
                      color: TColor.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 11.5,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TColor.primary.withOpacity(.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: TColor.primary, size: 18),
          const SizedBox(width: 7),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _title(String text) => Text(
        text,
        style: TextStyle(
          color: TColor.primary,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      );

  Widget _body(String text) => Text(
        text,
        style: TextStyle(
          color: TColor.sceondarText,
          fontSize: 14,
          height: 1.55,
          fontWeight: FontWeight.w500,
        ),
      );
}
