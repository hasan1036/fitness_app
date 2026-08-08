import 'package:flutter/material.dart';

import '../../service/user_profile_service.dart';
import '../../common/smooth_page_route.dart';
import 'height_view.dart';

class ActivityLevelView extends StatefulWidget {
  const ActivityLevelView({super.key});

  @override
  State<ActivityLevelView> createState() => _ActivityLevelViewState();
}

class _ActivityLevelViewState extends State<ActivityLevelView> {
  int _selectedIndex = 1;
  bool _isSaving = false;

  static const Color _bgTop = Color(0xFF32105B);
  static const Color _bgBottom = Color(0xFF0C102D);
  static const Color _orange = Color(0xFFFF9818);
  static const Color _orange2 = Color(0xFFFFB319);

  final List<_ActivityLevel> _levels = const [
    _ActivityLevel(
      keyName: 'low',
      label: 'Low\nActivity',
      title: 'I move a little',
      description: 'Mostly sitting with short walks daily',
      icon: Icons.emoji_nature_rounded,
    ),
    _ActivityLevel(
      keyName: 'normal',
      label: 'Normal\nActivity',
      title: 'I usually walk',
      description: '30–45 minutes daily',
      icon: Icons.directions_walk_rounded,
    ),
    _ActivityLevel(
      keyName: 'high',
      label: 'High\nActivity',
      title: 'I stay very active',
      description: 'Workout or move actively most days',
      icon: Icons.directions_run_rounded,
    ),
  ];

  Future<void> _continue() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    await UserProfileService.saveActivityLevel(
      _levels[_selectedIndex].keyName,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    await precacheImage(
      const AssetImage('assets/img/boyP.png'),
      context,
    );

    if (!mounted) return;
    Navigator.of(context).push(
      smoothPageRoute(const HeightView()),
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
              final bool compactHeight = constraints.maxHeight < 680;
              final double horizontal = (constraints.maxWidth * 0.065)
                  .clamp(18.0, 30.0);
              final double heroSize = (constraints.maxWidth * 0.80)
                  .clamp(320.0, 420.0);
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontal,
                        compactHeight ? 8 : 14,
                        horizontal,
                        14,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight -
                              (compactHeight ? 98 : 112),
                        ),
                        child: Column(
                          children: [
                            _buildTopBar(),
                            SizedBox(height: compactHeight ? 18 : 30),
                            const Text(
                              "What's your\nactivity level?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 29,
                                height: 1.08,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: compactHeight ? 18 : 30),
                            _buildHero(heroSize),
                            SizedBox(height: compactHeight ? 16 : 24),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              child: Column(
                                key: ValueKey(_selectedIndex),
                                children: [
                                  Text(
                                    _levels[_selectedIndex].title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: _orange,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _levels[_selectedIndex].description,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.96),
                                      fontSize: 16,
                                      height: 1.25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: compactHeight ? 20 : 31),
                            _buildLevelSelector(),
                            SizedBox(height: compactHeight ? 10 : 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontal,
                      6,
                      horizontal,
                      compactHeight ? 10 : 16,
                    ),
                    child: _buildContinueButton(),
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
              final bool active = index == 0;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: active
                        ? _orange
                        : Colors.white.withOpacity(0.24),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 42),
      ],
    );
  }

  Widget _buildHero(double size) {
    final _ActivityLevel selected = _levels[_selectedIndex];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: animation, child: child),
      ),
      child: SizedBox(
        key: ValueKey(selected.keyName),
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
                border: Border.all(
                  color: const Color(0xFF9E47FF).withOpacity(0.55),
                  width: 1.2,
                ),
              ),
            ),
            Container(
              width: size * 0.68,
              height: size * 0.68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF9E47FF).withOpacity(0.45),
                  width: 1.2,
                ),
              ),
            ),
            Container(
              width: size * 0.58,
              height: size * 0.58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF7029BA).withOpacity(0.34),
                    const Color(0xFF7029BA).withOpacity(0.03),
                  ],
                ),
              ),
            ),
            Positioned(
              left: size * 0.04,
              top: size * 0.42,
              child: _orbitDot(8),
            ),
            Positioned(
              right: size * 0.03,
              top: size * 0.29,
              child: _orbitDot(11),
            ),
            Positioned(
              right: size * 0.11,
              bottom: size * 0.13,
              child: _orbitDot(7),
            ),
            Container(
              color: Colors.transparent,
              child: Image.asset(
                'assets/img/walk1.png',
                width: size * 1.30,
                height: size * 1.30,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orbitDot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [_orange, Color(0xFFFF6A3D)]),
      ),
    );
  }

  Widget _buildLevelSelector() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_levels.length, (index) {
        final _ActivityLevel level = _levels[index];
        final bool selected = _selectedIndex == index;

        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _selectedIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: selected ? 72 : 62,
                    height: selected ? 72 : 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(selected ? 0.045 : 0.075),
                      border: Border.all(
                        color: selected
                            ? _orange
                            : Colors.white.withOpacity(0.08),
                        width: selected ? 2 : 1,
                      ),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: _orange.withOpacity(0.14),
                                blurRadius: 18,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      level.icon,
                      color: selected
                          ? _orange
                          : Colors.white.withOpacity(0.44),
                      size: selected ? 34 : 29,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    level.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : Colors.white.withOpacity(0.75),
                      fontSize: 12.5,
                      height: 1.22,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildContinueButton() {
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
          onTap: _isSaving ? null : _continue,
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
                        'CONTINUE',
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

class _ActivityLevel {
  final String keyName;
  final String label;
  final String title;
  final String description;
  final IconData icon;

  const _ActivityLevel({
    required this.keyName,
    required this.label,
    required this.title,
    required this.description,
    required this.icon,
  });
}
