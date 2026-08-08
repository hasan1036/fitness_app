import 'package:flutter/material.dart';
import '../../common/color_extention.dart';
import 'categories_view.dart';

class ExerciseView extends StatefulWidget {
  const ExerciseView({super.key});

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> focusAreas = const [
    {'name': 'Full Body', 'icon': Icons.accessibility_new_rounded},
    {'name': 'Abs', 'icon': Icons.grid_view_rounded},
    {'name': 'Arms', 'icon': Icons.fitness_center_rounded},
    {'name': 'Chest', 'icon': Icons.monitor_heart_outlined},
    {'name': 'Back', 'icon': Icons.airline_seat_recline_extra_rounded},
  ];

  final List<Map<String, dynamic>> picks = const [
    {
      'name': 'Lose Belly Fat',
      'time': '13 min',
      'kcal': '184.6 kcal',
      'level': 'Beginner',
      'icon': Icons.straighten_rounded,
      'tone': 0xFFEAF8EE,
      'iconColor': 0xFF20A84B,
    },
    {
      'name': '20 Min Body Calorie Burner',
      'time': '19 min',
      'kcal': '229.1 kcal',
      'level': 'Intermediate',
      'icon': Icons.directions_run_rounded,
      'tone': 0xFFEAF3FF,
      'iconColor': 0xFF2575E6,
    },
    {
      'name': 'Fat Burning HIIT',
      'time': '9 min',
      'kcal': '117.6 kcal',
      'level': 'Advanced',
      'icon': Icons.local_fire_department_rounded,
      'tone': 0xFFF3ECFF,
      'iconColor': 0xFF7435E8,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCategories(String category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoriesView(initialCategory: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final horizontal = size.width < 380 ? 16.0 : 20.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFAFE),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 12, horizontal, 0),
                child: Column(
                  children: [
                    _header(context),
                    const SizedBox(height: 8),
                    Text(
                      'Explore and find the perfect workout for you',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: TColor.sceondarText,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _searchBox(),
                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ),

            // Focus Area is intentionally lower than the header/search and
            // horizontally scrollable, matching the selected design direction.
            SliverToBoxAdapter(
              child: _focusSection(horizontal),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 22, horizontal, 0),
                child: _sectionTitle('PICKS FOR YOU', showViewAll: true),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(horizontal, 10, horizontal, 0),
              sliver: SliverList.separated(
                itemCount: picks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, index) => _pickCard(picks[index]),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 22, horizontal, 0),
                child: LayoutBuilder(
                  builder: (context, c) {
                    if (c.maxWidth < 360) {
                      return Column(
                        children: [
                          _warmupCard(),
                          const SizedBox(height: 12),
                          _levelsCard(),
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _warmupCard()),
                        const SizedBox(width: 12),
                        Expanded(child: _levelsCard()),
                      ],
                    );
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 14, horizontal, 0),
                child: LayoutBuilder(
                  builder: (context, c) {
                    if (c.maxWidth < 390) {
                      return Column(
                        children: [
                          _durationCard(),
                          const SizedBox(height: 12),
                          _workoutTypeCard(),
                          const SizedBox(height: 12),
                          _equipmentCard(),
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 8, child: _durationCard()),
                        const SizedBox(width: 10),
                        Expanded(flex: 10, child: _workoutTypeCard()),
                        const SizedBox(width: 10),
                        Expanded(flex: 12, child: _equipmentCard()),
                      ],
                    );
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 16, horizontal, 28),
                child: _recommendationBanner(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        _roundIcon(
          icon: Icons.arrow_back_rounded,
          onTap: () => Navigator.pop(context),
        ),
        const Expanded(
          child: Text(
            'More Exercises',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF17131F),
              fontSize: 25,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ),
        _roundIcon(
          icon: Icons.history_rounded,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _roundIcon({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 1.5,
      shadowColor: TColor.primary.withOpacity(.18),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: TColor.primary, size: 25),
        ),
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: TColor.primary.withOpacity(.16)),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search exercises, workouts, goals...',
          hintStyle: TextStyle(color: TColor.sceondarText, fontSize: 13),
          prefixIcon: Icon(Icons.search_rounded, color: TColor.sceondarText),
          suffixIcon: Container(
            margin: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [TColor.primary, const Color(0xFF9B31F4)],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.tune_rounded, color: Colors.white, size: 21),
          ),
        ),
      ),
    );
  }

  Widget _focusSection(double horizontal) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: _panelDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: TColor.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'FOCUS AREA',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              InkWell(
                onTap: () => _openCategories('All'),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: TColor.primary, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 116,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: focusAreas.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, index) {
                final item = focusAreas[index];
                final String category =
                    (item['name'] as String) == 'Arms'
                        ? 'Arm'
                        : item['name'] as String;

                return InkWell(
                  onTap: () => _openCategories(category),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 92,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: TColor.primary.withOpacity(.10)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: TColor.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: TColor.primary,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['name'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, {bool showViewAll = false}) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: TColor.primary,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        if (showViewAll)
          InkWell(
            onTap: () => _openCategories(
              title == 'PICKS FOR YOU' ? 'Picks For You' : 'All',
            ),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: TColor.primary, size: 18),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _pickCard(Map<String, dynamic> item) {
    final iconColor = Color(item['iconColor'] as int);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: .8,
      shadowColor: TColor.primary.withOpacity(.12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child:Container(
          constraints: const BoxConstraints(
            minHeight: 102,
          ),
          padding: const EdgeInsets.all(10),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: TColor.primary.withOpacity(.08)),
          ),
          child: Row(
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: Color(item['tone'] as int),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(item['icon'] as IconData, color: iconColor, size: 43),
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
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded, size: 15, color: TColor.sceondarText),
                        const SizedBox(width: 4),
                        Text(item['time'] as String, style: _metaStyle()),
                        const SizedBox(width: 12),
                        Icon(Icons.local_fire_department_outlined, size: 15, color: TColor.sceondarText),
                        const SizedBox(width: 4),
                        Flexible(child: Text(item['kcal'] as String, style: _metaStyle())),
                      ],
                    ),
                    const SizedBox(height: 7),
                    _levelPill(item['level'] as String),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: TColor.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.chevron_right_rounded, color: TColor.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _metaStyle() => TextStyle(
        color: TColor.sceondarText,
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
      );

  Widget _levelPill(String level) {
    Color color;
    Color bg;
    if (level == 'Beginner') {
      color = const Color(0xFF159447);
      bg = const Color(0xFFEAF8EE);
    } else if (level == 'Intermediate') {
      color = const Color(0xFF1D6ED8);
      bg = const Color(0xFFEAF3FF);
    } else {
      color = TColor.primary;
      bg = TColor.primaryLight;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(level, style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w800)),
    );
  }

  Widget _warmupCard() {
    return _sectionPanel(
      title: 'STRETCHING & WARM UP',
      child: Row(
        children: [
          Expanded(child: _miniWorkout('Before Workout', '6 min', Icons.self_improvement_rounded)),
          const SizedBox(width: 8),
          Expanded(child: _miniWorkout('Fresh Start', '5 min', Icons.directions_walk_rounded)),
        ],
      ),
    );
  }

  Widget _miniWorkout(String title, String time, IconData icon) {
    return InkWell(
      onTap: () => _openCategories('Stretching & Warm Up'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: TColor.purpleSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: TColor.primary, size: 30),
          const SizedBox(height: 7),
          Text(title, textAlign: TextAlign.center, maxLines: 2,
              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(time, style: _metaStyle()),
        ],
      ),
      ),
    );
  }

  Widget _levelsCard() {
    return _sectionPanel(
      title: 'LEVELS',
      child: Column(
        children: [
          _levelRow('Beginner', 'Start Your Fitness Journey', const Color(0xFF22B455)),
          _levelRow('Intermediate', 'Level Up Your Workout', const Color(0xFF2584E8)),
          _levelRow('Advanced', 'Challenge Your Limits', TColor.primary),
        ],
      ),
    );
  }

  Widget _levelRow(String title, String subtitle, Color color) {
    return InkWell(
      onTap: () => _openCategories(title),
      borderRadius: BorderRadius.circular(13),
      child: Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(.07),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(Icons.bar_chart_rounded, color: color, size: 26),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
                Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 8.5, color: TColor.sceondarText)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: TColor.primary, size: 17),
        ],
      ),
      ),
    );
  }

  Widget _durationCard() {
    return _sectionPanel(
      title: 'DURATION',
      child: Column(
        children: [
          _filterTile(Icons.timer_outlined, '< 10 min', const Color(0xFF28A94F)),
          _filterTile(Icons.schedule_rounded, '10–15 min', const Color(0xFF2584E8)),
          _filterTile(Icons.access_time_rounded, '16–35 min', TColor.primary),
        ],
      ),
    );
  }

  Widget _workoutTypeCard() {
    const items = [
      ('Yoga', Icons.self_improvement_rounded, Color(0xFF18A56C)),
      ('HIIT', Icons.local_fire_department_rounded, Color(0xFFFF6B18)),
      ('Strength', Icons.fitness_center_rounded, Color(0xFF7134DF)),
      ('Cardio', Icons.favorite_border_rounded, Color(0xFFFF3D76)),
      ('Pilates', Icons.airline_seat_flat_angled_rounded, Color(0xFF1CB7A5)),
      ('Mobility', Icons.directions_run_rounded, Color(0xFFFFA000)),
      ('Stretch', Icons.accessibility_new_rounded, Color(0xFF7541E8)),
      ('Recovery', Icons.spa_outlined, Color(0xFF58A82B)),
    ];
    return _sectionPanel(
      title: 'WORKOUT TYPE',
      child: Wrap(
        spacing: 6,
        runSpacing: 7,
        children: items.map((e) => _tinyIconTile(e.$1, e.$2, e.$3)).toList(),
      ),
    );
  }

  Widget _equipmentCard() {
    const items = [
      ('No Equipment', Icons.block_rounded, Color(0xFF52A934)),
      ('Dumbbell', Icons.fitness_center_rounded, Color(0xFF7541E8)),
      ('Kettlebell', Icons.sports_gymnastics_rounded, Color(0xFFFF6B18)),
      ('Band', Icons.link_rounded, Color(0xFF2584E8)),
      ('Bench', Icons.weekend_outlined, Color(0xFFFF3D76)),
      ('Pull-up', Icons.horizontal_rule_rounded, Color(0xFF1CB7A5)),
      ('Ball', Icons.sports_soccer_outlined, Color(0xFF2584E8)),
      ('Rope', Icons.linear_scale_rounded, Color(0xFF7541E8)),
    ];
    return _sectionPanel(
      title: 'EQUIPMENT',
      child: Wrap(
        spacing: 6,
        runSpacing: 7,
        children: items.map((e) => _tinyIconTile(e.$1, e.$2, e.$3)).toList(),
      ),
    );
  }

  Widget _filterTile(IconData icon, String text, Color color) {
    final category = text.replaceAll('–', '–');
    return InkWell(
      onTap: () => _openCategories(category),
      borderRadius: BorderRadius.circular(13),
      child: Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(.06),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 7),
          Flexible(child: Text(text, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800))),
        ],
      ),
      ),
    );
  }

  Widget _tinyIconTile(String title, IconData icon, Color color) {
    String category = 'All';
    if (title == 'HIIT' || title == 'Cardio') {
      category = 'Fat-Burning';
    } else if (title == 'Strength' ||
        title == 'Dumbbell' ||
        title == 'Kettlebell' ||
        title == 'Band' ||
        title == 'Bench' ||
        title == 'Pull-up') {
      category = 'Strength & Tone';
    } else if (title == 'Stretch' ||
        title == 'Yoga' ||
        title == 'Pilates' ||
        title == 'Mobility' ||
        title == 'Recovery') {
      category = 'Stretching & Warm Up';
    }

    return SizedBox(
      width: 64,
      child: InkWell(
        onTap: () => _openCategories(category),
        borderRadius: BorderRadius.circular(13),
        child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(.055),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 21),
            const SizedBox(height: 4),
            Text(title, textAlign: TextAlign.center, maxLines: 2,
                style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700)),
          ],
        ),
        ),
      ),
    );
  }

  Widget _sectionPanel({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: TColor.primary.withOpacity(.07)),
      boxShadow: [
        BoxShadow(
          color: TColor.primary.withOpacity(.055),
          blurRadius: 18,
          offset: const Offset(0, 7),
        ),
      ],
    );
  }

  Widget _recommendationBanner() {
    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF5A22D2), Color(0xFFA02BEA)],
        ),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events_rounded, color: Color(0xFFFFB21A), size: 34),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Can't find what you want?",
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  "Tell us your goal and we'll suggest the best workout plan for you.",
                  style: TextStyle(color: Colors.white.withOpacity(.88), fontSize: 10.5, height: 1.3),
                ),
                const SizedBox(height: 9),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                      child: Text(
                        'Get Recommendation  →',
                        style: TextStyle(color: TColor.primary, fontSize: 10, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
