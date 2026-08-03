import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/color_extention.dart';
import '../../service/notification_service.dart';

class WorkoutReminderView extends StatefulWidget {
  const WorkoutReminderView({super.key});

  @override
  State<WorkoutReminderView> createState() =>
      _WorkoutReminderViewState();
}

class _WorkoutReminderViewState
    extends State<WorkoutReminderView> {
  static const String _enabledKey =
      "workout_reminder_enabled";

  static const String _hourKey =
      "workout_reminder_hour";

  static const String _minuteKey =
      "workout_reminder_minute";

  static const String _daysKey =
      "workout_reminder_days";

  bool reminderEnabled = false;
  bool isLoading = true;
  bool isSaving = false;

  TimeOfDay selectedTime =
  const TimeOfDay(hour: 19, minute: 0);

  final List<String> dayNames = const [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  List<bool> selectedDays =
  List<bool>.filled(7, true);

  @override
  void initState() {
    super.initState();
    _loadReminder();
  }

  Future<void> _loadReminder() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    final List<String> savedDays =
        prefs.getStringList(_daysKey) ?? [];

    if (!mounted) return;

    setState(() {
      reminderEnabled =
          prefs.getBool(_enabledKey) ?? false;

      selectedTime = TimeOfDay(
        hour: prefs.getInt(_hourKey) ?? 19,
        minute: prefs.getInt(_minuteKey) ?? 0,
      );

      if (savedDays.isNotEmpty) {
        selectedDays = List<bool>.generate(
          7,
              (index) => savedDays.contains(
            index.toString(),
          ),
        );
      }

      isLoading = false;
    });
  }

  Future<void> _pickTime() async {
    final TimeOfDay? time =
    await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (time == null || !mounted) return;

    setState(() {
      selectedTime = time;
    });
  }

  Future<void> _saveReminder() async {
    if (reminderEnabled &&
        !selectedDays.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Select at least one reminder day",
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

      final List<String> selectedIndexes = [];
      final List<int> selectedDayIndexes = [];

      for (int i = 0; i < selectedDays.length; i++) {
        if (selectedDays[i]) {
          selectedIndexes.add(i.toString());
          selectedDayIndexes.add(i);
        }
      }

      await prefs.setBool(
        _enabledKey,
        reminderEnabled,
      );

      await prefs.setInt(
        _hourKey,
        selectedTime.hour,
      );

      await prefs.setInt(
        _minuteKey,
        selectedTime.minute,
      );

      await prefs.setStringList(
        _daysKey,
        selectedIndexes,
      );

      if (reminderEnabled) {
        await NotificationService.scheduleWorkoutReminders(
          hour: selectedTime.hour,
          minute: selectedTime.minute,
          selectedDayIndexes: selectedDayIndexes,
        );
      } else {
        await NotificationService.cancelWorkoutReminders();
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            reminderEnabled
                ? "Workout reminder scheduled"
                : "Workout reminder turned off",
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Could not schedule reminder: $error",
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

  String _formattedTime() {
    return selectedTime.format(context);
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

        title: const Text(
          "Workout Reminder",
          style: TextStyle(
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
          _buildHeader(),

          const SizedBox(height: 22),

          _settingCard(
            child: SwitchListTile(
              contentPadding:
              EdgeInsets.zero,
              value: reminderEnabled,
              activeColor:
              TColor.primary,
              title: const Text(
                "Enable Reminder",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
              subtitle: Text(
                reminderEnabled
                    ? "Reminder is active"
                    : "Reminder is turned off",
                style: TextStyle(
                  color:
                  TColor.sceondarText,
                ),
              ),
              secondary: Icon(
                Icons.notifications_active_rounded,
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

          const SizedBox(height: 14),

          _settingCard(
            child: ListTile(
              contentPadding:
              EdgeInsets.zero,
              enabled: reminderEnabled,
              leading: Icon(
                Icons.access_time_filled_rounded,
                color: reminderEnabled
                    ? TColor.primary
                    : Colors.grey,
              ),
              title: const Text(
                "Reminder Time",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
              subtitle: Text(
                _formattedTime(),
                style: TextStyle(
                  color:
                  TColor.sceondarText,
                  fontSize: 14,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: reminderEnabled
                    ? TColor.primary
                    : Colors.grey,
                size: 17,
              ),
              onTap: reminderEnabled
                  ? _pickTime
                  : null,
            ),
          ),

          const SizedBox(height: 22),

          Text(
            "Repeat Days",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              dayNames.length,
                  (index) {
                final bool selected =
                selectedDays[index];

                return ChoiceChip(
                  label: Text(
                    dayNames[index],
                  ),
                  selected: selected,
                  selectedColor:
                  TColor.primary,
                  disabledColor:
                  Colors.grey.shade200,
                  backgroundColor:
                  Colors.white,
                  labelStyle: TextStyle(
                    color: selected
                        ? Colors.white
                        : reminderEnabled
                        ? TColor.primaryText
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
                  : _saveReminder,
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
                  : const Text(
                "SAVE REMINDER",
                style: TextStyle(
                  fontSize: 17,
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

  Widget _buildHeader() {
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
              Icons.fitness_center_rounded,
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
                const Text(
                  "Never Miss a Workout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  "Choose a time and the days you want to exercise.",
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
}