import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/color_extention.dart';
import '../../l10n/app_localizations.dart';
import '../../service/notification_service.dart';

class MealReminderView extends StatefulWidget {
  const MealReminderView({super.key});

  @override
  State<MealReminderView> createState() =>
      _MealReminderViewState();
}

class _MealReminderViewState
    extends State<MealReminderView> {
  static const String _enabledKey =
      'meal_reminder_enabled';
  static const String _daysKey =
      'meal_reminder_days';

  bool reminderEnabled = false;
  bool isLoading = true;
  bool isSaving = false;

  TimeOfDay breakfastTime =
  const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay snackTime =
  const TimeOfDay(hour: 11, minute: 0);
  TimeOfDay lunchTime =
  const TimeOfDay(hour: 14, minute: 0);
  TimeOfDay dinnerTime =
  const TimeOfDay(hour: 20, minute: 0);

  final List<String> dayKeys = const [
    'mondayShort',
    'tuesdayShort',
    'wednesdayShort',
    'thursdayShort',
    'fridayShort',
    'saturdayShort',
    'sundayShort',
  ];

  List<bool> selectedDays =
  List<bool>.filled(7, true);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    final List<String> savedDays =
        prefs.getStringList(_daysKey) ?? [];

    if (!mounted) return;

    setState(() {
      reminderEnabled =
          prefs.getBool(_enabledKey) ?? false;

      breakfastTime =
          _readTime(prefs, 'breakfast', 8, 0);
      snackTime =
          _readTime(prefs, 'snack', 11, 0);
      lunchTime =
          _readTime(prefs, 'lunch', 14, 0);
      dinnerTime =
          _readTime(prefs, 'dinner', 20, 0);

      if (savedDays.isNotEmpty) {
        selectedDays = List<bool>.generate(
          7,
              (index) =>
              savedDays.contains(index.toString()),
        );
      }

      isLoading = false;
    });
  }

  TimeOfDay _readTime(
      SharedPreferences prefs,
      String name,
      int defaultHour,
      int defaultMinute,
      ) {
    return TimeOfDay(
      hour: prefs.getInt(
        'meal_${name}_hour',
      ) ??
          defaultHour,
      minute: prefs.getInt(
        'meal_${name}_minute',
      ) ??
          defaultMinute,
    );
  }

  Future<TimeOfDay?> _pickTime(
      TimeOfDay initialTime,
      ) {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
    );
  }

  Future<void> _saveSettings() async {
    if (reminderEnabled &&
        !selectedDays.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr('selectAtLeastOneDay'),
          ),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final List<int> selectedDayIndexes = [];
      final List<String> selectedDayStrings = [];

      for (int i = 0;
      i < selectedDays.length;
      i++) {
        if (selectedDays[i]) {
          selectedDayIndexes.add(i);
          selectedDayStrings.add(i.toString());
        }
      }

      await prefs.setBool(
        _enabledKey,
        reminderEnabled,
      );

      await prefs.setStringList(
        _daysKey,
        selectedDayStrings,
      );

      await _saveTime(
        prefs,
        'breakfast',
        breakfastTime,
      );

      await _saveTime(
        prefs,
        'snack',
        snackTime,
      );

      await _saveTime(
        prefs,
        'lunch',
        lunchTime,
      );

      await _saveTime(
        prefs,
        'dinner',
        dinnerTime,
      );

      if (reminderEnabled) {
        await NotificationService
            .scheduleMealReminders(
          breakfastHour: breakfastTime.hour,
          breakfastMinute:
          breakfastTime.minute,
          snackHour: snackTime.hour,
          snackMinute: snackTime.minute,
          lunchHour: lunchTime.hour,
          lunchMinute: lunchTime.minute,
          dinnerHour: dinnerTime.hour,
          dinnerMinute: dinnerTime.minute,
          selectedDayIndexes:
          selectedDayIndexes,
        );
      } else {
        await NotificationService
            .cancelMealReminders();
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            reminderEnabled
                ? context.tr(
              'mealRemindersScheduled',
            )
                : context.tr(
              'mealRemindersTurnedOff',
            ),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.tr('couldNotSaveMealReminders')}: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> _saveTime(
      SharedPreferences prefs,
      String name,
      TimeOfDay time,
      ) async {
    await prefs.setInt(
      'meal_${name}_hour',
      time.hour,
    );

    await prefs.setInt(
      'meal_${name}_minute',
      time.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xffF7F3FD),
      appBar: AppBar(
        backgroundColor:
        const Color(0xffF7F3FD),
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
          context.tr('mealReminder'),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: TColor.primary,
        ),
      )
          : ListView(
        padding:
        const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          _settingCard(
            child: SwitchListTile(
              contentPadding:
              EdgeInsets.zero,
              value: reminderEnabled,
              activeColor:
              TColor.primary,
              title: Text(
                context.tr(
                  'enableMealReminders',
                ),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
              subtitle: Text(
                reminderEnabled
                    ? context.tr(
                  'mealRemindersActive',
                )
                    : context.tr(
                  'mealRemindersOff',
                ),
                style: TextStyle(
                  color:
                  TColor.sceondarText,
                ),
              ),
              secondary: Icon(
                Icons
                    .notifications_active_rounded,
                color: reminderEnabled
                    ? TColor.primary
                    : Colors.grey,
              ),
              onChanged: (value) {
                setState(() {
                  reminderEnabled =
                      value;
                });
              },
            ),
          ),
          const SizedBox(height: 22),
          Text(
            context.tr('mealTimes'),
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight:
              FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          _timeTile(
            icon:
            Icons.free_breakfast_rounded,
            title:
            context.tr('breakfast'),
            time: breakfastTime,
            onTap: () async {
              final TimeOfDay? result =
              await _pickTime(
                breakfastTime,
              );

              if (result != null &&
                  mounted) {
                setState(() {
                  breakfastTime = result;
                });
              }
            },
          ),
          _timeTile(
            icon: Icons.apple_rounded,
            title: context.tr('snack'),
            time: snackTime,
            onTap: () async {
              final TimeOfDay? result =
              await _pickTime(
                snackTime,
              );

              if (result != null &&
                  mounted) {
                setState(() {
                  snackTime = result;
                });
              }
            },
          ),
          _timeTile(
            icon:
            Icons.lunch_dining_rounded,
            title: context.tr('lunch'),
            time: lunchTime,
            onTap: () async {
              final TimeOfDay? result =
              await _pickTime(
                lunchTime,
              );

              if (result != null &&
                  mounted) {
                setState(() {
                  lunchTime = result;
                });
              }
            },
          ),
          _timeTile(
            icon:
            Icons.dinner_dining_rounded,
            title: context.tr('dinner'),
            time: dinnerTime,
            onTap: () async {
              final TimeOfDay? result =
              await _pickTime(
                dinnerTime,
              );

              if (result != null &&
                  mounted) {
                setState(() {
                  dinnerTime = result;
                });
              }
            },
          ),
          const SizedBox(height: 18),
          Text(
            context.tr('repeatDays'),
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight:
              FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              dayKeys.length,
                  (index) {
                final bool selected =
                selectedDays[index];

                return ChoiceChip(
                  label: Text(
                    context.tr(
                      dayKeys[index],
                    ),
                  ),
                  selected: selected,
                  selectedColor:
                  TColor.primary,
                  backgroundColor:
                  Colors.white,
                  disabledColor:
                  Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: selected
                        ? Colors.white
                        : reminderEnabled
                        ? TColor
                        .primaryText
                        : Colors.grey,
                    fontWeight:
                    FontWeight.w700,
                  ),
                  onSelected:
                  reminderEnabled
                      ? (value) {
                    setState(() {
                      selectedDays[
                      index] =
                          value;
                    });
                  }
                      : null,
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 58,
            child: ElevatedButton(
              onPressed:
              isSaving
                  ? null
                  : _saveSettings,
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                TColor.primary,
                foregroundColor:
                Colors.white,
                elevation: 0,
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                ),
              ),
              child: isSaving
                  ? const SizedBox(
                width: 24,
                height: 24,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
                  : Text(
                context.tr(
                  'saveMealReminders',
                ),
                textAlign:
                TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context,
      ) {
    return Container(
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
        borderRadius:
        BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color:
              Colors.white.withOpacity(0.16),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(
                    'neverMissHealthyMeal',
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  context.tr(
                    'chooseMealTimes',
                  ),
                  style: TextStyle(
                    color:
                    Colors.white.withOpacity(
                      0.86,
                    ),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingCard({
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _timeTile({
    required IconData icon,
    required String title,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return Container(
      margin:
      const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        enabled: reminderEnabled,
        onTap:
        reminderEnabled ? onTap : null,
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 7,
        ),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: reminderEnabled
                ? TColor.primaryLight
                : Colors.grey.shade200,
            borderRadius:
            BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: reminderEnabled
                ? TColor.primary
                : Colors.grey,
          ),
        ),
        title: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: reminderEnabled
                ? TColor.primaryText
                : Colors.grey,
            fontSize: 16,
            fontWeight:
            FontWeight.w800,
          ),
        ),
        subtitle: Text(
          time.format(context),
          style: TextStyle(
            color: TColor.sceondarText,
            fontSize: 13,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: reminderEnabled
              ? TColor.primary
              : Colors.grey,
          size: 17,
        ),
      ),
    );
  }
}
