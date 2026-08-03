import 'package:shared_preferences/shared_preferences.dart';

class UserProfileData {
  final double startWeight;
  final double currentWeight;
  final double targetWeight;
  final double heightCm;
  final int age;
  final String gender;
  final String goalType;
  final bool profileCompleted;

  const UserProfileData({
    required this.startWeight,
    required this.currentWeight,
    required this.targetWeight,
    required this.heightCm,
    required this.age,
    required this.gender,
    required this.goalType,
    required this.profileCompleted,
  });

  double get heightMeter {
    return heightCm / 100;
  }

  double get bmi {
    if (currentWeight <= 0 || heightMeter <= 0) {
      return 0;
    }

    return currentWeight /
        (heightMeter * heightMeter);
  }

  double get weightLost {
    if (goalType != "lose_weight") {
      return 0;
    }

    final double value =
        startWeight - currentWeight;

    return value > 0 ? value : 0;
  }

  double get weightGained {
    if (goalType != "gain_weight") {
      return 0;
    }

    final double value =
        currentWeight - startWeight;

    return value > 0 ? value : 0;
  }

  double get remainingWeight {
    if (goalType == "lose_weight") {
      final double value =
          currentWeight - targetWeight;

      return value > 0 ? value : 0;
    }

    if (goalType == "gain_weight") {
      final double value =
          targetWeight - currentWeight;

      return value > 0 ? value : 0;
    }

    return 0;
  }

  double get goalProgress {
    if (startWeight <= 0 ||
        currentWeight <= 0 ||
        targetWeight <= 0) {
      return 0;
    }

    double progress = 0;

    if (goalType == "lose_weight") {
      final double totalToLose =
          startWeight - targetWeight;

      final double alreadyLost =
          startWeight - currentWeight;

      if (totalToLose <= 0) {
        return 0;
      }

      progress = alreadyLost / totalToLose;
    } else if (goalType == "gain_weight") {
      final double totalToGain =
          targetWeight - startWeight;

      final double alreadyGained =
          currentWeight - startWeight;

      if (totalToGain <= 0) {
        return 0;
      }

      progress = alreadyGained / totalToGain;
    } else {
      final double difference =
      (currentWeight - targetWeight).abs();

      progress = difference <= 1 ? 1 : 0;
    }

    return progress.clamp(0.0, 1.0);
  }

  String get bmiStatus {
    final double value = bmi;

    if (value <= 0) {
      return "Not available";
    }

    if (value < 18.5) {
      return "Underweight";
    }

    if (value < 25) {
      return "Normal";
    }

    if (value < 30) {
      return "Overweight";
    }

    return "Obese";
  }
}

class UserProfileService {
  UserProfileService._();

  static const String _startWeightKey =
      "profile_start_weight";

  static const String _currentWeightKey =
      "profile_current_weight";

  static const String _targetWeightKey =
      "profile_target_weight";

  static const String _heightKey =
      "profile_height_cm";

  static const String _ageKey =
      "profile_age";

  static const String _genderKey =
      "profile_gender";

  static const String _goalTypeKey =
      "profile_goal_type";

  static const String _profileCompletedKey =
      "profile_completed";

  static Future<UserProfileData>
  getProfile() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return UserProfileData(
      startWeight:
      prefs.getDouble(_startWeightKey) ?? 0,
      currentWeight:
      prefs.getDouble(_currentWeightKey) ?? 0,
      targetWeight:
      prefs.getDouble(_targetWeightKey) ?? 0,
      heightCm:
      prefs.getDouble(_heightKey) ?? 0,
      age: prefs.getInt(_ageKey) ?? 0,
      gender:
      prefs.getString(_genderKey) ?? "",
      goalType:
      prefs.getString(_goalTypeKey) ??
          "lose_weight",
      profileCompleted:
      prefs.getBool(_profileCompletedKey) ??
          false,
    );
  }

  static Future<void> saveProfile({
    required double startWeight,
    required double currentWeight,
    required double targetWeight,
    required double heightCm,
    required int age,
    required String gender,
    required String goalType,
  }) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setDouble(
      _startWeightKey,
      startWeight,
    );

    await prefs.setDouble(
      _currentWeightKey,
      currentWeight,
    );

    await prefs.setDouble(
      _targetWeightKey,
      targetWeight,
    );

    await prefs.setDouble(
      _heightKey,
      heightCm,
    );

    await prefs.setInt(
      _ageKey,
      age,
    );

    await prefs.setString(
      _genderKey,
      gender,
    );

    await prefs.setString(
      _goalTypeKey,
      goalType,
    );

    await prefs.setBool(
      _profileCompletedKey,
      true,
    );
  }

  static Future<void> updateCurrentWeight(
      double weight,
      ) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    final double startWeight =
        prefs.getDouble(_startWeightKey) ?? 0;

    if (startWeight <= 0) {
      await prefs.setDouble(
        _startWeightKey,
        weight,
      );
    }

    await prefs.setDouble(
      _currentWeightKey,
      weight,
    );
  }

  static Future<void> updateTargetWeight(
      double weight,
      ) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setDouble(
      _targetWeightKey,
      weight,
    );
  }

  static Future<void> updateHeight(
      double heightCm,
      ) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setDouble(
      _heightKey,
      heightCm,
    );
  }

  static Future<void> updateAge(
      int age,
      ) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setInt(
      _ageKey,
      age,
    );
  }

  static Future<void> updateGender(
      String gender,
      ) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      _genderKey,
      gender,
    );
  }

  static Future<void> updateGoalType(
      String goalType,
      ) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      _goalTypeKey,
      goalType,
    );
  }

  static Future<bool>
  isProfileCompleted() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return prefs.getBool(
      _profileCompletedKey,
    ) ??
        false;
  }

  static Future<void> clearProfile() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(_startWeightKey);
    await prefs.remove(_currentWeightKey);
    await prefs.remove(_targetWeightKey);
    await prefs.remove(_heightKey);
    await prefs.remove(_ageKey);
    await prefs.remove(_genderKey);
    await prefs.remove(_goalTypeKey);
    await prefs.remove(_profileCompletedKey);
  }
}