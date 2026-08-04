import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/color_extention.dart';
import '../reminder/meal_reminder_view.dart';

import '../../l10n/app_localizations.dart';
class MealPlanView extends StatefulWidget {
  const MealPlanView({super.key});

  @override
  State<MealPlanView> createState() => _MealPlanViewState();
}

class _MealPlanViewState extends State<MealPlanView> {
  DateTime selectedDate = DateTime.now();
  bool isLoading = true;

  final List<Map<String, dynamic>> mealList = [
    {
      "typeKey": "breakfast",
      "titleKey": "oatsBananaEggs",
      "time": "8:00 AM",
      "image": "assets/img/breakfast1.png",
      "calories": 420,
      "protein": 24,
      "carbs": 52,
      "fat": 14,
    },
    {
      "typeKey": "morningSnack",
      "titleKey": "appleGreekYogurt",
      "time": "11:00 AM",
      "image": "assets/img/breakfast2.png",
      "calories": 210,
      "protein": 12,
      "carbs": 30,
      "fat": 5,
    },
    {
      "typeKey": "lunch",
      "titleKey": "chickenRiceSalad",
      "time": "2:00 PM",
      "image": "assets/img/breakfast1.png",
      "calories": 560,
      "protein": 42,
      "carbs": 65,
      "fat": 15,
    },
    {
      "typeKey": "dinner",
      "titleKey": "fishVegetablesSoup",
      "time": "8:00 PM",
      "image": "assets/img/breakfast2.png",
      "calories": 430,
      "protein": 36,
      "carbs": 38,
      "fat": 16,
    },
  ];

  final Set<int> completedMeals = <int>{};

  @override
  void initState() {
    super.initState();
    _loadCompletedMeals();
  }

  String _dateKey(DateTime date) {
    return "${date.year}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  String _mealCompletedKey(DateTime date) {
    return "meal_plan_completed_${_dateKey(date)}";
  }

  Future<void> _loadCompletedMeals() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    final List<String> saved =
        prefs.getStringList(
          _mealCompletedKey(selectedDate),
        ) ??
            [];

    if (!mounted) return;

