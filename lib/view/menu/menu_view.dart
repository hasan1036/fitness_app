import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../reports/reports_view.dart';
import '../../service/profile_service.dart';
import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../data/workout_day_view.dart';
import '../../service/workout_progress_service.dart';
import '../../service/workout_stats_service.dart';

import '../exercise/exercise_view_2.dart';
import '../home/home_view.dart';
import '../meal_plan/mean_plan_view.dart';
import '../running/running_view.dart';
import '../schedule/schedule_view.dart';
import '../weight/weight_view.dart';
import '../../common_widget/app_drawer.dart';
import '../workout/workout_view.dart';



class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();

  String get greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning 👋";
    } else if (hour < 17) {
      return "Good Afternoon ☀️";
    } else if (hour < 21) {
      return "Good Evening 🌇";
    } else {
      return "Good Night 🌙";
    }
  }
  String get currentDate {
    final now = DateTime.now();

    const weekdays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return "${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}";
  }
  final ImagePicker _imagePicker = ImagePicker();

  String profileName = "Code For Jannat";
  String? profileImagePath;
  /// বর্তমানে কোন Day selected
  int selectedDay = 0;

  int totalWorkouts = 0;
  double totalCalories = 0;
  int currentStreak = 0;

  /// =====================================================
  /// QUICK ACCESS
  /// =====================================================

  final List<Map<String, dynamic>> quickAccessList = [
    {
      "title": "Weight",
      "icon": "assets/img/scale.png",
      "type": "weight",
    },
    {
      "title": "Training Plan",
      "icon": "assets/img/clipboard.png",
      "type": "training",
    },
    {
      "title": "Meal Plan",
      "icon": "assets/img/spoon.png",
      "type": "meal",
    },
    {
      "title": "Schedule",
      "icon": "assets/img/calendar.png",
      "type": "schedule",
    },
    {
      "title": "Running",
      "icon": "assets/img/run.png",
      "type": "running",
    },
    {
      "title": "Exercise",
      "icon": "assets/img/work.png",
      "type": "exercise",
    },
    {
      "title": "Training Status",
      "icon": "assets/img/signal.png",
      "type": "status",
    },
    {
      "title": "Tips",
      "icon": "assets/img/light.png",
      "type": "tips",
    },
  ];

  /// =====================================================
  /// 30 WORKOUT DAYS
  /// =====================================================

  late final List<Map<String, dynamic>> dayList;


  @override
  void initState() {
    super.initState();

    dayList = List.generate(30, (index) {
      final int day = index + 1;

      return {
        "day": "Day $day",
        "time": "5 min",
        "calorie": "${(68.1 + index).toStringAsFixed(1)} kcal",
        "image": index % 3 == 0
            ? "assets/img/2.png"
            : index % 3 == 1
            ? "assets/img/3.png"
            : "assets/img/4.png",
      };
    });

    _loadWorkoutStats();
    _loadProfile();
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
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (file == null) return;

    await ProfileService.saveImagePath(file.path);

    if (!mounted) return;

    setState(() {
      profileImagePath = file.path;
    });
  }

  Future<void> _changeName() async {
    final TextEditingController controller =
    TextEditingController(
      text: profileName,
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Change Name"),

          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Enter your name",
              border: OutlineInputBorder(),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                final String name =
                controller.text.trim();

                if (name.isEmpty) return;

                await ProfileService.saveName(name);

                if (!mounted) return;

                setState(() {
                  profileName = name;
                });

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );

    controller.dispose();
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
                    const SizedBox(height: 25),

                    /// =================================================
                    /// MY PLAN TITLE
                    /// =================================================

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            "My Plan",
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomeView(),
                                ),
                              );
                            },

                            child: Text(
                              "View all",
                              style: TextStyle(
                                color: TColor.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// =================================================
                    /// 30 DAYS MAIN PLAN CARD
                    /// =================================================

                    _buildMainPlanCard(),

                    const SizedBox(height: 27),

                    /// =================================================
                    /// STAGE TITLE
                    /// =================================================

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                      child: Row(
                        children: [
                          Text(
                            "Stage 1",
                            style: TextStyle(
                              fontSize: 23,
                              color: TColor.primaryText,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Text(
                            "Start Strong",
                            style: TextStyle(
                              fontSize: 16,
                              color: TColor.primary,
                              fontWeight: FontWeight.w600,
                            ),
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
                              builder: (_) => const HomeView(),
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
                                  child: Text(
                                    "Full 30 Days Plan",
                                    style: TextStyle(
                                      fontSize: 17,
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
                    /// QUICK ACCESS TITLE
                    /// =================================================

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            "Quick Access",
                            style: TextStyle(
                              fontSize: 23,
                              color: TColor.primaryText,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          Text(
                            "See all",
                            style: TextStyle(
                              fontSize: 14,
                              color: TColor.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// =================================================
                    /// QUICK ACCESS GRID
                    /// =================================================

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                      child: GridView.builder(
                        shrinkWrap: true,

                        physics:
                        const NeverScrollableScrollPhysics(),

                        itemCount: quickAccessList.length,

                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.88,
                        ),

                        itemBuilder: (context, index) {
                          final item = quickAccessList[index];

                          return _buildQuickAccessCard(item);
                        },
                      ),
                    ),

                    const SizedBox(height: 25),

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
      height: 300,

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
          padding: const EdgeInsets.fromLTRB(
            22,
            18,
            22,
            22,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// MENU + NOTIFICATION

              Row(
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
                        onPressed: () {},

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
                        radius: 37,
                        backgroundColor: Colors.white,
                        backgroundImage: profileImagePath != null
                            ? FileImage(File(profileImagePath!))
                            : const AssetImage("assets/img/u1.png")
                        as ImageProvider,
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        Text(
                          greeting,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          currentDate,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        GestureDetector(
                          onTap: _changeName,
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  profileName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
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

                        const SizedBox(height: 9),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 7,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.13),
                            borderRadius:
                            BorderRadius.circular(20),
                          ),

                          child: const Text(
                            "Keep pushing, you're doing great!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// =================================================
              /// STATS
              /// =================================================

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.fitness_center_rounded,
                      title: "Workouts",
                      value: totalWorkouts.toString(),
                      bottom: "This Week",
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.local_fire_department,
                      title: "Calories",
                      value: totalCalories.toStringAsFixed(0),
                      bottom: "Burned",
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.bolt_rounded,
                      title: "Streak",
                      value: currentStreak.toString(),
                      bottom: "Days",
                    ),
                  ),
                ],
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
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
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
            width: 33,
            height: 33,

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TColor.primary.withOpacity(0.55),
            ),

            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),

                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                Text(
                  bottom,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
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

                  child: const Text(
                    "My Plan",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "LOSE WEIGHT",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                Text(
                  "IN 30 DAYS",
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const Spacer(),

                Text(
                  "Your journey to a better\nand healthier you.",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 13,
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
                    const Text(
                      "Adjust Plan",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
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
    return SizedBox(
      /// প্রয়োজন হলে 500 কম/বেশি করতে পারো
      height: 500,

      child: ListView.builder(
        padding: EdgeInsets.zero,

        /// Day section আলাদাভাবে scroll করবে
        physics: const BouncingScrollPhysics(),

        /// এখানে 30টি item আছে
        itemCount: dayList.length,

        itemBuilder: (context, index) {
          final item = dayList[index];

          final bool active =
              index == selectedDay;

          return _buildDayCard(
            item: item,
            index: index,
            active: active,
          );
        },
      ),
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
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        15,
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// =================================================
          /// LEFT TIMELINE
          /// =================================================

          SizedBox(
            width: 45,
            height: active ? 205 : 145,

            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = index;
                    });
                  },

                  child: Container(
                    width: 27,
                    height: 27,

                    padding: const EdgeInsets.all(4),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      border: Border.all(
                        width: 2,

                        color: active
                            ? TColor.primary
                            : Colors.black12,
                      ),
                    ),

                    child: Container(
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


          /// =================================================
          /// DAY CARD
          /// =================================================

          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(22),

              onTap: () {
                setState(() {
                  selectedDay = index;
                });
              },

              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 250,
                ),

                height: active ? 190 : 130,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),

                  gradient: active
                      ? LinearGradient(
                    colors: [
                      TColor.primary,
                      const Color(0xff8748E8),
                    ],
                  )
                      : LinearGradient(
                    colors: [
                      TColor.purpleSoft,
                      const Color(0xffFBF9FF),
                    ],
                  ),
                ),

                child: Stack(
                  children: [
                    /// PERSON IMAGE

                    Positioned(
                      right: 0,
                      bottom: 0,

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),

                        child: Image.asset(
                          item["image"],

                          width: active ? 155 : 125,
                          height: active ? 175 : 125,

                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    /// DAY INFORMATION

                    Padding(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [
                          Text(
                            item["day"],

                            style: TextStyle(
                              color: active
                                  ? Colors.white
                                  : TColor.primaryText,

                              fontSize: active ? 25 : 23,

                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "${item["time"]} • ${item["calorie"]}",



                            style: TextStyle(
                              color: active
                                  ? Colors.white
                                  : TColor.primaryText,

                              fontSize: 14,
                            ),
                          ),
                          if (progress.started) ...[
                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    progress.completed
                                        ? "Workout completed"
                                        : progress.progressText,
                                    style: TextStyle(
                                      color: active
                                          ? Colors.white70
                                          : TColor.primaryText,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                Text(
                                  "${(progress.progress * 100).round()}%",
                                  style: TextStyle(
                                    color: progress.completed
                                        ? Colors.green
                                        : active
                                        ? Colors.white
                                        : TColor.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 7),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),

                              child: LinearProgressIndicator(
                                value: progress.progress,
                                minHeight: 6,

                                backgroundColor: active
                                    ? Colors.white24
                                    : TColor.primaryLight,

                                valueColor: AlwaysStoppedAnimation<Color>(
                                  progress.completed
                                      ? Colors.green
                                      : active
                                      ? Colors.white
                                      : TColor.primary,
                                ),
                              ),
                            ),
                          ],
                          /// START button শুধু selected Day-তে থাকবে

                          if (active) ...[
                            const Spacer(),

                            InkWell(
                              borderRadius:
                              BorderRadius.circular(30),
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
                                width: 185,
                                height: 48,

                                decoration: BoxDecoration(
                                  color: Colors.white,

                                  borderRadius:
                                  BorderRadius.circular(30),
                                ),

                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,

                                  children: [
                                     Expanded(
                                      child: Center(
                                        child:  Text(
                                          progress.completed
                                              ? "REPEAT"
                                              : progress.started
                                              ? "CONTINUE"
                                              : "START",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      margin:
                                      const EdgeInsets.only(
                                        right: 6,
                                      ),

                                      width: 35,
                                      height: 35,

                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: TColor.primary,
                                      ),

                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
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
  /// QUICK ACCESS CARD
  /// =====================================================

  Widget _buildQuickAccessCard(
      Map<String, dynamic> item,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),

      onTap: () {
        _openQuickAccess(
          item["type"].toString(),
        );
      },

      child: Container(
        padding: const EdgeInsets.all(9),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(16),

          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: Transform.scale(
                scale: 1.15,
                child: Image.asset(
                  item["icon"],
                  fit: BoxFit.contain,
                  color: TColor.primary,
                ),
              ),
            ),

            const SizedBox(height: 7),

            Text(
              item["title"],

              textAlign: TextAlign.center,

              maxLines: 2,

              style: TextStyle(
                fontSize: 11,
                color: TColor.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =====================================================
  /// QUICK ACCESS NAVIGATION
  /// =====================================================

  void _openQuickAccess(String type) {
    Widget? page;

    switch (type) {
      case "weight":
        page = const WeightView();
        break;

      case "training":
        page = const HomeView();
        break;

      case "meal":
        page = const MealPlanView();
        break;

      case "schedule":
        page = const ScheduleView();
        break;

      case "running":
        page = const RunningView();
        break;

      case "exercise":
        page = const ExerciseView2View2();
        break;

      case "status":
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Training Status screen coming next",
            ),
          ),
        );
        return;

      case "tips":
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Tips screen coming next",
            ),
          ),
        );
        return;
    }

    if (page != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => page!,
        ),
      );
    }
  }

  /// =====================================================
  /// BOTTOM NAVIGATION
  /// =====================================================

  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      height: 78,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(25),

        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          _bottomItem(
            Icons.home_rounded,
            "Home",
            true,
                () {},
          ),

          _bottomItem(
            Icons.assignment_outlined,
            "Plan",
            false,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomeView(),
                ),
              );
            },
          ),

          _bottomItem(
            Icons.bar_chart_rounded,
            "Reports",
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
            "Me",
            false,
                () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Profile screen coming next",
                  ),
                ),
              );
            },
          ),
        ],
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
    return InkWell(
      onTap: onTap,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(
            icon,

            color: active
                ? TColor.primary
                : Colors.black,

            size: 26,
          ),

          const SizedBox(height: 4),

          Text(
            title,

            style: TextStyle(
              color: active
                  ? TColor.primary
                  : Colors.black,

              fontSize: 12,

              fontWeight: active
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          if (active)
            Container(
              width: 25,
              height: 3,

              decoration: BoxDecoration(
                color: TColor.primary,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
        ],
      ),
    );
  }
}