import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../data/workout_plan_data.dart' show workoutPlanData;
import '../../service/workout_progress_service.dart';
import '../../service/workout_stats_service.dart';

import '../../common/color_extention.dart';
import '../../l10n/app_localizations.dart';

class ExercisePlayerView extends StatefulWidget {
  final List<Map<String, dynamic>> exercises;
  final int dayNumber;
  final int startIndex;

  const ExercisePlayerView({
    super.key,
    required this.exercises,
    required this.dayNumber,
    this.startIndex = 0,
  });

  @override
  State<ExercisePlayerView> createState() =>
      _ExercisePlayerViewState();
}

class _ExercisePlayerViewState extends State<ExercisePlayerView> {
  final FlutterTts _flutterTts = FlutterTts();

  Timer? _timer;

  late int currentIndex;

  /// Ready screen: 3, 2, 1
  int readySeconds = 3;

  /// Current timed exercise
  int exerciseSeconds = 30;
  int totalExerciseSeconds = 30;

  /// Rest between exercises
  int restSeconds = 15;

  bool isReadyScreen = true;
  bool isRestScreen = false;
  bool isWorkoutComplete = false;

  bool isRunning = false;
  bool isPaused = false;
  bool soundEnabled = true;

  Map<String, dynamic> get currentExercise =>
      widget.exercises[currentIndex];

  String get exerciseName {
    final String nameKey =
        currentExercise["nameKey"]?.toString().trim() ?? "";

    if (nameKey.isNotEmpty) {
      return context.tr(nameKey);
    }

    return currentExercise["name"]?.toString() ??
        context.tr("exercise");
  }

  String _localizedExerciseName(
      Map<String, dynamic> exercise,
      ) {
    final String nameKey =
        exercise["nameKey"]?.toString().trim() ?? "";

    if (nameKey.isNotEmpty) {
      return context.tr(nameKey);
    }

    return exercise["name"]?.toString() ?? "";
  }

  String _ttsLanguageCode(Locale locale) {
    switch (locale.languageCode) {
      case "bn":
        return "bn-BD";
      case "hi":
        return "hi-IN";
      case "ar":
        return "ar-SA";
      case "ja":
        return "ja-JP";
      case "es":
        return "es-ES";
      default:
        return "en-US";
    }
  }

  String get exerciseGif =>
      currentExercise["gif"]?.toString() ?? "";

  String get exerciseValue =>
      currentExercise["value"]?.toString() ?? "00:30";

  bool get isRepsExercise =>
      exerciseValue.toLowerCase().startsWith("x");