    setState(() {
      completedMeals
        ..clear()
        ..addAll(
          saved
              .map(int.tryParse)
              .whereType<int>(),
        );
      isLoading = false;
    });
  }

  Future<void> _saveCompletedMeals() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setStringList(
      _mealCompletedKey(selectedDate),
      completedMeals
          .map((index) => index.toString())
          .toList(),
    );
  }

  Future<void> _toggleMeal(int index) async {
    setState(() {
      if (completedMeals.contains(index)) {
        completedMeals.remove(index);
      } else {
        completedMeals.add(index);
      }
    });

    await _saveCompletedMeals();

    if (!mounted) return;

    if (completedMeals.length == mealList.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr('todayMealPlanComplete'),
          ),
        ),
      );
    }
  }

  Future<void> _changeDate(int days) async {
    setState(() {
      selectedDate = selectedDate.add(
        Duration(days: days),
      );
      isLoading = true;
    });

    await _loadCompletedMeals();
  }

  int get totalCalories {
    return mealList.fold<int>(
      0,
          (sum, item) =>
      sum + (item["calories"] as int),
    );
  }

  int get totalProtein {
    return mealList.fold<int>(
      0,
          (sum, item) =>
      sum + (item["protein"] as int),
    );
  }

  int get totalCarbs {
    return mealList.fold<int>(
      0,
          (sum, item) =>
      sum + (item["carbs"] as int),
    );
  }

  int get totalFat {
    return mealList.fold<int>(
      0,
          (sum, item) => sum + (item["fat"] as int),
    );
  }

  int get consumedCalories {
    int total = 0;

    for (final int index in completedMeals) {
      if (index >= 0 && index < mealList.length) {
        total += mealList[index]["calories"] as int;
      }
    }

    return total;
  }

  double get mealProgress {
    if (mealList.isEmpty) return 0;

    return (completedMeals.length / mealList.length)
        .clamp(0.0, 1.0);
  }

  String _formattedDate() {
    const List<String> weekdayKeys = [
      "monday",
      "tuesday",
      "wednesday",
      "thursday",
      "friday",
      "saturday",
      "sunday",
    ];

    const List<String> monthKeys = [
      "januaryShort",
      "februaryShort",
      "marchShort",
      "aprilShort",
      "mayShort",
      "juneShort",
      "julyShort",
      "augustShort",
      "septemberShort",
      "octoberShort",
      "novemberShort",
      "decemberShort",
    ];

    return "${context.tr(weekdayKeys[selectedDate.weekday - 1])}, "
        "${context.tr(monthKeys[selectedDate.month - 1])} "
        "${selectedDate.day}";
  }

  bool get isToday {
    final DateTime now = DateTime.now();

    return now.year == selectedDate.year &&
        now.month == selectedDate.month &&
        now.day == selectedDate.day;
  }

  void _showMealDetails(
      Map<String, dynamic> meal,
      int index,
      ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final bool completed =
        completedMeals.contains(index);

        return Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            30,
          ),
          decoration: const BoxDecoration(
            color: Color(0xffF7F3FD),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(22),
                  child: Image.asset(
                    meal["image"].toString(),
                    width: double.infinity,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  context.tr(meal['typeKey'].toString()),
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  context.tr(meal['titleKey'].toString()),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${context.tr('recommendedTime')}: ${meal["time"]}",
                  style: TextStyle(
                    color: TColor.sceondarText,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _detailNutritionItem(
                        title: context.tr('calories'),
                        value:
                        "${meal["calories"]} kcal",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _detailNutritionItem(
                        title: context.tr('protein'),
                        value: "${meal["protein"]} g",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _detailNutritionItem(
                        title: context.tr('carbs'),
                        value: "${meal["carbs"]} g",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _detailNutritionItem(
                        title: context.tr('fat'),
                        value: "${meal["fat"]} g",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(sheetContext);
                      await _toggleMeal(index);
                    },
                    icon: Icon(
                      completed
                          ? Icons.undo_rounded
                          : Icons.check_rounded,
                    ),
                    label: Text(
                      completed
                          ? context.tr('markAsNotEaten')
                          : context.tr('markAsEaten'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: completed
                          ? Colors.orange
                          : TColor.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailNutritionItem({
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 13,
        horizontal: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            maxLines: 1,
            style: TextStyle(
              color: TColor.sceondarText,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3FD),
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F3FD),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
        ),
        title: Text(
          context.tr('mealPlan'),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: context.tr('mealReminders'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MealReminderView(),
                ),
              );
            },
            icon: Icon(
              Icons.notifications_active_rounded,
              color: TColor.primary,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: TColor.primary,
        ),
      )
          : RefreshIndicator(
        color: TColor.primary,
        onRefresh: _loadCompletedMeals,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            35,
          ),
          children: [
            _buildHeader(),
            const SizedBox(height: 18),
            _buildDateSelector(),
            const SizedBox(height: 20),
            _buildNutritionSummary(),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: Text(context.tr('todayMeals'),
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  "${completedMeals.length}/${mealList.length} ${context.tr('completed')}",
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            ...List.generate(
              mealList.length,
                  (index) => _buildMealCard(
                mealList[index],
                index,
              ),
            ),
            const SizedBox(height: 12),
            _buildReminderCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColor.primary,
            const Color(0xff8748E8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('healthyDailyPlan'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      context.tr('balancedMealsWeightLoss'),
                      style: TextStyle(
                        color:
                        Colors.white.withOpacity(0.86),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color:
                  Colors.white.withOpacity(0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: mealProgress,
              minHeight: 9,
              backgroundColor: Colors.white24,
              valueColor:
              const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            completedMeals.length == mealList.length
                ? context.tr('allMealsCompletedToday')
                : "${mealList.length - completedMeals.length} ${context.tr('mealsRemaining')}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _changeDate(-1);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: TColor.primary,
              size: 19,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  _formattedDate(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (isToday)
                  Text(
                    context.tr('today'),
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _changeDate(1);
            },
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: TColor.primary,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSummary() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _nutritionCard(
                icon:
                Icons.local_fire_department_rounded,
                title: context.tr('calories'),
                value: "$totalCalories",
                suffix: "kcal",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _nutritionCard(
                icon: Icons.fitness_center_rounded,
                title: context.tr('protein'),
                value: "$totalProtein",
                suffix: "g",
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _nutritionCard(
                icon: Icons.grain_rounded,
                title: context.tr('carbs'),
                value: "$totalCarbs",
                suffix: "g",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _nutritionCard(
                icon: Icons.opacity_rounded,
                title: context.tr('fat'),
                value: "$totalFat",
                suffix: "g",
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(19),
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: TColor.primaryLight,
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.pie_chart_rounded,
                  color: TColor.primary,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('consumedCalories'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "$consumedCalories / $totalCalories kcal",
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${(mealProgress * 100).round()}%",
                style: TextStyle(
                  color: TColor.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _nutritionCard({
    required IconData icon,
    required String title,
    required String value,
    required String suffix,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 41,
            height: 41,
            decoration: BoxDecoration(
              color: TColor.primaryLight,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: TColor.primary,
              size: 21,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  "$value $suffix",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  style: TextStyle(
                    color: TColor.sceondarText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(
      Map<String, dynamic> meal,
      int index,
      ) {
    final bool completed =
    completedMeals.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: completed
              ? Colors.green.withOpacity(0.45)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          _showMealDetails(meal, index);
        },
        child: Row(
          children: [
            Stack(
              children: [
                Image.asset(
                  meal["image"].toString(),
                  width: 115,
                  height: 135,
                  fit: BoxFit.cover,
                ),
                if (completed)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black26,
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  15,
                  14,
                  12,
                  14,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.tr(meal['typeKey'].toString()),
                            style: TextStyle(
                              color: TColor.primary,
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          meal["time"].toString(),
                          style: TextStyle(
                            color: TColor.sceondarText,
                            fontSize: 11,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.tr(meal['titleKey'].toString()),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      "${meal["calories"]} kcal • "
                          "${meal["protein"]}g ${context.tr('protein').toLowerCase()}",
                      style: TextStyle(
                        color: TColor.sceondarText,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            completed
                                ? context.tr('completed')
                                : context.tr('tapToViewDetails'),
                            style: TextStyle(
                              color: completed
                                  ? Colors.green
                                  : TColor.primary,
                              fontSize: 11,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: completed
                              ? context.tr('markAsNotEaten')
                              : context.tr('markAsEaten'),
                          onPressed: () {
                            _toggleMeal(index);
                          },
                          icon: Icon(
                            completed
                                ? Icons.check_circle_rounded
                                : Icons
                                .radio_button_unchecked_rounded,
                            color: completed
                                ? Colors.green
                                : TColor.primary,
                          ),
                        ),
                      ],
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

  Widget _buildReminderCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MealReminderView(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 49,
              height: 49,
              decoration: BoxDecoration(
                color: TColor.primaryLight,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.notifications_active_rounded,
                color: TColor.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('mealReminder'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.tr('openScheduleReminders'),
                    style: TextStyle(
                      color: TColor.sceondarText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: TColor.primary,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}
