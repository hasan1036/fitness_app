import 'package:shared_preferences/shared_preferences.dart';

class WorkoutStatsService {
  static const String _workoutKey = "total_workout";
  static const String _calorieKey = "total_calorie";
  static const String _streakKey = "current_streak";
  static const String _lastWorkoutDateKey =
      "last_workout_date";

  static Future<int> getWorkout() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return prefs.getInt(_workoutKey) ?? 0;
  }

  static Future<double> getCalories() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return prefs.getDouble(_calorieKey) ?? 0.0;
  }

  static Future<int> getStreak() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    final int savedStreak =
        prefs.getInt(_streakKey) ?? 0;

    final String? lastDateText =
    prefs.getString(_lastWorkoutDateKey);

    if (lastDateText == null) {
      return savedStreak;
    }

    final DateTime? lastDate =
    DateTime.tryParse(lastDateText);

    if (lastDate == null) {
      return savedStreak;
    }

    final DateTime now = DateTime.now();

    final DateTime today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final DateTime savedDay = DateTime(
      lastDate.year,
      lastDate.month,
      lastDate.day,
    );

    final int difference =
        today.difference(savedDay).inDays;

    /// আজ বা গতকাল workout হয়েছে
    if (difference <= 1) {
      return savedStreak;
    }

    /// একদিনের বেশি gap হলে streak শেষ
    await prefs.setInt(
      _streakKey,
      0,
    );

    return 0;
  }

  static Future<void> addWorkout({
    required double calorie,
  }) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    final int oldWorkoutCount =
        prefs.getInt(_workoutKey) ?? 0;

    final double oldCalories =
        prefs.getDouble(_calorieKey) ?? 0.0;

    final int oldStreak =
        prefs.getInt(_streakKey) ?? 0;

    final String? lastDateText =
    prefs.getString(_lastWorkoutDateKey);

    final DateTime now = DateTime.now();

    final DateTime today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    int newStreak = 1;

    if (lastDateText != null) {
      final DateTime? lastDate =
      DateTime.tryParse(lastDateText);

      if (lastDate != null) {
        final DateTime savedDay = DateTime(
          lastDate.year,
          lastDate.month,
          lastDate.day,
        );

        final int difference =
            today.difference(savedDay).inDays;

        if (difference == 0) {
          /// একই দিনে আবার workout:
          /// streak বাড়বে না
          newStreak = oldStreak == 0
              ? 1
              : oldStreak;
        } else if (difference == 1) {
          /// পরের দিন workout:
          /// streak এক বাড়বে
          newStreak = oldStreak + 1;
        } else {
          /// এক বা একাধিক দিন miss:
          /// নতুন streak শুরু
          newStreak = 1;
        }
      }
    }

    await prefs.setInt(
      _workoutKey,
      oldWorkoutCount + 1,
    );

    await prefs.setDouble(
      _calorieKey,
      oldCalories + calorie,
    );

    await prefs.setInt(
      _streakKey,
      newStreak,
    );

    await prefs.setString(
      _lastWorkoutDateKey,
      _formatDate(today),
    );
  }

  static String _formatDate(DateTime date) {
    return "${date.year}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  static Future<void> resetStats() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(_workoutKey);
    await prefs.remove(_calorieKey);
    await prefs.remove(_streakKey);
    await prefs.remove(_lastWorkoutDateKey);
  }
}