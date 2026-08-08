import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../common/color_extention.dart';
import '../../l10n/app_localizations.dart';

class ExerciseDetailView extends StatefulWidget {
  final List<Map<String, dynamic>> exercises;
  final int initialIndex;

  const ExerciseDetailView({
    super.key,
    required this.exercises,
    required this.initialIndex,
  });

  @override
  State<ExerciseDetailView> createState() =>
      _ExerciseDetailViewState();
}

class _ExerciseDetailViewState extends State<ExerciseDetailView> {
  final FlutterTts _flutterTts = FlutterTts();

  YoutubePlayerController? _youtubeController;

  late int currentIndex;
  late String currentValue;
  bool isSaved = false;

  /// 0 = 2D
  /// 1 = Muscle
  /// 2 = How To
  int selectedTab = 0;

  bool isSpeaking = false;

  Map<String, dynamic> get currentExercise =>
      widget.exercises[currentIndex];

  String _exerciseText(String field) {
    final String key =
        currentExercise['${field}Key']?.toString().trim() ?? '';

    if (key.isNotEmpty) {
      return context.tr(key);
    }

    return currentExercise[field]?.toString() ?? '';
  }

  List<String> _localizedList(String field) {
    final List<dynamic> raw =
    List<dynamic>.from(currentExercise[field] ?? const []);

    return raw.map((item) {
      final String value = item.toString();
      return context.tr(value);
    }).toList();
  }

  String _ttsLanguageCode() {
    switch (Localizations.localeOf(context).languageCode) {
      case 'bn':
        return 'bn-BD';
      case 'hi':
        return 'hi-IN';
      case 'ar':
        return 'ar-SA';
      case 'ja':
        return 'ja-JP';
      case 'es':
        return 'es-ES';
      default:
        return 'en-US';
    }
  }

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;

    currentValue =
        currentExercise["value"]?.toString() ?? "00:30";

