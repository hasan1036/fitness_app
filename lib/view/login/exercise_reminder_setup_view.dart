import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service/notification_service.dart';
import '../../common/smooth_page_route.dart';
import 'fitness_level_view.dart';

class ExerciseReminderSetupView extends StatefulWidget {
  const ExerciseReminderSetupView({super.key});

  @override
  State<ExerciseReminderSetupView> createState() =>
      _ExerciseReminderSetupViewState();
}

class _ExerciseReminderSetupViewState
    extends State<ExerciseReminderSetupView> {
  static const Color _bgTop = Color(0xFF32105B);
  static const Color _bgBottom = Color(0xFF0C102D);
  static const Color _purple = Color(0xFF8C3DFF);
  static const Color _purple2 = Color(0xFF6424D8);
  static const Color _orange = Color(0xFFFF9818);

  final List<_ReminderPreset> _presets = const [
    _ReminderPreset(
      label: 'Morning',
      time: '06:00',
      hour: 6,
      minute: 0,
      icon: Icons.wb_twilight_rounded,
    ),
    _ReminderPreset(
      label: 'Afternoon',
      time: '12:00',
      hour: 12,
      minute: 0,
      icon: Icons.wb_sunny_rounded,
    ),
    _ReminderPreset(
      label: 'Evening',
      time: '20:00',
      hour: 20,
      minute: 0,
      icon: Icons.nightlight_round,
    ),
    _ReminderPreset(
      label: 'Night',
      time: '22:00',
      hour: 22,
      minute: 0,
      icon: Icons.dark_mode_rounded,
    ),
  ];

  int _selectedIndex = 2;
  bool _disabled = false;
  bool _isSaving = false;

  Future<void> _next() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final prefs = await SharedPreferences.getInstance();

    try {
      if (_disabled) {
        await prefs.setBool('initial_workout_reminder_enabled', false);
        await prefs.setBool('workout_reminder_enabled', false);
        await NotificationService.cancelWorkoutReminders();
      } else {
        final preset = _presets[_selectedIndex];

        await prefs.setBool('initial_workout_reminder_enabled', true);
        await prefs.setInt('initial_workout_reminder_hour', preset.hour);
        await prefs.setInt('initial_workout_reminder_minute', preset.minute);
        await prefs.setBool('workout_reminder_enabled', true);
        await prefs.setInt('workout_reminder_hour', preset.hour);
        await prefs.setInt('workout_reminder_minute', preset.minute);

        await NotificationService.scheduleWorkoutReminders(
          hour: preset.hour,
          minute: preset.minute,
          selectedDayIndexes: const [0, 1, 2, 3, 4, 5, 6],
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _disabled
                  ? 'Reminder preference saved.'
                  : 'Reminder permission was not granted. You can enable it later from Settings.',
            ),
          ),
        );
      }
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    Navigator.of(context).push(
      smoothPageRoute(const FitnessLevelView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 720;
              final horizontal =
                  (constraints.maxWidth * 0.06).clamp(18.0, 28.0);

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontal,
                        compact ? 8 : 14,
                        horizontal,
                        14,
                      ),
                      child: Column(
                        children: [
                          _buildTopBar(),
                          SizedBox(height: compact ? 14 : 24),
                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                height: 1.12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                              ),
                              children: [
                                TextSpan(text: 'Remind you to\n'),
                                TextSpan(
                                  text: 'exercise',
                                  style: TextStyle(color: _purple),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: compact ? 16 : 24),
                          _buildInfoCard(),
                          SizedBox(height: compact ? 18 : 28),
                          _buildPresetGrid(compact),
                          SizedBox(height: compact ? 18 : 26),
                          _buildDisableOption(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontal,
                      6,
                      horizontal,
                      compact ? 10 : 16,
                    ),
                    child: _buildNextButton(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        SizedBox(
          width: 42,
          height: 42,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: index == 4
                        ? _orange
                        : _purple.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 50),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.055),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: _purple.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  _purple.withOpacity(0.45),
                  _purple2.withOpacity(0.2),
                ],
              ),
              border: Border.all(color: _purple.withOpacity(0.55)),
            ),
            child: const Icon(
              Icons.alarm_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14.5,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                ),
                children: const [
                  TextSpan(text: 'Smart reminder helped '),
                  TextSpan(
                    text: '68%',
                    style: TextStyle(
                      color: _orange,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(text: ' users achieve their goal faster'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetGrid(bool compact) {
    return Row(
      children: List.generate(_presets.length, (index) {
        final preset = _presets[index];
        final selected = !_disabled && index == _selectedIndex;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 5,
              right: index == _presets.length - 1 ? 0 : 5,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _disabled = false;
                  _selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                height: compact ? 132 : 150,
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: selected
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF8C3DFF), Color(0xFF5420C5)],
                        )
                      : null,
                  color: selected ? null : Colors.white.withOpacity(0.045),
                  border: Border.all(
                    color: selected
                        ? _purple.withOpacity(0.95)
                        : Colors.white.withOpacity(0.08),
                    width: selected ? 1.5 : 1,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: _purple.withOpacity(0.28),
                            blurRadius: 22,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      preset.icon,
                      color: selected
                          ? Colors.amberAccent
                          : Colors.white.withOpacity(0.65),
                      size: compact ? 25 : 30,
                    ),
                    const SizedBox(height: 9),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        preset.time,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 16 : 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        preset.label,
                        style: TextStyle(
                          color: Colors.white.withOpacity(selected ? 1 : 0.72),
                          fontSize: compact ? 10.5 : 11.5,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDisableOption() {
    return GestureDetector(
      onTap: () => setState(() => _disabled = !_disabled),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _disabled ? _purple : Colors.transparent,
              border: Border.all(
                color: _disabled
                    ? _purple
                    : Colors.white.withOpacity(0.45),
                width: 1.5,
              ),
            ),
            child: _disabled
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 15)
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            "No, I don't need it",
            style: TextStyle(
              color: Colors.white.withOpacity(_disabled ? 1 : 0.68),
              fontSize: 14.5,
              fontWeight: _disabled ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        gradient: const LinearGradient(
          colors: [Color(0xFF6D2CE8), Color(0xFFA631F4)],
        ),
        boxShadow: [
          BoxShadow(
            color: _purple.withOpacity(0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isSaving ? null : _next,
          borderRadius: BorderRadius.circular(19),
          child: Center(
            child: _isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'NEXT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _ReminderPreset {
  final String label;
  final String time;
  final int hour;
  final int minute;
  final IconData icon;

  const _ReminderPreset({
    required this.label,
    required this.time,
    required this.hour,
    required this.minute,
    required this.icon,
  });
}
