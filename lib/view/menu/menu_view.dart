import 'dart:io';
import 'dart:ui' as ui;

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../reports/reports_view.dart';
import '../../service/profile_service.dart';
import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../common/responsive.dart';
import '../../data/workout_day_view.dart';
import '../../service/workout_progress_service.dart';
import '../../service/workout_stats_service.dart';

import '../home/home_view.dart';
import '../profile/me_view.dart';
import '../plan/plan_view.dart';
import '../schedule/schedule_view.dart';
import '../exercise/exercise_view.dart';
import '../reminder/sleep_reminder_view.dart';
import '../reminder/meal_reminder_view.dart';
import '../reminder/water_reminder_view.dart';
import '../reminder/workout_reminder_view.dart';
import '../../common_widget/app_drawer.dart';



import '../../l10n/app_localizations.dart';
class MenuView extends StatefulWidget  {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> with TickerProviderStateMixin {
  double _rs(double value) => AppResponsive.size(context, value);
  double _rh(double value) => AppResponsive.height(context, value);
  double _rf(double value) => AppResponsive.font(context, value);

  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();

  String get greeting {
    final int hour = DateTime.now().hour;

    if (hour < 12) return context.tr('goodMorning');
    if (hour < 17) return context.tr('goodAfternoon');
    if (hour < 21) return context.tr('goodEvening');
    return context.tr('goodNight');
  }

  String get currentDate {
    final Locale locale = Localizations.localeOf(context);
    return DateFormat.yMMMMEEEEd(locale.toLanguageTag())
        .format(DateTime.now());
  }
  final ImagePicker _imagePicker = ImagePicker();

  String profileName = "Name";
  String? profileImagePath;
  /// বর্তমানে কোন Day selected
  int selectedDay = 0;

  int totalWorkouts = 0;
  double totalCalories = 0;
  int currentStreak = 0;

  bool workoutReminderEnabled = false;
  bool waterReminderEnabled = false;
  bool mealReminderEnabled = false;
  bool sleepReminderEnabled = false;

  String workoutReminderValue = "Not set";
  String waterReminderValue = "Not set";
  String mealReminderValue = "Not set";
  String sleepReminderValue = "Not set";

  /// =====================================================
  /// 30 WORKOUT DAYS
  /// =====================================================

  late final List<Map<String, dynamic>> dayList;

