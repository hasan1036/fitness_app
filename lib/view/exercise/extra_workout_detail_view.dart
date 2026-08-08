import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../data/extra_workout_data.dart';
import 'extra_exercise_detail_view.dart';
import 'extra_workout_player_view.dart';

class ExtraWorkoutDetailView extends StatelessWidget {
  const ExtraWorkoutDetailView({super.key, required this.workout});

  final ExtraWorkoutItem workout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFAFE),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: 300,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF17131F),
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Material(
                color: Colors.black.withOpacity(.30),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                ),
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final collapsed = constraints.maxHeight < 120;
                return FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 64, bottom: 15, right: 18),
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 140),
                    opacity: collapsed ? 1 : 0,
                    child: Text(
                      workout.name.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF17131F),
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        workout.coverImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: TColor.primaryLight,
                          child: Icon(Icons.fitness_center_rounded, color: TColor.primary, size: 90),
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x18000000), Color(0x6A000000)],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: _overview()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 10),
              child: Row(
                children: [
                  Text(
                    'Exercises (${workout.exercises.length})',
                    style: const TextStyle(
                      color: Color(0xFF17131F),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Edit ›',
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 110),
            sliver: SliverList.separated(
              itemCount: workout.exercises.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFECE8F2)),
              itemBuilder: (context, index) => _exerciseTile(context, workout.exercises[index]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
          child: SizedBox(
            height: 58,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ExtraWorkoutPlayerView(workout: workout)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text(
                'START',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _overview() {
    return Transform.translate(
      offset: const Offset(0, -24),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: TColor.primary.withOpacity(.06)),
          boxShadow: [
            BoxShadow(
              color: TColor.primary.withOpacity(.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workout.name,
              style: const TextStyle(
                color: Color(0xFF17131F),
                fontSize: 27,
                height: 1.08,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Instruction',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                ),
                const Spacer(),
                Text(
                  'FAQ  ›',
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              workout.instruction,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: TColor.sceondarText,
                fontSize: 13.5,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F4FB),
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
                          'Basic',
                          style: TextStyle(
                            color: TColor.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _stat(
                          Icons.local_fire_department_rounded,
                          '${workout.kcal.toStringAsFixed(1)} kcal',
                        ),
                        const SizedBox(height: 13),
                        _stat(Icons.schedule_rounded, '${workout.minutes} min'),
                        const SizedBox(height: 13),
                        _stat(Icons.layers_rounded, workout.level),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 132,
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    color: TColor.primary.withOpacity(.08),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Focus Areas',
                            style: TextStyle(
                              color: TColor.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 78,
                          height: 92,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: TColor.primary.withOpacity(.08),
                            ),
                          ),
                          child: Icon(
                            Icons.accessibility_new_rounded,
                            color: TColor.primary,
                            size: 54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          workout.focusAreas.take(2).join(' • '),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: TColor.sceondarText,
                            fontSize: 9.5,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F4FB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.tune_rounded, color: TColor.primary, size: 20),
                  const SizedBox(width: 9),
                  Text(
                    'Workout settings',
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: TColor.sceondarText,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: TColor.primary, size: 22),
        const SizedBox(width: 9),
        Expanded(
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        ),
      ],
    );
  }

  Widget _exerciseTile(BuildContext context, ExtraExerciseItem exercise) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExtraExerciseDetailView(
              exercise: exercise,
              workoutName: workout.name,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 90,
              height: 90,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F2FF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Image.asset(
                exercise.asset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.accessibility_new_rounded, color: TColor.primary, size: 38),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF17131F),
                      fontSize: 16.5,
                      height: 1.12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    exercise.duration,
                    style: TextStyle(
                      color: TColor.sceondarText,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
