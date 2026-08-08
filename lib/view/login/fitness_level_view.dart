import 'package:flutter/material.dart';

import '../../common/smooth_page_route.dart';
import '../../service/user_profile_service.dart';
import 'plan_loading_view.dart';

class FitnessLevelView extends StatefulWidget {
  const FitnessLevelView({super.key});

  @override
  State<FitnessLevelView> createState() => _FitnessLevelViewState();
}

class _FitnessLevelViewState extends State<FitnessLevelView> {
  static const Color _bgTop = Color(0xFF26104B);
  static const Color _bgBottom = Color(0xFF080D23);
  static const Color _purple = Color(0xFF8B3DFF);
  static const Color _purple2 = Color(0xFF6324D8);
  static const Color _orange = Color(0xFFFFA31A);
  static const Color _green = Color(0xFF26C281);

  int _selectedIndex = 0;
  bool _isSaving = false;

  final List<_FitnessLevelItem> _levels = const [
    _FitnessLevelItem(
      keyName: 'beginner',
      title: 'Beginner',
      subtitle: "I'm totally new to fitness",
      icon: Icons.layers_rounded,
      accent: _purple,
    ),
    _FitnessLevelItem(
      keyName: 'intermediate',
      title: 'Intermediate',
      subtitle: "I've got fitness experience and am ready to progress",
      icon: Icons.bar_chart_rounded,
      accent: _orange,
    ),
    _FitnessLevelItem(
      keyName: 'advanced',
      title: 'Advanced',
      subtitle: "I'm a fitness enthusiast with experience in diverse workout types",
      icon: Icons.workspace_premium_rounded,
      accent: _green,
    ),
  ];

  Future<void> _next() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final String selectedLevel = _levels[_selectedIndex].keyName;

    await UserProfileService.completeInitialSetup(selectedLevel);

    if (!mounted) return;
    setState(() => _isSaving = false);

    Navigator.of(context).pushReplacement(
      smoothPageRoute(const PlanLoadingView()),
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
              final bool compact = constraints.maxHeight < 700;
              final double horizontal =
                  (constraints.maxWidth * 0.055).clamp(18.0, 26.0);

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontal,
                        compact ? 8 : 14,
                        horizontal,
                        16,
                      ),
                      child: Column(
                        children: [
                          _buildTopBar(),
                          SizedBox(height: compact ? 24 : 34),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: compact ? 28 : 32,
                                height: 1.08,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.6,
                              ),
                              children: const [
                                TextSpan(text: "What's your\n"),
                                TextSpan(
                                  text: 'fitness level?',
                                  style: TextStyle(color: _purple),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'This helps us personalize\nyour workout plan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.65),
                              fontSize: compact ? 13 : 14,
                              height: 1.45,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: compact ? 26 : 34),
                          ...List.generate(_levels.length, (index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == _levels.length - 1
                                    ? 0
                                    : (compact ? 12 : 15),
                              ),
                              child: _buildLevelCard(index, compact),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontal,
                      8,
                      horizontal,
                      compact ? 12 : 18,
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
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: List.generate(6, (index) {
              final bool completed = index < 5;
              final bool current = index == 5;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  height: current ? 4 : 3.5,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: current
                        ? _purple
                        : completed
                            ? _purple.withOpacity(0.55)
                            : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(99),
                    boxShadow: current
                        ? [
                            BoxShadow(
                              color: _purple.withOpacity(0.45),
                              blurRadius: 10,
                            ),
                          ]
                        : null,
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

  Widget _buildLevelCard(int index, bool compact) {
    final _FitnessLevelItem level = _levels[index];
    final bool selected = _selectedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        constraints: BoxConstraints(minHeight: compact ? 104 : 116),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 14 : 16,
          vertical: compact ? 13 : 16,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF1E1238)
              : Colors.white.withOpacity(0.035),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? _purple
                : Colors.white.withOpacity(0.09),
            width: selected ? 1.6 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _purple.withOpacity(0.22),
                    blurRadius: 24,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: _purple.withOpacity(0.10),
                    blurRadius: 8,
                    spreadRadius: -1,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: compact ? 56 : 62,
              height: compact ? 56 : 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    level.accent.withOpacity(0.98),
                    level.accent.withOpacity(0.60),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: level.accent.withOpacity(0.25),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Icon(
                level.icon,
                color: Colors.white,
                size: compact ? 29 : 32,
              ),
            ),
            SizedBox(width: compact ? 13 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    level.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 18 : 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    level.subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.70),
                      fontSize: compact ? 12.2 : 13.2,
                      height: 1.35,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: compact ? 9 : 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: compact ? 27 : 30,
              height: compact ? 27 : 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? _purple : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? _purple
                      : Colors.white.withOpacity(0.45),
                  width: 1.5,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: _purple.withOpacity(0.45),
                          blurRadius: 12,
                        ),
                      ]
                    : null,
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    )
                  : null,
            ),
          ],
        ),
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
          colors: [_purple, _purple2],
        ),
        boxShadow: [
          BoxShadow(
            color: _purple.withOpacity(0.32),
            blurRadius: 24,
            offset: const Offset(0, 9),
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
                      color: Colors.white,
                      strokeWidth: 2.3,
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
                      SizedBox(width: 10),
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

class _FitnessLevelItem {
  final String keyName;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;

  const _FitnessLevelItem({
    required this.keyName,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });
}