  @override
  void initState() {
    super.initState();

    currentIndex = widget.startIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await _setupVoice();
      _prepareCurrentExercise();
      await _saveWorkoutStarted();

      if (!mounted) return;
      _startReadyCountdown();
    });
  }
  Future<void> _saveWorkoutStarted() async {
    await WorkoutProgressService.startWorkout(
      dayNumber: widget.dayNumber,
      totalExercises: widget.exercises.length,
      startIndex: currentIndex,
    );
  }

  Future<void> _setupVoice() async {
    final Locale locale = Localizations.localeOf(context);

    await _flutterTts.setLanguage(
      _ttsLanguageCode(locale),
    );
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
  }

  Future<void> _speak(String text) async {
    if (!soundEnabled) return;

    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  void _prepareCurrentExercise() {
    final String value = exerciseValue;

    if (value.toLowerCase().startsWith("x")) {
      exerciseSeconds = 0;
      totalExerciseSeconds = 0;
      return;
    }

    final List<String> parts = value.split(":");

    if (parts.length == 2) {
      final int minutes = int.tryParse(parts[0]) ?? 0;
      final int seconds = int.tryParse(parts[1]) ?? 30;

      totalExerciseSeconds = (minutes * 60) + seconds;
      exerciseSeconds = totalExerciseSeconds;
    } else {
      totalExerciseSeconds = 30;
      exerciseSeconds = 30;
    }
  }

  /// =====================================================
  /// READY COUNTDOWN
  /// =====================================================

  void _startReadyCountdown() {
    _timer?.cancel();

    setState(() {
      isReadyScreen = true;
      isRestScreen = false;
      isWorkoutComplete = false;

      readySeconds = 3;

      isRunning = true;
      isPaused = false;
    });

    _speak("${context.tr('readyFor')} $exerciseName");

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) return;

        if (isPaused) return;

        if (readySeconds > 1) {
          setState(() {
            readySeconds--;
          });

          _speak(readySeconds.toString());
        } else {
          timer.cancel();

          setState(() {
            readySeconds = 0;
            isReadyScreen = false;
          });

          _speak(context.tr("start"));

          if (!isRepsExercise) {
            _startExerciseTimer();
          } else {
            setState(() {
              isRunning = false;
            });
          }
        }
      },
    );
  }

  /// =====================================================
  /// EXERCISE TIMER
  /// =====================================================

  void _startExerciseTimer() {
    _timer?.cancel();

    setState(() {
      isRunning = true;
      isPaused = false;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) return;

        if (isPaused) return;

        if (exerciseSeconds > 0) {
          setState(() {
            exerciseSeconds--;
          });

          if (exerciseSeconds == 3) {
            _speak("3");
          } else if (exerciseSeconds == 2) {
            _speak("2");
          } else if (exerciseSeconds == 1) {
            _speak("1");
          }
        } else {
          timer.cancel();

          setState(() {
            isRunning = false;
          });

          _speak(context.tr("exerciseComplete"));

          _startRestScreen();
        }
      },
    );
  }

  /// =====================================================
  /// REST SCREEN
  /// =====================================================

  void _startRestScreen() {
    _timer?.cancel();

    if (currentIndex >= widget.exercises.length - 1) {
      _finishWorkout();
      return;
    }

    setState(() {
      isReadyScreen = false;
      isRestScreen = true;
      isRunning = true;
      isPaused = false;
      restSeconds = 15;
    });

    _speak(context.tr("restFor15Seconds"));

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) return;

        if (isPaused) return;

        if (restSeconds > 0) {
          setState(() {
            restSeconds--;
          });

          if (restSeconds == 3) {
            _speak("3");
          } else if (restSeconds == 2) {
            _speak("2");
          } else if (restSeconds == 1) {
            _speak("1");
          }
        } else {
          timer.cancel();
          _goToNextExercise();
        }
      },
    );
  }

  /// =====================================================
  /// NAVIGATION
  /// =====================================================

  Future<void> _goToNextExercise() async {
    _timer?.cancel();

    if (currentIndex >= widget.exercises.length - 1) {
      await _finishWorkout();
      return;
    }

    setState(() {
      currentIndex++;
      isRestScreen = false;
      isReadyScreen = true;
      isPaused = false;
    });

    await WorkoutProgressService.saveCurrentExercise(
      dayNumber: widget.dayNumber,
      currentExerciseIndex: currentIndex,
      totalExercises: widget.exercises.length,
    );

    _prepareCurrentExercise();
    _startReadyCountdown();
  }

  Future<void> _goToPreviousExercise() async {
    if (currentIndex <= 0) return;

    _timer?.cancel();

    setState(() {
      currentIndex--;
      isRestScreen = false;
      isReadyScreen = true;
      isPaused = false;
    });

    await WorkoutProgressService.saveCurrentExercise(
      dayNumber: widget.dayNumber,
      currentExerciseIndex: currentIndex,
      totalExercises: widget.exercises.length,
    );

    _prepareCurrentExercise();
    _startReadyCountdown();
  }

  void _skipCurrentExercise() {
    _timer?.cancel();

    if (isRestScreen) {
      _goToNextExercise();
      return;
    }

    if (currentIndex >= widget.exercises.length - 1) {
      _finishWorkout();
      return;
    }

    _startRestScreen();
  }

  void _completeRepsExercise() {
    if (!isRepsExercise) return;

    _speak(context.tr("exerciseComplete"));
    _startRestScreen();
  }

  /// =====================================================
  /// PAUSE / RESUME
  /// =====================================================

  void _togglePause() {
    setState(() {
      isPaused = !isPaused;
    });

    if (isPaused) {
      _speak(context.tr("paused"));
    } else {
      _speak(context.tr("resume"));
    }
  }

  /// =====================================================
  /// SOUND
  /// =====================================================

  void _toggleSound() {
    setState(() {
      soundEnabled = !soundEnabled;
    });

    if (!soundEnabled) {
      _flutterTts.stop();
    } else {
      _speak(context.tr("voiceGuideEnabled"));
    }
  }

  /// =====================================================
  /// COMPLETE
  /// =====================================================

  Future<void> _finishWorkout() async {
    _timer?.cancel();

    final bool statsAlreadyCounted =
    await WorkoutProgressService.isStatsCounted(
      widget.dayNumber,
    );

    await WorkoutProgressService.completeWorkout(
      dayNumber: widget.dayNumber,
      totalExercises: widget.exercises.length,
    );

    if (!statsAlreadyCounted) {
      final double calorie = double.tryParse(
        workoutPlanData[widget.dayNumber - 1]["calorie"]
            .toString()
            .replaceAll("kcal", "")
            .trim(),
      ) ??
          0.0;

      await WorkoutStatsService.addWorkout(
        calorie: calorie,
      );

      await WorkoutProgressService.markStatsCounted(
        widget.dayNumber,
      );
    }

    if (!mounted) return;

    setState(() {
      isWorkoutComplete = true;
      isReadyScreen = false;
      isRestScreen = false;
      isRunning = false;
      isPaused = false;
    });

    await _speak(
      context.tr("congratulationsWorkoutComplete"),
    );
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:"
        "${remainingSeconds.toString().padLeft(2, '0')}";
  }

  double get workoutProgress {
    if (widget.exercises.isEmpty) return 0;

    return (currentIndex + 1) / widget.exercises.length;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _flutterTts.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isWorkoutComplete) {
      return _buildCompleteScreen();
    }

    if (isRestScreen) {
      return _buildRestScreen();
    }

    if (isReadyScreen) {
      return _buildReadyScreen();
    }

    return _buildExerciseScreen();
  }

  /// =====================================================
  /// COMMON TOP BAR
  /// =====================================================

  Widget _buildTopBar() {
    return Row(
      children: [
        _circleButton(
          icon: Icons.arrow_back,
          onTap: () async {
            _timer?.cancel();
            await _flutterTts.stop();

            await WorkoutProgressService.saveCurrentExercise(
              dayNumber: widget.dayNumber,
              currentExerciseIndex: currentIndex,
              totalExercises: widget.exercises.length,
            );

            if (!context.mounted) return;

            Navigator.pop(context, true);
          },
        ),

        const Spacer(),

        Text(
          "${context.tr('day')} ${widget.dayNumber}",
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),

        const Spacer(),

        _circleButton(
          icon: soundEnabled
              ? Icons.volume_up_rounded
              : Icons.volume_off_rounded,
          onTap: _toggleSound,
        ),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.90),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x15000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    );
  }

  /// =====================================================
  /// READY SCREEN
  /// =====================================================

  Widget _buildReadyScreen() {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3FD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildTopBar(),

              const SizedBox(height: 20),

              LinearProgressIndicator(
                value: workoutProgress,
                minHeight: 7,
                borderRadius: BorderRadius.circular(10),
                backgroundColor: TColor.primaryLight,
                color: TColor.primary,
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Image.asset(
                    exerciseGif,
                    fit: BoxFit.contain,
                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return Icon(
                        Icons.fitness_center,
                        color: TColor.primary,
                        size: 100,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                context.tr("readyToGo"),
                style: TextStyle(
                  color: TColor.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                exerciseName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: TColor.sceondarText,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                readySeconds > 0
                    ? readySeconds.toString()
                    : context.tr("go"),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 62,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: 220,
                height: 58,
                child: ElevatedButton(
                  onPressed: _skipCurrentExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    context.tr("skip"),
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  /// =====================================================
  /// EXERCISE SCREEN
  /// =====================================================

  Widget _buildExerciseScreen() {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3FD),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              _buildTopBar(),

              const SizedBox(height: 18),

              LinearProgressIndicator(
                value: workoutProgress,
                minHeight: 7,
                borderRadius: BorderRadius.circular(10),
                backgroundColor: TColor.primaryLight,
                color: TColor.primary,
              ),

              const SizedBox(height: 12),

              Text(
                "${currentIndex + 1}/${widget.exercises.length}",
                style: TextStyle(
                  color: TColor.sceondarText,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: Container(
                  width: double.infinity,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),

                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 18,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Image.asset(
                    exerciseGif,
                    fit: BoxFit.contain,

                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return Icon(
                        Icons.fitness_center,
                        color: TColor.primary,
                        size: 100,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Text(
                exerciseName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                isRepsExercise
                    ? exerciseValue
                    : _formatTime(exerciseSeconds),

                style: TextStyle(
                  color: TColor.primary,
                  fontSize: 55,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 20),

              if (isRepsExercise)
                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: _completeRepsExercise,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primary,
                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    child: Text(
                      context.tr("complete").toUpperCase(),

                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    _bottomActionButton(
                      icon: Icons.skip_previous_rounded,
                      onTap: currentIndex > 0
                          ? _goToPreviousExercise
                          : null,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: SizedBox(
                        height: 60,

                        child: ElevatedButton.icon(
                          onPressed: _togglePause,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.primary,
                            foregroundColor: Colors.white,

                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                          ),

                          icon: Icon(
                            isPaused
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                          ),

                          label: Flexible(
                            child: Text(
                              isPaused
                                  ? context.tr("resume")
                                  : context.tr("pause"),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    _bottomActionButton(
                      icon: Icons.skip_next_rounded,
                      onTap: _skipCurrentExercise,
                    ),
                  ],
                ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomActionButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,

      child: Container(
        width: 60,
        height: 60,

        decoration: BoxDecoration(
          color: onTap == null
              ? Colors.grey.shade200
              : TColor.primaryLight,

          borderRadius: BorderRadius.circular(18),
        ),

        child: Icon(
          icon,

          color: onTap == null
              ? Colors.grey
              : TColor.primary,

          size: 30,
        ),
      ),
    );
  }

  /// =====================================================
  /// REST SCREEN
  /// =====================================================

  Widget _buildRestScreen() {
    final Map<String, dynamic>? nextExercise =
    currentIndex < widget.exercises.length - 1
        ? widget.exercises[currentIndex + 1]
        : null;

    return Scaffold(
      backgroundColor: const Color(0xffF7F3FD),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              _buildTopBar(),

              const Spacer(),

              Icon(
                Icons.self_improvement_rounded,
                color: TColor.primary,
                size: 110,
              ),

              const SizedBox(height: 20),

              Text(
                context.tr("takeARest"),
                style: TextStyle(
                  color: TColor.primary,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                restSeconds.toString(),
                style: const TextStyle(
                  fontSize: 75,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 15),

              if (nextExercise != null) ...[
                Text(
                  context.tr("next").toUpperCase(),
                  style: TextStyle(
                    color: TColor.sceondarText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  _localizedExerciseName(nextExercise),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  onPressed: _goToNextExercise,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primary,
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  child: Text(
                    context.tr("skipRest"),

                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// =====================================================
  /// COMPLETE SCREEN
  /// =====================================================

  Widget _buildCompleteScreen() {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3FD),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                width: 150,
                height: 150,

                decoration: BoxDecoration(
                  color: TColor.primaryLight,
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  Icons.emoji_events_rounded,
                  color: TColor.primary,
                  size: 90,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                context.tr("congratulations"),

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                "${context.tr('day')} ${widget.dayNumber} ${context.tr('dayWorkoutCompleted')}",

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: TColor.sceondarText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 45),

              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      true,
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primary,
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  child: Text(
                    context.tr("done").toUpperCase(),

                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}