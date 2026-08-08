import 'package:flutter/material.dart';

import '../menu/menu_view.dart';

class PlanLoadingView extends StatefulWidget {
  const PlanLoadingView({super.key});

  @override
  State<PlanLoadingView> createState() => _PlanLoadingViewState();
}

class _PlanLoadingViewState extends State<PlanLoadingView>
    with SingleTickerProviderStateMixin {
  static const Color _bgTop = Color(0xFF26104B);
  static const Color _bgBottom = Color(0xFF080D23);
  static const Color _purple = Color(0xFF8B3DFF);
  static const Color _purple2 = Color(0xFF6324D8);
  static const Color _orange = Color(0xFFFFA31A);

  late final AnimationController _controller;
  late final Animation<double> _progress;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _openMenu();
      }
    });
    _controller.forward();
  }

  void _openMenu() {
    if (_navigated || !mounted) return;
    _navigated = true;

    // 100% reached: navigate on the very next frame.
    // We intentionally avoid pushAndRemoveUntil here because removing the
    // whole onboarding stack during inherited-widget teardown can trigger
    // Flutter's _dependents.isEmpty assertion on some devices.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/menu'),
          builder: (_) => const PopScope(
            canPop: false,
            child: MenuView(),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _percent => (_progress.value * 100).clamp(0, 100).round();

  String get _headline {
    if (_percent < 32) return 'Analyzing your\nfitness profile...';
    if (_percent < 68) return 'Building your\npersonalized plan...';
    if (_percent < 96) return 'Almost there!\nFinalizing your schedule...';
    return 'Your plan\nis ready!';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                    (constraints.maxWidth * 0.07).clamp(20.0, 30.0);
                final double rocketSize =
                    (constraints.maxWidth * 0.38).clamp(132.0, 180.0);

                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontal,
                    compact ? 22 : 34,
                    horizontal,
                    compact ? 18 : 28,
                  ),
                  child: Column(
                    children: [
                      const Spacer(flex: 1),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 260),
                        child: Text(
                          _headline,
                          key: ValueKey(_headline),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: compact ? 27 : 31,
                            height: 1.08,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.6,
                          ),
                        ),
                      ),
                      SizedBox(height: compact ? 24 : 36),
                      _buildRocket(rocketSize),
                      SizedBox(height: compact ? 16 : 22),
                      ShaderMask(
                        shaderCallback: (rect) => const LinearGradient(
                          colors: [_purple, Color(0xFFB25CFF), _orange],
                        ).createShader(rect),
                        child: Text(
                          '$_percent%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: compact ? 38 : 44,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(height: compact ? 16 : 22),
                      _buildProgressBar(),
                      const Spacer(flex: 1),
                      _buildStatusRow(
                        'Analyzing activity & fitness level',
                        _percent >= 30,
                        _percent < 30,
                      ),
                      const SizedBox(height: 14),
                      _buildStatusRow(
                        'Preparing your weight goal',
                        _percent >= 62,
                        _percent >= 30 && _percent < 62,
                      ),
                      const SizedBox(height: 14),
                      _buildStatusRow(
                        'Setting up your smart reminder',
                        _percent >= 94,
                        _percent >= 62 && _percent < 94,
                      ),
                      SizedBox(height: compact ? 25 : 36),
                      Text(
                        'Please wait while we personalize the best plan for you.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.58),
                          fontSize: 12.5,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRocket(double size) {
    final double lift = 10 * _progress.value;
    return Transform.translate(
      offset: Offset(0, -lift),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size * 0.92,
              height: size * 0.92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _purple.withOpacity(0.28),
                    _purple.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Transform.rotate(
              angle: -0.03,
              child: Icon(
                Icons.rocket_launch_rounded,
                size: size * 0.62,
                color: const Color(0xFFB26BFF),
                shadows: [
                  Shadow(
                    color: _purple.withOpacity(0.9),
                    blurRadius: 28,
                  ),
                  Shadow(
                    color: _orange.withOpacity(0.30),
                    blurRadius: 42,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: size * 0.05,
              child: Container(
                width: size * 0.42,
                height: size * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      _purple.withOpacity(0.65),
                      _orange.withOpacity(0.55),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _purple.withOpacity(0.40),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 10,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 80),
              width: constraints.maxWidth * _progress.value,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                gradient: const LinearGradient(
                  colors: [_purple2, _purple, Color(0xFFB25CFF)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _purple.withOpacity(0.55),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusRow(String text, bool completed, bool active) {
    return AnimatedOpacity(
      opacity: completed || active ? 1 : 0.38,
      duration: const Duration(milliseconds: 220),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 29,
            height: 29,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: completed
                  ? _purple
                  : active
                      ? _purple.withOpacity(0.15)
                      : Colors.white.withOpacity(0.05),
              border: Border.all(
                color: completed || active
                    ? _purple
                    : Colors.white.withOpacity(0.12),
              ),
              boxShadow: completed || active
                  ? [
                      BoxShadow(
                        color: _purple.withOpacity(0.25),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
            ),
            child: completed
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                : active
                    ? const Padding(
                        padding: EdgeInsets.all(7),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFB26BFF),
                        ),
                      )
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(completed || active ? 0.90 : 0.55),
                fontSize: 13.5,
                fontWeight: completed ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