  late AnimationController _arrowController;
  late Animation<Offset> _arrowAnimation;
  late AnimationController _borderController;
  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _arrowAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.18, 0),
    ).animate(
      CurvedAnimation(
        parent: _arrowController,
        curve: Curves.easeInOut,
      ),
    );

    _arrowController.repeat(reverse: true);

    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    dayList = List.generate(30, (index) {
      final int day = index + 1;

      return {
        "day": "Day $day",
        "time": "5 min",
        "calorie": "${(68.1 + index).toStringAsFixed(1)} kcal",
        "image": index % 3 == 0
            ? "assets/img/pic1.png"
            : index % 3 == 1
            ? "assets/img/pic2.png"
            : "assets/img/pic3.png",
      };
    });

    _loadWorkoutStats();
    _loadProfile();
    _loadReminderSummary();
  }

  Future<void> _loadReminderSummary() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    final int workoutHour =
        prefs.getInt('workout_reminder_hour') ?? 19;
    final int workoutMinute =
        prefs.getInt('workout_reminder_minute') ?? 0;

    final int waterInterval =
        prefs.getInt('water_reminder_interval') ?? 60;

    final int breakfastHour =
        prefs.getInt('meal_breakfast_hour') ?? 8;
    final int breakfastMinute =
        prefs.getInt('meal_breakfast_minute') ?? 0;

    final int sleepHour =
        prefs.getInt('sleep_reminder_bed_hour') ?? 22;
    final int sleepMinute =
        prefs.getInt('sleep_reminder_bed_minute') ?? 30;

    if (!mounted) return;

    setState(() {
      workoutReminderEnabled =
          prefs.getBool('workout_reminder_enabled') ?? false;
      waterReminderEnabled =
          prefs.getBool('water_reminder_enabled') ?? false;
      mealReminderEnabled =
          prefs.getBool('meal_reminder_enabled') ?? false;
      sleepReminderEnabled =
          prefs.getBool('sleep_reminder_enabled') ?? false;

      workoutReminderValue = _formatTime(
        workoutHour,
        workoutMinute,
      );

      waterReminderValue = waterInterval >= 60
          ? 'Every ${waterInterval ~/ 60}h'
          : 'Every ${waterInterval}m';

      mealReminderValue = _formatTime(
        breakfastHour,
        breakfastMinute,
      );

      sleepReminderValue = _formatTime(
        sleepHour,
        sleepMinute,
      );
    });
  }

  String _formatTime(int hour, int minute) {
    final TimeOfDay time = TimeOfDay(
      hour: hour,
      minute: minute,
    );

    return time.format(context);
  }

  Future<void> _openReminderPage(Widget page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );

    if (!mounted) return;

    await _loadReminderSummary();
  }

  Future<void> _loadProfile() async {
    final String savedName =
    await ProfileService.getName();

    final String? savedImagePath =
    await ProfileService.getImagePath();

    if (!mounted) return;

    setState(() {
      profileName = savedName;
      profileImagePath = savedImagePath;
    });
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null || !mounted) return;

      final File selectedFile = File(pickedFile.path);
      if (!await selectedFile.exists()) return;

      await ProfileService.saveImagePath(pickedFile.path);

      if (!mounted) return;

      setState(() {
        profileImagePath = pickedFile.path;
      });
    } catch (error, stackTrace) {
      debugPrint('Profile image picker error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _changeName() async {
    final TextEditingController controller =
    TextEditingController(text: profileName);

    final String? newName = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(dialogContext.tr('changeName')),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: dialogContext.tr('enterName'),
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              final String name = value.trim();

              if (name.isEmpty) return;

              Navigator.of(dialogContext).pop(name);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(dialogContext.tr('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                final String name = controller.text.trim();

                if (name.isEmpty) return;

                Navigator.of(dialogContext).pop(name);
              },
              child: Text(dialogContext.tr('save')),
            ),
          ],
        );
      },
    );

    // এখানে controller.dispose() দেবে না।
    // Dialog বন্ধ হওয়ার animation চলাকালে TextField controller ব্যবহার করে,
    // তাই dispose করলে crash হচ্ছিল।

    if (!mounted || newName == null) return;

    final String cleanName = newName.trim();

    if (cleanName.isEmpty) return;

    await ProfileService.saveName(cleanName);

    if (!mounted) return;

    setState(() {
      profileName = cleanName;
    });
  }

  ImageProvider<Object> _profileImageProvider() {
    final String? path = profileImagePath;

    if (path != null && path.trim().isNotEmpty) {
      final File imageFile = File(path);

      if (imageFile.existsSync()) {
        return FileImage(imageFile);
      }
    }

    return const AssetImage('assets/img/u1.png');
  }

  Future<void> _loadWorkoutStats() async {
    final int workouts =
    await WorkoutStatsService.getWorkout();

    final double calories =
    await WorkoutStatsService.getCalories();

    final int streak =
    await WorkoutStatsService.getStreak();

    if (!mounted) return;

    setState(() {
      totalWorkouts = workouts;
      totalCalories = calories;
      currentStreak = streak;
    });
  }

  /// =====================================================
  /// BUILD
  /// =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        profileName: profileName,
        profileImagePath: profileImagePath,
      ),

      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [



              /// =================================================
              /// PURPLE PROFILE HEADER
              /// =================================================

              _buildHeader(),

              /// =================================================
              /// WHITE BODY
              /// =================================================

              Container(
                width: double.infinity,

                decoration: const BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: _rh(12)),

                    /// =================================================
                    /// TODAY'S REMINDERS
                    /// =================================================

                    _buildReminderSection(),

                    const SizedBox(height: 16),

                    /// =================================================
                    /// STAGE TITLE
                    /// =================================================

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                      child: Row(
                        children: [
                          // LEFT SIDE: Stage 1 + Start Strong
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  context.tr('stage1'),
                                  style: TextStyle(
                                    fontSize: _rf(23),
                                    color: TColor.primaryText,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),

                                SizedBox(width: _rs(8)),

                                Flexible(
                                  child: Text(
                                    context.tr('startStrong'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: _rf(15),
                                      color: TColor.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // RIGHT SIDE: More Exercises
                          AnimatedBuilder(
                            animation: _borderController,
                            builder: (context, child) {
                              return Container(
                                padding: const EdgeInsets.all(1.8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  gradient: SweepGradient(
                                    transform: GradientRotation(
                                      _borderController.value * 2 * 3.141592653589793,
                                    ),
                                    colors: [
                                      TColor.primary.withOpacity(0.18),
                                      TColor.primary,
                                      const Color(0xFFFF9818),
                                      TColor.primary,
                                      TColor.primary.withOpacity(0.18),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: TColor.primary.withOpacity(0.18),
                                      blurRadius: 8,
                                      spreadRadius: 0.5,
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(999),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const ExerciseView(),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(999),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: _rs(10),
                                        vertical: _rh(7),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'MORE EXERCISES',
                                            style: TextStyle(
                                              color: TColor.primary,
                                              fontSize: _rf(9.5),
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.15,
                                            ),
                                          ),
                                          SizedBox(width: _rs(4)),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            size: _rs(14),
                                            color: TColor.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// =================================================
                    /// DAY 1 - DAY 30
                    /// এই অংশ নিজের মধ্যে Scroll করবে
                    /// =================================================

                    _buildDayList(),

                    const SizedBox(height: 15),

                    /// =================================================
                    /// FULL 30 DAYS PLAN BUTTON
                    /// =================================================

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PlanView(),
                            ),
                          );
                        },

                        child: Container(
                          height: 58,

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(18),

                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),

                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                            ),

                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,

                                  decoration: BoxDecoration(
                                    color: TColor.primary,
                                    borderRadius:
                                    BorderRadius.circular(12),
                                  ),

                                  child: const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.white,
                                    size: 21,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Text(context.tr('full30DaysPlan'),
                                    style: TextStyle(
                                      fontSize: _rf(15),
                                      color: TColor.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),

                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: TColor.primary,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// =================================================
                    /// BOTTOM NAVIGATION
                    /// =================================================

                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: _buildBottomBar(),

    );


  }

  /// =====================================================
  /// HEADER
  /// =====================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: TColor.primary,

        image: const DecorationImage(
          image: AssetImage(
            "assets/img/gim.png",
          ),
          fit: BoxFit.cover,
        ),
      ),

      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,

            colors: [
              TColor.primaryDark.withOpacity(0.98),
              TColor.primary.withOpacity(0.78),
              Colors.black.withOpacity(0.25),
            ],
          ),
        ),

        child: Padding(
          padding: EdgeInsets.fromLTRB(
            _rs(18),
            _rh(8),
            _rs(18),
            _rh(12),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// MENU + NOTIFICATION

              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                        /// Future Drawer
                      },

                      icon: const Icon(
                        Icons.menu_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),

                    Stack(
                      children: [
                        IconButton(
                          tooltip: context.tr('scheduleReminders'),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ScheduleView(),
                              ),
                            );

                            if (!mounted) return;
                            await _loadReminderSummary();
                          },

                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),

                        Positioned(
                          right: 8,
                          top: 7,

                          child: Container(
                            width: 9,
                            height: 9,

                            decoration: BoxDecoration(
                              color: const Color(0xffB76CFF),
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),



              /// =================================================
              /// PROFILE
              /// =================================================

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.20),
                    ),

                    child: GestureDetector(
                      onTap: _pickProfileImage,
                      child: CircleAvatar(
                        radius: _rs(32),
                        backgroundColor: Colors.white,
                        backgroundImage: _profileImageProvider(),
                      ),
                    ),
                  ),

                  SizedBox(width: _rs(12)),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        Text(
                          greeting,
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: _rf(13),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          currentDate,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: _rf(11.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        GestureDetector(
                          onTap: _changeName,
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  profileName == "Name"
                                      ? context.tr('name')
                                      : profileName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:  TextStyle(
                                    color: Colors.white,
                                    fontSize: _rf(23),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: _rh(4)),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: _rs(11),
                            vertical: _rh(5),
                          ),

                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.13),
                            borderRadius:
                            BorderRadius.circular(20),
                          ),

                          child: Text(context.tr('keepPushing'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _rf(10.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: _rh(12)),

              /// =================================================
              /// STATS
              /// =================================================

              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.fitness_center_rounded,
                        title: context.tr('workouts'),
                        value: totalWorkouts.toString(),
                        bottom: context.tr('thisWeek'),
                      ),
                    ),

                    const SizedBox(width: 7),

                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.local_fire_department,
                        title: context.tr('calories'),
                        value: totalCalories.toStringAsFixed(0),
                        bottom: context.tr('burned'),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.bolt_rounded,
                        title: context.tr('streak'),
                        value: currentStreak.toString(),
                        bottom: context.tr('days'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// =====================================================
  /// STAT CARD
  /// =====================================================

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String bottom,
  }) {
    return Container(
      height: _rh(68),
      padding: EdgeInsets.symmetric(
        horizontal: _rs(7),
        vertical: _rh(6),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: _rs(27),
            height: _rs(27),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TColor.primary.withOpacity(0.55),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: _rf(14),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:  TextStyle(
                    color: Colors.white,
                    fontSize: _rf(8.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:  TextStyle(
                    color: Colors.white,
                    fontSize: _rf(15),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  bottom,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: _rf(8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderSection() {
    final List<Map<String, dynamic>> reminders = [
      {
        'title': context.tr('schedule'),
        'value': context.tr('manageAll'),
        'enabled': true,
        'isSchedule': true,
        'icon': Icons.calendar_month_rounded,
        'background': const Color(0xffEEE7FF),
        'iconColor': TColor.primary,
        'page': const ScheduleView(),
      },
      {
        'title': context.tr('workout'),
        'value': workoutReminderValue,
        'enabled': workoutReminderEnabled,
        'icon': Icons.fitness_center_rounded,
        'background': const Color(0xffF3ECFF),
        'iconColor': TColor.primary,
        'page': const WorkoutReminderView(),
      },
      {
        'title': context.tr('water'),
        'value': waterReminderValue,
        'enabled': waterReminderEnabled,
        'icon': Icons.water_drop_rounded,
        'background': const Color(0xffEAF6FF),
        'iconColor': const Color(0xff1686E8),
        'page': const WaterReminderView(),
      },
      {
        'title': context.tr('meal'),
        'value': mealReminderValue,
        'enabled': mealReminderEnabled,
        'icon': Icons.restaurant_rounded,
        'background': const Color(0xffFFF3E8),
        'iconColor': const Color(0xffFF7A00),
        'page': const MealReminderView(),
      },
      {
        'title': context.tr('sleep'),
        'value': sleepReminderValue,
        'enabled': sleepReminderEnabled,
        'icon': Icons.nightlight_round,
        'background': const Color(0xffF2ECFF),
        'iconColor': const Color(0xff6D28D9),
        'page': const SleepReminderView(),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(context.tr('todayReminders'),
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(context.tr('swipe'),
                style: TextStyle(
                  color: TColor.sceondarText,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.swipe_left_rounded,
                color: TColor.primary,
                size: 17,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Directionality(
          textDirection: ui.TextDirection.ltr,
          child: SizedBox(
            height: 126,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: reminders.length,
              separatorBuilder: (_, __) => const SizedBox(width: 9),
              itemBuilder: (context, index) {
                return _buildReminderCard(reminders[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> reminder) {
    final bool enabled = reminder['enabled'] as bool;
    final bool isSchedule = reminder['isSchedule'] == true;
    final Color iconColor = reminder['iconColor'] as Color;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () async {
        await _openReminderPage(reminder['page'] as Widget);
      },
      child: Container(
        width: 104,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
        decoration: BoxDecoration(
          color: reminder['background'] as Color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: enabled
                ? iconColor.withOpacity(0.22)
                : Colors.transparent,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0B000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.82),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    reminder['icon'] as IconData,
                    color: iconColor,
                    size: 19,
                  ),
                ),
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: isSchedule
                        ? TColor.primary
                        : enabled
                        ? Colors.green
                        : Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              reminder['title'].toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: _rf(11.5),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              reminder['value'].toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: iconColor,
                fontSize: _rf(8.8),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              isSchedule
                  ? context.tr('open')
                  : enabled
                  ? context.tr('on')
                  : context.tr('set'),
              style: TextStyle(
                color: isSchedule
                    ? TColor.primary
                    : enabled
                    ? Colors.green.shade700
                    : TColor.sceondarText,
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =====================================================
  /// MAIN PLAN CARD
  /// =====================================================

  Widget _buildMainPlanCard() {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      height: 215,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),

        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,

          colors: [
            TColor.purpleSoft,
            const Color(0xffEFE5FF),
            const Color(0xffE5D3FF),
          ],
        ),
      ),

      child: Stack(
        children: [
          /// IMAGE

          Positioned(
            right: -25,
            bottom: -10,

            child: Opacity(
              opacity: 0.85,

              child: Image.asset(
                "assets/img/11.png",
                height: 190,
                width: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// TEXT

          Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(context.tr('myPlan'),
                    style: TextStyle(
                      fontSize: _rf(11.5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  context.tr('loseWeight'),
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                Text(
                  context.tr('in30Days'),
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const Spacer(),

                Text(
                  context.tr('healthyJourney'),
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: _rf(11.5),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          /// ADJUST PLAN

          Positioned(
            right: 12,
            top: 12,

            child: InkWell(
              onTap: () {
                /// Later Adjust Plan Page
              },

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),

                child: Row(
                  children: [
                    Text(
                      context.tr('adjustPlan'),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: _rf(10.5),
                      ),
                    ),

                    const SizedBox(width: 6),

                    Icon(
                      Icons.tune,
                      size: 17,
                      color: TColor.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =====================================================
  /// DAY LIST
  /// =====================================================
  ///
  /// IMPORTANT:
  /// এই SizedBox এর height fixed।
  /// তাই 30টা Day পুরো page লম্বা করবে না।
  /// এই box-এর ভেতরেই Day 1 - Day 30 scroll করবে।
  /// =====================================================

  Widget _buildDayList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dayList.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> item = dayList[index];
        final bool active = index == selectedDay;

        return _buildDayCard(
          item: item,
          index: index,
          active: active,
        );
      },
    );
  }

  /// =====================================================
  /// DAY CARD
  /// =====================================================
  Widget _buildDayCard({
    required Map<String, dynamic> item,
    required int index,
    required bool active,
  }) {
    final int dayNumber = index + 1;
    final String imagePath = item["image"].toString();

    final bool isPic2 = imagePath.contains("pic2");
    final bool isPic3 = imagePath.contains("pic3");

    final double cardHeight = active ? 195 : 150;
    final double timelineHeight = active ? 207 : 162;

    double imageWidth = active ? 145 : 110;
    double imageHeight = active ? 220 : 145;
    double imageRight = active ? -10 : 2;
    double? imageTop = active ? -15 : -8;
    double? imageBottom;
    double textRightPadding = active ? 118 : 88;

    if (isPic2) {
      imageWidth = active ? 205 : 145;
      imageHeight = active ? 145 : 100;
      imageRight = active ? -12 : -5;
      imageTop = null;
      imageBottom = active ? 22 : 16;
      textRightPadding = active ? 142 : 104;
    }

    if (isPic3) {
      imageWidth = active ? 205 : 145;
      imageHeight = active ? 250 : 168;
      imageRight = active ? -24 : -8;
      imageTop = active ? -45 : -8;
      imageBottom = null;
      textRightPadding = active ? 136 : 100;
    }

    return FutureBuilder<WorkoutProgress>(
      future: WorkoutProgressService.getProgress(dayNumber),
      builder: (context, snapshot) {
        final WorkoutProgress progress =
            snapshot.data ??
                const WorkoutProgress(
                  started: false,
                  completed: false,
                  currentExerciseIndex: 0,
                  totalExercises: 0,
                );

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 36,
                height: timelineHeight,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDay = index;
                        });
                      },
                      child: Container(
                        width: 22,
                        height: 22,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            width: 2,
                            color: active
                                ? TColor.primary
                                : const Color(0xffD8D2E4),
                          ),
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: active
                                ? TColor.primary
                                : Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                    if (index != dayList.length - 1)
                      Expanded(
                        child: Container(
                          width: 1.5,
                          color: const Color(0xffDDD8E5),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: cardHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () {
                            setState(() {
                              selectedDay = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: active
                                  ? const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xff4B0FA8),
                                  Color(0xff742BE6),
                                  Color(0xff9A49F2),
                                ],
                              )
                                  : const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xffF4EDFF),
                                  Color(0xffFBF9FF),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: active
                                      ? const Color(0xff5D20C8).withOpacity(0.22)
                                      : Colors.black.withOpacity(0.05),
                                  blurRadius: active ? 16 : 8,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                if (active)
                                  Positioned(
                                    right: -28,
                                    bottom: -48,
                                    child: Container(
                                      width: 178,
                                      height: 178,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.06),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.08),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (active)
                                  Positioned(
                                    right: 10,
                                    top: 35,
                                    child: SizedBox(
                                      width: 76,
                                      height: 82,
                                      child: CustomPaint(
                                        painter: _WorkoutDotsPainter(
                                          color: Colors.white.withOpacity(0.10),
                                        ),
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  right: isPic2
                                      ? (active ? 20 : 14)
                                      : isPic3
                                      ? (active ? 18 : 12)
                                      : (active ? 10 : 8),
                                  bottom: isPic2
                                      ? (active ? 17 : 11)
                                      : (active ? 4 : 3),
                                  child: Container(
                                    width: isPic2
                                        ? (active ? 100 : 72)
                                        : isPic3
                                        ? (active ? 88 : 65)
                                        : (active ? 92 : 68),
                                    height: active ? 13 : 9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.black.withOpacity(
                                        active ? 0.18 : 0.08,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                            active ? 0.20 : 0.08,
                                          ),
                                          blurRadius: active ? 14 : 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    16,
                                    active ? 16 : 12,
                                    textRightPadding,
                                    active ? 66 : 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${context.tr('day')} ${index + 1}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: active ? Colors.white : TColor.primaryText,
                                          fontSize: active ? 23 : 18.5,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '5 ${context.tr('minuteShort')}  •  '
                                            '${(68.1 + index).toStringAsFixed(1)} '
                                            '${context.tr('kcal')}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: active
                                              ? Colors.white.withOpacity(0.86)
                                              : TColor.primaryText,
                                          fontSize: active ? 11.5 : 10.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (progress.started) ...[
                                        const SizedBox(height: 7),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                progress.completed
                                                    ? context.tr('workoutCompleted')
                                                    : progress.progressText,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: active
                                                      ? Colors.white.withOpacity(0.78)
                                                      : TColor.sceondarText,
                                                  fontSize: _rf(8.8),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${(progress.progress * 100).round()}%',
                                              style: TextStyle(
                                                color: progress.completed
                                                    ? const Color(0xff63F96D)
                                                    : active
                                                    ? const Color(0xff73F27A)
                                                    : TColor.primary,
                                                fontSize: _rf(8.8),
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: LinearProgressIndicator(
                                            value: progress.progress,
                                            minHeight: 4,
                                            backgroundColor: active
                                                ? Colors.white.withOpacity(0.22)
                                                : TColor.primaryLight,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              progress.completed
                                                  ? const Color(0xff55ED63)
                                                  : active
                                                  ? const Color(0xff74F37A)
                                                  : TColor.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                if (active)
                                  Positioned(
                                    left: 16,
                                    bottom: 14,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(28),
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => WorkoutDayView(
                                              dayNumber: index + 1,
                                            ),
                                          ),
                                        );
                                        if (!mounted) return;
                                        await _loadWorkoutStats();
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: isPic2 ? 142 : 150,
                                        height: 42,
                                        padding: const EdgeInsets.only(left: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(28),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.10),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                progress.completed
                                                    ? context.tr('repeat')
                                                    : progress.started
                                                    ? context.tr('continueUpper')
                                                    : context.tr('startUpper'),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style:  TextStyle(
                                                  color: Colors.black,
                                                  fontSize: _rf(11.5),
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(4),
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: TColor.primary,
                                              ),
                                              child: SlideTransition(
                                                position: _arrowAnimation,
                                                child: const Icon(
                                                  Icons.arrow_forward_ios_rounded,
                                                  color: Colors.white,
                                                  size: 13,
                                                ),
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
                        ),
                      ),
                      Positioned(
                        right: imageRight,
                        top: imageTop,
                        bottom: imageBottom,
                        child: IgnorePointer(
                          child: Image.asset(
                            imagePath,
                            width: imageWidth,
                            height: imageHeight,
                            fit: BoxFit.contain,
                            alignment: Alignment.bottomCenter,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (_, __, ___) {
                              return Icon(
                                Icons.fitness_center_rounded,
                                color: active ? Colors.white70 : TColor.primary,
                                size: 50,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// =====================================================
  /// BOTTOM NAVIGATION
  /// =====================================================

  Widget _buildBottomBar() {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x16000000),
              blurRadius: 16,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Directionality(
          textDirection: ui.TextDirection.ltr,
          child: Row(
            children: [
              _bottomItem(
                Icons.home_rounded,
                context.tr('home'),
                true,
                    () {},
              ),
              _bottomItem(
                Icons.assignment_rounded,
                context.tr('plan'),
                false,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PlanView(),
                    ),
                  );
                },
              ),
              _bottomItem(
                Icons.bar_chart_rounded,
                context.tr('reports'),
                false,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReportsView(),
                    ),
                  );
                },
              ),
              _bottomItem(
                Icons.person_outline_rounded,
                context.tr('me'),
                false,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MeView(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// =====================================================
  /// BOTTOM NAV ITEM
  /// =====================================================

  Widget _bottomItem(
      IconData icon,
      String title,
      bool active,
      VoidCallback onTap,
      ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: active
                    ? TColor.primary
                    : Colors.black,
                size: 23,
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  color: active
                      ? TColor.primary
                      : Colors.black,
                  fontSize: 10.5,
                  fontWeight: active
                      ? FontWeight.w800
                      : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              SizedBox(
                height: 3,
                child: active
                    ? Container(
                  width: 24,
                  decoration: BoxDecoration(
                    color: TColor.primary,
                    borderRadius:
                    BorderRadius.circular(5),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _arrowController.dispose();
    _borderController.dispose();
    super.dispose();
  }
} // <-- Class শেষ



class _WorkoutDotsPainter extends CustomPainter {
  const _WorkoutDotsPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    const double gap = 10;
    const double radius = 1.6;

    for (double y = 0; y <= size.height; y += gap) {
      for (double x = 0; x <= size.width; x += gap) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WorkoutDotsPainter oldDelegate) {
    return oldDelegate.color != color;
  }


}

