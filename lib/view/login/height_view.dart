import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../service/user_profile_service.dart';
import '../../common/smooth_page_route.dart';
import 'weight_view.dart';
import 'package:flutter/services.dart';


class HeightView extends StatefulWidget {
  const HeightView({super.key});

  @override
  State<HeightView> createState() => _HeightViewState();

}

class _HeightViewState extends State<HeightView> {


  static const Color _bgTop = Color(0xFF32105B);
  static const Color _bgBottom = Color(0xFF0C102D);
  static const Color _orange = Color(0xFFFF9818);
  static const Color _orange2 = Color(0xFFFFB319);
  static const Color _purple = Color(0xFF8C3DFF);

  static const double _minCm = 120;
  static const double _maxCm = 220;

  double _heightCm = 168;
  bool _showCm = false;
  bool _isSaving = false;
  int? _lastFeedbackStep;

  @override
  void initState() {
    super.initState();
    _loadSavedHeight();
  }

  Future<void> _loadSavedHeight() async {
    final profile = await UserProfileService.getProfile();
    if (!mounted || profile.heightCm <= 0) return;

    setState(() {
      _heightCm = profile.heightCm.clamp(_minCm, _maxCm).toDouble();
    });
  }

  int get _totalInches => (_heightCm / 2.54).round();
  int get _feet => _totalInches ~/ 12;
  int get _inches => _totalInches % 12;

  String get _heightText {
    if (_showCm) return '${_heightCm.round()}';
    return "$_feet'$_inches\"";
  }

  String get _unitText => _showCm ? 'cm' : 'ft/in';

  Future<void> _next() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    await UserProfileService.updateHeight(_heightCm);

    if (!mounted) return;
    setState(() => _isSaving = false);

    Navigator.of(context).push(
      smoothPageRoute(const WeightView()),
    );
  }

  void _changeHeightByDrag(double deltaY) {
    final next = (_heightCm - (deltaY * 0.20))
        .clamp(_minCm, _maxCm)
        .toDouble();

    if ((next - _heightCm).abs() < 0.05) return;

    final int newStep = next.round();

    if (_lastFeedbackStep != newStep) {
      _lastFeedbackStep = newStep;

      HapticFeedback.selectionClick();
      SystemSound.play(SystemSoundType.click);
    }

    setState(() {
      _heightCm = next;
    });
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
              final bool compact = constraints.maxHeight < 700;
              final double horizontal =
                  (constraints.maxWidth * 0.06).clamp(18.0, 28.0);
              final double stageHeight = (constraints.maxHeight * 0.49)
                  .clamp(330.0, 490.0);

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontal,
                        compact ? 8 : 14,
                        horizontal,
                        10,
                      ),
                      child: Column(
                        children: [
                          _buildTopBar(),
                          SizedBox(height: compact ? 14 : 26),
                          const Text(
                            "What's your height?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 29,
                              height: 1.08,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            'Drag the ruler to set your height',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.64),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: compact ? 12 : 18),
                          _buildUnitToggle(),
                          SizedBox(height: compact ? 8 : 15),
                          _buildHeightStage(stageHeight),
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
              final bool active = index <= 1;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: active ? _orange : Colors.white.withOpacity(0.24),
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
          _unitButton('ft/in', !_showCm),
          _unitButton('cm', _showCm),
        ],
      ),
    );
  }

  Widget _unitButton(String label, bool selected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _showCm = label == 'cm'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            gradient: selected
                ? const LinearGradient(colors: [_purple, Color(0xFF6424D8)])
                : null,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: _purple.withOpacity(0.24),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
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

  Widget _buildHeightStage(double stageHeight) {
    final double ratio =
        ((_heightCm - _minCm) / (_maxCm - _minCm)).clamp(0.0, 1.0);
    final double personScale = 0.88 + (ratio * 0.14);

    return SizedBox(
      height: stageHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.05, 0.45),
                    radius: 0.78,
                    colors: [
                      _purple.withOpacity(0.16),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 88,
            bottom: 4,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: RadialGradient(
                  colors: [
                    _purple.withOpacity(0.50),
                    _purple.withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 145,
            bottom: 14,
            top: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedScale(
                scale: personScale,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/img/boyP.png',
                  height: stageHeight * 0.88,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 4,
            bottom: 4,
            width: 110,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: (details) =>
                  _changeHeightByDrag(details.delta.dy),
              child: CustomPaint(
                painter: _HeightRulerPainter(
                  heightCm: _heightCm,
                  minCm: _minCm,
                  maxCm: _maxCm,
                  accent: _orange,
                  showCm: _showCm,
                ),
              ),
            ),
          ),

          Positioned(
            right: 82,
            top: stageHeight * 0.49 - 20,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 120),
              child: Row(
                key: ValueKey('$_heightText$_showCm'),
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _heightText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      _unitText,
                      style: const TextStyle(
                        color: _orange,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            right: 94,
            top: stageHeight * 0.49 + 6.5,
            child: Container(
              width: 62,
              height: 2,
              decoration: BoxDecoration(
                color: _orange,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _orange.withOpacity(0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
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
          colors: [Color(0xFFFF7413), _orange2],
        ),
        boxShadow: [
          BoxShadow(
            color: _orange.withOpacity(0.22),
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

class _HeightRulerPainter extends CustomPainter {
  final double heightCm;
  final double minCm;
  final double maxCm;
  final Color accent;
  final bool showCm;

  const _HeightRulerPainter({
    required this.heightCm,
    required this.minCm,
    required this.maxCm,
    required this.accent,
    required this.showCm,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double centerYFactor = 0.50;
    final double centerY = size.height * centerYFactor;
    const double pxPerCm = 9.0;

    final Paint tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.28)
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;

    final Paint majorPaint = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final Paint linePaint = Paint()
      ..color = Colors.white.withOpacity(0.16)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(size.width - 20, 0),
      Offset(size.width - 20, size.height),
      linePaint,
    );

    final int current = heightCm.round();
    final int visibleRadius = (size.height / pxPerCm / 2).ceil() + 2;

    for (int cm = current - visibleRadius;
        cm <= current + visibleRadius;
        cm++) {
      if (cm < minCm || cm > maxCm) continue;

      final double y = centerY + ((heightCm - cm) * pxPerCm);
      if (y < -12 || y > size.height + 12) continue;

      final bool major = cm % 5 == 0;
      final bool superMajor = cm % 10 == 0;
      final double length = superMajor ? 35 : (major ? 27 : 15);
      final Paint paint = major ? majorPaint : tickPaint;

      canvas.drawLine(
        Offset(size.width - 20 - length, y),
        Offset(size.width - 20, y),
        paint,
      );

      if (superMajor) {
        final String text;
        if (showCm) {
          text = '$cm';
        } else {
          final int totalInches = (cm / 2.54).round();
          text = '${totalInches ~/ 12}\'${totalInches % 12}';
        }

        final painter = TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.56),
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        painter.paint(
          canvas,
          Offset(
            math.max(0, size.width - 24 - length - painter.width - 5),
            y - painter.height / 2,
          ),
        );
      }
    }


  }

  @override
  bool shouldRepaint(covariant _HeightRulerPainter oldDelegate) {
    return oldDelegate.heightCm != heightCm || oldDelegate.showCm != showCm;
  }
}
