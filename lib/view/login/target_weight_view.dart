import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../service/user_profile_service.dart';
import '../../common/smooth_page_route.dart';
import 'exercise_reminder_setup_view.dart';
import 'package:flutter/services.dart';

class TargetWeightView extends StatefulWidget {
  const TargetWeightView({super.key});

  @override
  State<TargetWeightView> createState() => _TargetWeightViewState();
}

class _TargetWeightViewState extends State<TargetWeightView> {
  static const Color _bgTop = Color(0xFF32105B);
  static const Color _bgBottom = Color(0xFF0C102D);
  static const Color _purple = Color(0xFF8C3DFF);
  static const Color _purple2 = Color(0xFF6424D8);
  static const Color _orange = Color(0xFFFF9818);

  static const double _minKg = 15.0;
  static const double _maxKg = 200.0;

  double _currentWeightKg = 60.1;
  double _targetWeightKg = 55.0;
  int? _lastFeedbackStep;
  bool _showKg = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await UserProfileService.getProfile();
    if (!mounted) return;

    setState(() {
      if (profile.currentWeight > 0) {
        _currentWeightKg = profile.currentWeight.clamp(_minKg, _maxKg).toDouble();
      }

      if (profile.targetWeight > 0) {
        _targetWeightKg = profile.targetWeight.clamp(_minKg, _maxKg).toDouble();
      } else {
        final suggested = _currentWeightKg - 5;
        _targetWeightKg = suggested.clamp(_minKg, _maxKg).toDouble();
      }
    });
  }

  double get _displayTarget =>
      _showKg ? _targetWeightKg : _targetWeightKg * 2.2046226218;

  String get _unit => _showKg ? 'kg' : 'lb';

  double get _differenceKg => (_targetWeightKg - _currentWeightKg).abs();

  String get _goalTitle {
    if ((_targetWeightKg - _currentWeightKg).abs() < 0.05) {
      return 'Maintain your weight';
    }
    return _targetWeightKg < _currentWeightKg
        ? 'Weight to lose'
        : 'Weight to gain';
  }

  String get _goalDifference {
    final value = _showKg ? _differenceKg : _differenceKg * 2.2046226218;
    return '${value.toStringAsFixed(1)} $_unit';
  }

  String get _goalMessage {
    final delta = _targetWeightKg - _currentWeightKg;
    if (delta.abs() < 0.05) {
      return 'Your target matches your current weight.';
    }
    if (delta < 0) {
      return 'Your plan will focus on gradual, consistent weight loss.';
    }
    return 'Your plan will focus on gradual, consistent weight gain.';
  }

  void _setTargetFromDx(double dx, double width) {
    if (width <= 0) return;

    final ratio = (dx / width).clamp(0.0, 1.0);
    final kg = _minKg + ((_maxKg - _minKg) * ratio);
    final newWeight = (kg * 10).round() / 10;

    final int newStep = (newWeight * 10).round();

    if (_lastFeedbackStep != newStep) {
      _lastFeedbackStep = newStep;

      HapticFeedback.selectionClick();
      SystemSound.play(SystemSoundType.click);
    }

    setState(() {
      _targetWeightKg = newWeight;
    });
  }
  void _nudge(double kgDelta) {
    final next = (_targetWeightKg + kgDelta)
        .clamp(_minKg, _maxKg)
        .toDouble();

    final newWeight = (next * 10).round() / 10;

    HapticFeedback.selectionClick();
    SystemSound.play(SystemSoundType.click);

    setState(() {
      _targetWeightKg = newWeight;
    });
  }

  Future<void> _next() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    await UserProfileService.updateTargetWeight(_targetWeightKg);

    final String goalType;
    if ((_targetWeightKg - _currentWeightKg).abs() < 0.05) {
      goalType = 'maintain_weight';
    } else if (_targetWeightKg < _currentWeightKg) {
      goalType = 'lose_weight';
    } else {
      goalType = 'gain_weight';
    }
    await UserProfileService.updateGoalType(goalType);

    if (!mounted) return;
    setState(() => _isSaving = false);

    Navigator.of(context).push(
      smoothPageRoute(const ExerciseReminderSetupView()),
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
              final gaugeHeight =
                  (constraints.maxHeight * 0.31).clamp(230.0, 330.0);

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontal,
                        compact ? 8 : 14,
                        horizontal,
                        12,
                      ),
                      child: Column(
                        children: [
                          _buildTopBar(),
                          SizedBox(height: compact ? 14 : 25),
                          const Text(
                            "What's your\ntarget weight?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 29,
                              height: 1.08,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: compact ? 14 : 20),
                          _buildUnitToggle(),
                          SizedBox(height: compact ? 10 : 18),
                          _buildGauge(gaugeHeight),
                          SizedBox(height: compact ? 10 : 18),
                          _buildGoalCard(),
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
            children: List.generate(4, (index) {
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _orange,
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

  Widget _buildUnitToggle() {
    return Container(
      width: 154,
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          _unitButton('kg', _showKg, () => setState(() => _showKg = true)),
          _unitButton('lb', !_showKg, () => setState(() => _showKg = false)),
        ],
      ),
    );
  }

  Widget _unitButton(String text, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            gradient: selected
                ? const LinearGradient(colors: [_purple, _purple2])
                : null,
            boxShadow: selected
                ? [BoxShadow(color: _purple.withOpacity(0.28), blurRadius: 12)]
                : null,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGauge(double height) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: LayoutBuilder(
        builder: (context, c) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (d) =>
                _setTargetFromDx(d.localPosition.dx, c.maxWidth),
            onTapDown: (d) =>
                _setTargetFromDx(d.localPosition.dx, c.maxWidth),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _TargetWeightGaugePainter(
                      value: _targetWeightKg,
                      min: _minKg,
                      max: _maxKg,
                      accent: _purple,
                      indicator: _orange,
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.18,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _purple.withOpacity(0.18),
                      border: Border.all(color: _purple.withOpacity(0.55)),
                      boxShadow: [
                        BoxShadow(
                          color: _purple.withOpacity(0.22),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.flag_rounded,
                      color: Colors.white,
                      size: 23,
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.38,
                  child: Column(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 160),
                        child: Text(
                          _displayTarget.toStringAsFixed(1),
                          key: ValueKey(
                            '${_displayTarget.toStringAsFixed(1)}$_showKg',
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 56,
                            height: 0.95,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _unit,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 14,
                  right: 14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _roundNudge(Icons.remove_rounded, () => _nudge(-0.1)),
                      Column(
                        children: [
                          const Icon(
                            Icons.arrow_drop_up_rounded,
                            color: _orange,
                            size: 24,
                          ),
                          Text(
                            _goalTitle,
                            style: const TextStyle(
                              color: _purple,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      _roundNudge(Icons.add_rounded, () => _nudge(0.1)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _roundNudge(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.055),
          border: Border.all(color: Colors.white.withOpacity(0.10)),
        ),
        child: Icon(icon, color: Colors.white70, size: 22),
      ),
    );
  }

  Widget _buildGoalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.055),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _purple.withOpacity(0.28)),
        boxShadow: [
          BoxShadow(color: _purple.withOpacity(0.08), blurRadius: 24),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  _purple.withOpacity(0.34),
                  _purple2.withOpacity(0.16),
                ],
              ),
              border: Border.all(color: _purple.withOpacity(0.35)),
            ),
            child: const Icon(
              Icons.track_changes_rounded,
              color: _purple,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _goalTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _goalDifference,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  _goalMessage,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.76),
                    fontSize: 12,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(
                _showKg
                    ? '${_currentWeightKg.toStringAsFixed(1)} kg'
                    : '${(_currentWeightKg * 2.2046226218).toStringAsFixed(1)} lb',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(
                Icons.arrow_downward_rounded,
                color: _orange,
                size: 18,
              ),
              Text(
                '${_displayTarget.toStringAsFixed(1)} $_unit',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
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
          colors: [Color(0xFF6C27DD), Color(0xFF9A31F2)],
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
                      strokeWidth: 2.3,
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
                      SizedBox(width: 11),
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

class _TargetWeightGaugePainter extends CustomPainter {
  final double value;
  final double min;
  final double max;
  final Color accent;
  final Color indicator;

  const _TargetWeightGaugePainter({
    required this.value,
    required this.min,
    required this.max,
    required this.accent,
    required this.indicator,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.70);
    final radius = math.min(size.width * 0.42, size.height * 0.62);
    const start = math.pi;
    const sweep = math.pi;

    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withOpacity(0.10);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      base,
    );

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = accent.withOpacity(0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      glow,
    );

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [accent.withOpacity(0.55), accent],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      arc,
    );

    for (int i = 0; i <= 40; i++) {
      final t = i / 40;
      final a = start + sweep * t;
      final major = i % 5 == 0;
      final inner = radius - (major ? 17 : 10);
      final p1 = Offset(
        center.dx + math.cos(a) * inner,
        center.dy + math.sin(a) * inner,
      );
      final p2 = Offset(
        center.dx + math.cos(a) * radius,
        center.dy + math.sin(a) * radius,
      );
      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..color = Colors.white.withOpacity(major ? 0.35 : 0.18)
          ..strokeWidth = major ? 1.4 : 1,
      );
    }

    final ratio = ((value - min) / (max - min)).clamp(0.0, 1.0);
    final a = start + sweep * ratio;
    final dot = Offset(
      center.dx + math.cos(a) * radius,
      center.dy + math.sin(a) * radius,
    );
    canvas.drawCircle(
      dot,
      11,
      Paint()
        ..color = accent.withOpacity(0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    canvas.drawCircle(dot, 6, Paint()..color = Colors.white);
    canvas.drawCircle(dot, 4, Paint()..color = indicator);

    final labels = [min.round().toString(), max.round().toString()];
    final positions = [
      Offset(center.dx - radius - 4, center.dy + 14),
      Offset(center.dx + radius - 24, center.dy + 14),
    ];

    for (int i = 0; i < 2; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: Colors.white.withOpacity(0.60),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, positions[i]);
    }
  }

  @override
  bool shouldRepaint(covariant _TargetWeightGaugePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
