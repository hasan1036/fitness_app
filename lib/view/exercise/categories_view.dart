import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../data/extra_workout_data.dart';
import 'extra_workout_detail_view.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({
    super.key,
    required this.initialCategory,
  });

  final String initialCategory;

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  static const List<String> _tabs = [
    'All',
    'Full Body',
    'Abs',
    'Arm',
    'Chest',
    'Butt & Leg',
    'Picks For You',
    'Stretching & Warm Up',
    'Fat-Burning',
    'Strength & Tone',
    'Beginner',
    'Intermediate',
    'Advanced',
    '< 10 min',
    '10–15 min',
    '16–35 min',
  ];

  final ScrollController _tabController = ScrollController();
  late String _selected;

  final List<Map<String, dynamic>> _workouts = [
    {
      'name': 'Sleepy Time Stretching',
      'minutes': 8,
      'kcal': 56.1,
      'level': 'Beginner',
      'image': 'assets/img/11.png',
      'tags': ['All', 'Full Body', 'Stretching & Warm Up', 'Beginner', '< 10 min'],
    },
    {
      'name': 'Before Workout Warmup',
      'minutes': 3,
      'kcal': 40.8,
      'level': 'Beginner',
      'image': 'assets/img/2.png',
      'tags': ['All', 'Full Body', 'Stretching & Warm Up', 'Beginner', '< 10 min'],
    },
    {
      'name': 'Fat Burning HIIT',
      'minutes': 9,
      'kcal': 117.6,
      'level': 'Intermediate',
      'image': 'assets/img/pic1.png',
      'tags': ['All', 'Full Body', 'Fat-Burning', 'Intermediate', '< 10 min', 'Picks For You'],
    },
    {
      'name': 'Full Body Stretching',
      'minutes': 7,
      'kcal': 48.0,
      'level': 'Beginner',
      'image': 'assets/img/3.png',
      'tags': ['All', 'Full Body', 'Stretching & Warm Up', 'Beginner', '< 10 min'],
    },
    {
      'name': '20 Min Body Calorie Burner',
      'minutes': 19,
      'kcal': 229.1,
      'level': 'Intermediate',
      'image': 'assets/img/pic2.png',
      'tags': ['All', 'Full Body', 'Fat-Burning', 'Intermediate', '16–35 min', 'Picks For You'],
    },
    {
      'name': 'Lose Fat (NO JUMPING!)',
      'minutes': 14,
      'kcal': 162.9,
      'level': 'Intermediate',
      'image': 'assets/img/pic3.png',
      'tags': ['All', 'Full Body', 'Fat-Burning', 'Strength & Tone', 'Intermediate', '10–15 min', 'Picks For You'],
    },
    {
      'name': 'Ripped V-cut Abs Sculpting',
      'minutes': 18,
      'kcal': 241.2,
      'level': 'Intermediate',
      'image': 'assets/img/1.png',
      'tags': ['All', 'Abs', 'Strength & Tone', 'Intermediate', '16–35 min'],
    },
    {
      'name': 'Beginner Abs Shred',
      'minutes': 11,
      'kcal': 136.0,
      'level': 'Beginner',
      'image': 'assets/img/11.png',
      'tags': ['All', 'Abs', 'Beginner', 'Strength & Tone', '10–15 min'],
    },
    {
      'name': 'Lose Belly Fat',
      'minutes': 13,
      'kcal': 184.6,
      'level': 'Beginner',
      'image': 'assets/img/2.png',
      'tags': ['All', 'Abs', 'Fat-Burning', 'Beginner', '10–15 min', 'Picks For You'],
    },
    {
      'name': 'Beginner Weighted Abs Burn',
      'minutes': 6,
      'kcal': 97.5,
      'level': 'Beginner',
      'image': 'assets/img/3.png',
      'tags': ['All', 'Abs', 'Strength & Tone', 'Beginner', '< 10 min'],
    },
    {
      'name': 'Beginner-Friendly Arm Toning',
      'minutes': 13,
      'kcal': 138.8,
      'level': 'Beginner',
      'image': 'assets/img/pic1.png',
      'tags': ['All', 'Arm', 'Strength & Tone', 'Beginner', '10–15 min'],
    },
    {
      'name': 'Dumbbell Arm Toning',
      'minutes': 16,
      'kcal': 214.5,
      'level': 'Intermediate',
      'image': 'assets/img/pic2.png',
      'tags': ['All', 'Arm', 'Strength & Tone', 'Intermediate', '16–35 min'],
    },
    {
      'name': 'Beginner Chest Workout',
      'minutes': 4,
      'kcal': 51.4,
      'level': 'Beginner',
      'image': 'assets/img/pic3.png',
      'tags': ['All', 'Chest', 'Strength & Tone', 'Beginner', '< 10 min'],
    },
    {
      'name': 'Quick Bigger Chest Building',
      'minutes': 6,
      'kcal': 67.2,
      'level': 'Intermediate',
      'image': 'assets/img/11.png',
      'tags': ['All', 'Chest', 'Strength & Tone', 'Intermediate', '< 10 min'],
    },
    {
      'name': 'Classic Chest · Intermediate',
      'minutes': 6,
      'kcal': 95.0,
      'level': 'Intermediate',
      'image': 'assets/img/2.png',
      'tags': ['All', 'Chest', 'Strength & Tone', 'Intermediate', '< 10 min'],
    },
    {
      'name': 'Ultimate Chest Pump',
      'minutes': 21,
      'kcal': 232.6,
      'level': 'Advanced',
      'image': 'assets/img/3.png',
      'tags': ['All', 'Chest', 'Strength & Tone', 'Advanced', '16–35 min'],
    },
    {
      'name': 'Strong Legs & Butt Builder',
      'minutes': 26,
      'kcal': 270.6,
      'level': 'Advanced',
      'image': 'assets/img/pic1.png',
      'tags': ['All', 'Butt & Leg', 'Strength & Tone', 'Advanced', '16–35 min'],
    },
    {
      'name': 'Easy Butt & Leg Session',
      'minutes': 5,
      'kcal': 58.0,
      'level': 'Beginner',
      'image': 'assets/img/pic2.png',
      'tags': ['All', 'Butt & Leg', 'Beginner', '< 10 min'],
    },
    {
      'name': '7 Min Lower Body Stretch Routine',
      'minutes': 10,
      'kcal': 66.6,
      'level': 'Beginner',
      'image': 'assets/img/pic3.png',
      'tags': ['All', 'Butt & Leg', 'Stretching & Warm Up', 'Beginner', '10–15 min'],
    },
    {
      'name': 'Fresh Start Warm Up',
      'minutes': 6,
      'kcal': 58.4,
      'level': 'Beginner',
      'image': 'assets/img/11.png',
      'tags': ['All', 'Stretching & Warm Up', 'Beginner', '< 10 min'],
    },
    {
      'name': 'Lazy Morning Stretching',
      'minutes': 7,
      'kcal': 55.5,
      'level': 'Beginner',
      'image': 'assets/img/2.png',
      'tags': ['All', 'Stretching & Warm Up', 'Beginner', '< 10 min'],
    },
    {
      'name': 'Intense Total Core Shred',
      'minutes': 35,
      'kcal': 439.3,
      'level': 'Advanced',
      'image': 'assets/img/3.png',
      'tags': ['All', 'Abs', 'Fat-Burning', 'Advanced', '16–35 min'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _selected = _normalize(widget.initialCategory);
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerSelectedTab());
  }

  String _normalize(String value) {
    if (value == 'Arms') return 'Arm';
    if (value == '<10 min') return '< 10 min';
    if (value == '10-15 min') return '10–15 min';
    if (value == '16-35 min') return '16–35 min';
    return _tabs.contains(value) ? value : 'All';
  }

  List<Map<String, dynamic>> get _filtered {
    if (_selected == 'All') return _workouts;
    return _workouts.where((item) {
      final tags = List<String>.from(item['tags'] as List);
      return tags.contains(_selected);
    }).toList();
  }

  void _select(String tab) {
    setState(() => _selected = tab);
  }

  void _centerSelectedTab() {
    final index = _tabs.indexOf(_selected);
    if (index < 0 || !_tabController.hasClients) return;
    final target = (index * 94.0)
        .clamp(
          0.0,
          _tabController.position.maxScrollExtent,
        )
        .toDouble();
    _tabController.animateTo(
      target,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width < 380 ? 14.0 : 18.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFAFE),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(horizontal, 10, horizontal, 8),
              child: Row(
                children: [
                  Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 1,
                    shadowColor: TColor.primary.withOpacity(.16),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.pop(context),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: TColor.primary,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Text(
                    'Categories',
                    style: TextStyle(
                      color: Color(0xFF17131F),
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.6,
                    ),
                  ),
                ],
              ),
            ),
            _tabsBar(),
            const SizedBox(height: 10),
            Expanded(
              child: _filtered.isEmpty
                  ? _emptyState()
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontal,
                        4,
                        horizontal,
                        24,
                      ),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (_, index) =>
                          _workoutCard(_filtered[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabsBar() {
    return Container(
      height: 92,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: TColor.primary.withOpacity(.06)),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(.055),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListView.separated(
        controller: _tabController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, index) {
          final tab = _tabs[index];
          final selected = tab == _selected;
          return InkWell(
            onTap: () => _select(tab),
            borderRadius: BorderRadius.circular(17),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: selected ? TColor.primaryLight : Colors.transparent,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tabIcon(tab, selected),
                  const SizedBox(height: 5),
                  Text(
                    tab,
                    maxLines: 1,
                    style: TextStyle(
                      color: selected
                          ? TColor.primary
                          : const Color(0xFF6F6A79),
                      fontSize: 12,
                      fontWeight:
                          selected ? FontWeight.w900 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: selected ? 28 : 0,
                    height: 3,
                    decoration: BoxDecoration(
                      color: TColor.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _tabIcon(String tab, bool selected) {
    IconData icon = Icons.category_outlined;
    if (tab == 'All') icon = Icons.grid_view_rounded;
    if (tab == 'Full Body') icon = Icons.accessibility_new_rounded;
    if (tab == 'Abs') icon = Icons.grid_on_rounded;
    if (tab == 'Arm') icon = Icons.fitness_center_rounded;
    if (tab == 'Chest') icon = Icons.monitor_heart_outlined;
    if (tab == 'Butt & Leg') icon = Icons.directions_run_rounded;
    if (tab == 'Picks For You') icon = Icons.auto_awesome_rounded;
    if (tab == 'Stretching & Warm Up') icon = Icons.self_improvement_rounded;
    if (tab == 'Fat-Burning') icon = Icons.local_fire_department_rounded;
    if (tab == 'Strength & Tone') icon = Icons.fitness_center_rounded;
    if (tab == 'Beginner' ||
        tab == 'Intermediate' ||
        tab == 'Advanced') {
      icon = Icons.bar_chart_rounded;
    }
    if (tab.contains('min')) icon = Icons.schedule_rounded;

    return Icon(
      icon,
      color: selected ? TColor.primary : const Color(0xFF87818F),
      size: 25,
    );
  }

  Widget _workoutCard(Map<String, dynamic> item) {
    final level = item['level'] as String;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      elevation: .8,
      shadowColor: TColor.primary.withOpacity(.10),
      child: InkWell(
        onTap: () {
          final workout = ExtraWorkoutCatalog.fromCategoryItem(
            name: item['name'] as String,
            coverImage: item['image'] as String,
            minutes: item['minutes'] as int,
            kcal: (item['kcal'] as num).toDouble(),
            level: item['level'] as String,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExtraWorkoutDetailView(workout: workout),
            ),
          );
        },
        borderRadius: BorderRadius.circular(22),
        child: Container(
          constraints: const BoxConstraints(minHeight: 120),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: TColor.primary.withOpacity(.07)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Image.asset(
                  item['image'] as String,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: TColor.primaryLight,
                      child: Icon(
                        Icons.fitness_center_rounded,
                        color: TColor.primary,
                        size: 38,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF17131F),
                        fontSize: 16.5,
                        height: 1.12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 15,
                          color: TColor.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item['minutes']} min',
                          style: _metaStyle(),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 1,
                          height: 14,
                          color: const Color(0xFFDAD5E2),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.local_fire_department_outlined,
                          size: 16,
                          color: TColor.primary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${(item['kcal'] as num).toStringAsFixed(1)} kcal',
                            style: _metaStyle(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _levelChip(level),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: TColor.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: TColor.primary,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _metaStyle() {
    return TextStyle(
      color: TColor.sceondarText,
      fontSize: 11.5,
      fontWeight: FontWeight.w600,
    );
  }

  Widget _levelChip(String level) {
    Color fg;
    Color bg;
    if (level == 'Beginner') {
      fg = const Color(0xFF159447);
      bg = const Color(0xFFEAF8EE);
    } else if (level == 'Intermediate') {
      fg = const Color(0xFF1D6ED8);
      bg = const Color(0xFFEAF3FF);
    } else {
      fg = TColor.primary;
      bg = TColor.primaryLight;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level,
        style: TextStyle(
          color: fg,
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: TColor.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                color: TColor.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No workouts found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Try another category.',
              style: TextStyle(
                color: TColor.sceondarText,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
