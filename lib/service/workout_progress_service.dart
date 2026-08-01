import 'package:shared_preferences/shared_preferences.dart';

class WorkoutProgress {
  final bool started;
  final bool completed;
  final int currentExerciseIndex;
  final int totalExercises;

  const WorkoutProgress({
    required this.started,
    required this.completed,
    required this.currentExerciseIndex,
    required this.totalExercises,
  });

  double get progress {
    if (completed) return 1.0;
    if (totalExercises <= 0) return 0.0;

    return (currentExerciseIndex / totalExercises)
        .clamp(0.0, 1.0);
  }

  String get buttonText {
    if (completed) return "REPEAT";
    if (started) return "CONTINUE";
    return "START";
  }

  String get progressText {
    if (completed) return "Completed";

    if (!started) {
      return "Not started";
    }

    final int visibleExercise =
    (currentExerciseIndex + 1).clamp(1, totalExercises);

    return "Exercise $visibleExercise of $totalExercises";
  }
}

class WorkoutProgressService {
  WorkoutProgressService._();

  static final SharedPreferencesAsync _prefs =
  SharedPreferencesAsync();

  static String _startedKey(int day) =>
      "workout_day_${day}_started";

  static String _completedKey(int day) =>
      "workout_day_${day}_completed";

  static String _currentIndexKey(int day) =>
      "workout_day_${day}_current_index";

  static String _totalExercisesKey(int day) =>
      "workout_day_${day}_total_exercises";

  static Future<WorkoutProgress> getProgress(
      int dayNumber,
      ) async {
    final bool started =
        await _prefs.getBool(_startedKey(dayNumber)) ??
            false;

    final bool completed =
        await _prefs.getBool(_completedKey(dayNumber)) ??
            false;

    final int currentExerciseIndex =
        await _prefs.getInt(
          _currentIndexKey(dayNumber),
        ) ??
            0;

    final int totalExercises =
        await _prefs.getInt(
          _totalExercisesKey(dayNumber),
        ) ??
            0;

    return WorkoutProgress(
      started: started,
      completed: completed,
      currentExerciseIndex: currentExerciseIndex,
      totalExercises: totalExercises,
    );
  }

  static Future<void> startWorkout({
    required int dayNumber,
    required int totalExercises,
    required int startIndex,
  }) async {
    await _prefs.setBool(
      _startedKey(dayNumber),
      true,
    );

    await _prefs.setBool(
      _completedKey(dayNumber),
      false,
    );

    await _prefs.setInt(
      _currentIndexKey(dayNumber),
      startIndex,
    );

    await _prefs.setInt(
      _totalExercisesKey(dayNumber),
      totalExercises,
    );
  }

  static Future<void> saveCurrentExercise({
    required int dayNumber,
    required int currentExerciseIndex,
    required int totalExercises,
  }) async {
    await _prefs.setBool(
      _startedKey(dayNumber),
      true,
    );

    await _prefs.setBool(
      _completedKey(dayNumber),
      false,
    );

    await _prefs.setInt(
      _currentIndexKey(dayNumber),
      currentExerciseIndex,
    );

    await _prefs.setInt(
      _totalExercisesKey(dayNumber),
      totalExercises,
    );
  }

  static Future<void> completeWorkout({
    required int dayNumber,
    required int totalExercises,
  }) async {
    await _prefs.setBool(
      _startedKey(dayNumber),
      true,
    );

    await _prefs.setBool(
      _completedKey(dayNumber),
      true,
    );

    await _prefs.setInt(
      _currentIndexKey(dayNumber),
      totalExercises,
    );

    await _prefs.setInt(
      _totalExercisesKey(dayNumber),
      totalExercises,
    );
  }

  static Future<void> resetWorkout(
      int dayNumber,
      ) async {
    await _prefs.remove(
      _startedKey(dayNumber),
    );

    await _prefs.remove(
      _completedKey(dayNumber),
    );

    await _prefs.remove(
      _currentIndexKey(dayNumber),
    );

    await _prefs.remove(
      _totalExercisesKey(dayNumber),
    );
  }
}