    _setupVoice();
    _setupYoutubePlayer();
  }

  /// =====================================================
  /// VOICE SETUP
  /// =====================================================

  Future<void> _setupVoice() async {
    await _flutterTts.setLanguage(_ttsLanguageCode());
    await _flutterTts.setSpeechRate(0.43);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);

    _flutterTts.setStartHandler(() {
      if (!mounted) return;

      setState(() {
        isSpeaking = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      if (!mounted) return;

      setState(() {
        isSpeaking = false;
      });
    });

    _flutterTts.setCancelHandler(() {
      if (!mounted) return;

      setState(() {
        isSpeaking = false;
      });
    });

    _flutterTts.setErrorHandler((message) {
      if (!mounted) return;

      setState(() {
        isSpeaking = false;
      });
    });
  }

  Future<void> _toggleVoice() async {
    if (isSpeaking) {
      await _stopVoice();
      return;
    }

    final String name = _exerciseText('name');
    final String instruction = _exerciseText('instruction');
    final String benefit = _exerciseText('benefit');

    final String voiceText =
        "$name. $instruction $benefit";

    await _flutterTts.stop();
    await _flutterTts.speak(voiceText);
  }

  Future<void> _stopVoice() async {
    await _flutterTts.stop();

    if (!mounted) return;

    setState(() {
      isSpeaking = false;
    });
  }

  /// =====================================================
  /// YOUTUBE SETUP
  /// =====================================================

  void _setupYoutubePlayer() {
    _youtubeController?.close();
    _youtubeController = null;

    final String videoId =
        currentExercise["youtubeId"]?.toString().trim() ?? "";

    if (videoId.isEmpty ||
        videoId.contains("VIDEO_ID")) {
      return;
    }

    _youtubeController =
        YoutubePlayerController.fromVideoId(
          videoId: videoId,
          autoPlay: false,
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
            enableCaption: true,
            strictRelatedVideos: true,
            playsInline: true,
          ),
        );
  }

  /// =====================================================
  /// PREVIOUS EXERCISE
  /// =====================================================

  Future<void> _showPreviousExercise() async {
    if (currentIndex <= 0) return;

    await _stopVoice();

    _youtubeController?.close();

    setState(() {
      currentIndex--;
      selectedTab = 0;

      currentValue =
          currentExercise["value"]?.toString() ?? "00:30";
      isSaved = false;

      _setupYoutubePlayer();
    });
  }

  /// =====================================================
  /// NEXT EXERCISE
  /// =====================================================

  Future<void> _showNextExercise() async {
    if (currentIndex >= widget.exercises.length - 1) {
      return;
    }

    await _stopVoice();

    _youtubeController?.close();

    setState(() {
      currentIndex++;
      selectedTab = 0;

      currentValue =
          currentExercise["value"]?.toString() ?? "00:30";
      isSaved = false;

      _setupYoutubePlayer();
    });
  }

  /// =====================================================
  /// DURATION / REPS
  /// =====================================================

  void _decreaseValue() {
    setState(() {
      currentValue = _changeExerciseValue(
        currentValue,
        increase: false,
      );

      isSaved = false;
    });
  }

  void _increaseValue() {
    setState(() {
      currentValue = _changeExerciseValue(
        currentValue,
        increase: true,
      );

      isSaved = false;
    });
  }

  void _saveCurrentValue() {
    setState(() {
      widget.exercises[currentIndex]["value"] = currentValue;
      isSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('exerciseSettingSaved')),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  String _changeExerciseValue(
      String value, {
        required bool increase,
      }) {
    /// x10, x16, x20 ইত্যাদি reps হলে
    if (value.toLowerCase().startsWith("x")) {
      final int currentReps =
          int.tryParse(value.substring(1)) ?? 1;

      final int newReps = increase
          ? currentReps + 1
          : currentReps > 1
          ? currentReps - 1
          : 1;

      return "x$newReps";
    }

    /// 00:30, 01:00 ইত্যাদি duration হলে
    final List<String> parts = value.split(":");

    if (parts.length == 2) {
      final int minutes =
          int.tryParse(parts[0]) ?? 0;

      final int seconds =
          int.tryParse(parts[1]) ?? 30;

      final int totalSeconds =
          (minutes * 60) + seconds;

      int newSeconds = increase
          ? totalSeconds + 5
          : totalSeconds - 5;

      if (newSeconds < 5) {
        newSeconds = 5;
      }

      if (newSeconds > 300) {
        newSeconds = 300;
      }

      final int newMinutes = newSeconds ~/ 60;
      final int remainingSeconds =
          newSeconds % 60;

      return "${newMinutes.toString().padLeft(2, '0')}:"
          "${remainingSeconds.toString().padLeft(2, '0')}";
    }

    return value;
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _youtubeController?.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> focusAreas =
    _localizedList('focusAreas');

    final List<String> tips =
    _localizedList('tips');

    return Scaffold(
      backgroundColor:
      const Color(0xffF7F3FD),

      appBar: AppBar(
        backgroundColor:
        const Color(0xffF7F3FD),

        elevation: 0,

        leading: IconButton(
          onPressed: () async {
            await _stopVoice();

            _youtubeController?.pauseVideo();

            if (!context.mounted) return;

            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),

        title: Text(
          _exerciseText('name'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

          style: const TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        top: false,

        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  25,
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    /// 2D / MUSCLE / HOW TO

                    _buildTabs(),

                    const SizedBox(height: 18),

                    if (selectedTab == 0)
                      _build2DSection(
                        focusAreas: focusAreas,
                      )
                    else if (selectedTab == 1)
                      _buildMuscleSection(
                        focusAreas: focusAreas,
                        tips: tips,
                      )
                    else
                      _buildHowToSection(),
                  ],
                ),
              ),
            ),

            /// PREVIOUS / COUNT / NEXT / CLOSE

            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  /// =====================================================
  /// TAB DESIGN
  /// =====================================================

  Widget _buildTabs() {
    return Container(
      height: 54,

      padding: const EdgeInsets.all(5),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          Expanded(
            child: _tabButton(
              title: "2D",
              index: 0,
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: _tabButton(
              title: context.tr('muscle'),
              index: 1,
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: _tabButton(
              title: context.tr('howTo'),
              index: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton({
    required String title,
    required int index,
  }) {
    final bool active =
        selectedTab == index;

    return InkWell(
      borderRadius:
      BorderRadius.circular(14),

      onTap: () {
        /// অন্য tab-এ গেলে YouTube pause হবে
        if (index != 2) {
          _youtubeController?.pauseVideo();        }

        setState(() {
          selectedTab = index;
        });
      },

      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 200),

        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: active
              ? TColor.primary
              : Colors.transparent,

          borderRadius:
          BorderRadius.circular(14),
        ),

        child: Text(
          title,

          style: TextStyle(
            color: active
                ? Colors.white
                : Colors.black,

            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  /// =====================================================
  /// 2D TAB
  /// =====================================================

  Widget _build2DSection({
    required List<String> focusAreas,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        Container(
          width: double.infinity,
          height: 305,

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
            BorderRadius.circular(25),

            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),

          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  currentExercise["gif"]
                      ?.toString() ??
                      "",

                  width: double.infinity,
                  height: 270,

                  fit: BoxFit.contain,

                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Icon(
                      Icons.fitness_center,
                      color: TColor.primary,
                      size: 80,
                    );
                  },
                ),
              ),

              /// VOICE GUIDE BUTTON

              Positioned(
                top: 14,
                left: 14,
                child: GestureDetector(
                  onTap: _toggleVoice,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSpeaking
                          ? TColor.primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSpeaking
                              ? Icons.stop_circle
                              : Icons.volume_up_rounded,
                          color: TColor.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isSpeaking
                              ? context.tr('stopVoice')
                              : context.tr('voiceGuide'),
                          style: TextStyle(
                            color: TColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        _buildDurationControl(),

        const SizedBox(height: 25),

        _sectionTitle(context.tr('instruction')),

        const SizedBox(height: 10),

        Text(
          _exerciseText('instruction'),

          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Color(0xff2D2933),
          ),
        ),

        const SizedBox(height: 15),

        Text(
          _exerciseText('benefit'),

          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: TColor.sceondarText,
          ),
        ),

        const SizedBox(height: 25),

        _sectionTitle(context.tr('focusArea')),

        const SizedBox(height: 12),

        Wrap(
          spacing: 10,
          runSpacing: 10,

          children: focusAreas.map((area) {
            return Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),

              decoration: BoxDecoration(
                color: TColor.primaryLight,

                borderRadius:
                BorderRadius.circular(22),
              ),

              child: Text(
                area,

                style: TextStyle(
                  color: TColor.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// =====================================================
  /// DURATION / REPS CONTROL
  /// =====================================================

  Widget _buildDurationControl() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 15,
          ),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Row(
            children: [
              Icon(
                Icons.timer_outlined,
                color: TColor.primary,
                size: 26,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  context.tr('durationReps'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              _roundControlButton(
                icon: Icons.remove,
                onTap: _decreaseValue,
              ),

              Container(
                width: 78,
                alignment: Alignment.center,
                child: Text(
                  currentValue,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              _roundControlButton(
                icon: Icons.add,
                onTap: _increaseValue,
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          height: 50,

          child: ElevatedButton(
            onPressed: _saveCurrentValue,

            style: ElevatedButton.styleFrom(
              backgroundColor: isSaved
                  ? Colors.green
                  : TColor.primary,

              foregroundColor: Colors.white,
              elevation: 0,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            child: Text(
              isSaved
                  ? context.tr('savedWithCheck')
                  : context.tr('save'),

              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _roundControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
      BorderRadius.circular(30),

      child: Container(
        width: 38,
        height: 38,

        decoration: BoxDecoration(
          color: TColor.primaryLight,
          shape: BoxShape.circle,
        ),

        child: Icon(
          icon,
          color: TColor.primary,
          size: 22,
        ),
      ),
    );
  }

  /// =====================================================
  /// MUSCLE TAB
  /// =====================================================

  Widget _buildMuscleSection({
    required List<String> focusAreas,
    required List<String> tips,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        Container(
          width: double.infinity,

          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
            BorderRadius.circular(25),
          ),

          child: Column(
            children: [
              Text(
                context.tr('targetMuscles'),

                style: TextStyle(
                  color: TColor.primary,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 18),

              Image.asset(
                currentExercise["muscleImage"]
                    ?.toString() ??
                    "assets/img/me1.png",

                width: 190,
                height: 260,

                fit: BoxFit.contain,

                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return Image.asset(
                    "assets/img/me1.png",
                    width: 190,
                    height: 260,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        _sectionTitle(context.tr('focusArea')),

        const SizedBox(height: 12),

        Wrap(
          spacing: 10,
          runSpacing: 10,

          children: focusAreas.map((area) {
            return Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),

              decoration: BoxDecoration(
                color: TColor.primaryLight,

                borderRadius:
                BorderRadius.circular(22),
              ),

              child: Text(
                area,

                style: TextStyle(
                  color: TColor.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 28),

        _sectionTitle(context.tr('commonMistakesTips')),

        const SizedBox(height: 12),

        ...tips.map((tip) {
          return Container(
            margin:
            const EdgeInsets.only(bottom: 10),

            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
              BorderRadius.circular(16),
            ),

            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Icon(
                  Icons.check_circle,
                  color: TColor.primary,
                  size: 21,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    tip,

                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  /// =====================================================
  /// HOW TO TAB
  /// =====================================================

  Widget _buildHowToSection() {
    final String videoId =
        currentExercise["youtubeId"]
            ?.toString()
            .trim() ??
            "";

    final bool hasValidVideo =
        videoId.isNotEmpty &&
            !videoId.contains("VIDEO_ID") &&
            _youtubeController != null;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        Container(
          width: double.infinity,

          padding: const EdgeInsets.all(14),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
            BorderRadius.circular(25),

            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),

          child: hasValidVideo
              ? ClipRRect(
            borderRadius:
            BorderRadius.circular(18),

            child: YoutubePlayer(
              controller:
              _youtubeController!,

              aspectRatio: 16 / 9,
            ),
          )
              : SizedBox(
            height: 230,

            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [
                Icon(
                  Icons
                      .ondemand_video_rounded,

                  color: TColor.primary,
                  size: 65,
                ),

                const SizedBox(height: 15),

                Text(
                  context.tr('howToVideoUnavailable'),

                  textAlign:
                  TextAlign.center,

                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  context.tr('addCorrectYoutubeVideoId'),

                  textAlign:
                  TextAlign.center,

                  style: TextStyle(
                    color:
                    TColor.sceondarText,

                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 25),

        _sectionTitle(context.tr('howToDo')),

        const SizedBox(height: 12),

        Text(
          _exerciseText('instruction'),

          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Color(0xff2D2933),
          ),
        ),

        const SizedBox(height: 20),

        Container(
          width: double.infinity,

          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: TColor.primaryLight,

            borderRadius:
            BorderRadius.circular(18),
          ),

          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              Icon(
                Icons.info_outline,
                color: TColor.primary,
                size: 23,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  currentExercise["benefit"]
                      ?.toString() ??
                      "",

                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        InkWell(
          onTap: _toggleVoice,

          borderRadius:
          BorderRadius.circular(18),

          child: Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),

            decoration: BoxDecoration(
              color: isSpeaking
                  ? TColor.primary
                  : Colors.white,

              borderRadius:
              BorderRadius.circular(18),
            ),

            child: Row(
              children: [
                Icon(
                  isSpeaking
                      ? Icons.stop_circle_outlined
                      : Icons.volume_up_rounded,

                  color: isSpeaking
                      ? Colors.white
                      : TColor.primary,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    isSpeaking
                        ? context.tr('stopVoiceGuide')
                        : context.tr('listenVoiceGuide'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      color: isSpeaking
                          ? Colors.white
                          : TColor.primary,

                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// =====================================================
  /// BOTTOM NAVIGATION
  /// =====================================================

  Widget _buildBottomControls() {
    final bool canGoPrevious =
        currentIndex > 0;

    final bool canGoNext =
        currentIndex <
            widget.exercises.length - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        18,
        12,
        18,
        18,
      ),

      decoration: const BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 15,
            offset: Offset(0, -4),
          ),
        ],
      ),

      child: Row(
        children: [
          _navigationButton(
            icon: Icons.arrow_back_ios_new,
            enabled: canGoPrevious,
            onTap: _showPreviousExercise,
          ),

          Expanded(
            child: Center(
              child: Text(
                "${currentIndex + 1}/"
                    "${widget.exercises.length}",

                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          _navigationButton(
            icon: Icons.arrow_forward_ios,
            enabled: canGoNext,
            onTap: _showNextExercise,
          ),

          const SizedBox(width: 15),

          Expanded(
            flex: 2,

            child: SizedBox(
              height: 56,

              child: ElevatedButton(
                onPressed: () async {
                  await _stopVoice();

                  try {
                    _youtubeController?.pauseVideo();
                  } catch (_) {}

                  if (!mounted) return;

                  Navigator.of(context).pop();
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  TColor.primary,

                  foregroundColor:
                  Colors.white,

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                ),

                child: Text(
                  context.tr('close'),

                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navigationButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,

      borderRadius:
      BorderRadius.circular(18),

      child: Container(
        width: 54,
        height: 54,

        decoration: BoxDecoration(
          color: enabled
              ? TColor.primaryLight
              : Colors.grey.shade200,

          borderRadius:
          BorderRadius.circular(18),
        ),

        child: Icon(
          icon,

          color: enabled
              ? TColor.primary
              : Colors.grey,

          size: 19,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,

      style: TextStyle(
        color: TColor.primary,
        fontSize: 19,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}