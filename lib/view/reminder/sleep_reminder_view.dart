import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/color_extention.dart';
import '../../l10n/app_localizations.dart';
import '../../service/notification_service.dart';

class SleepReminderView extends StatefulWidget {
  const SleepReminderView({super.key});

  @override
  State<SleepReminderView> createState() =>
      _SleepReminderViewState();
}

class _SleepReminderViewState
    extends State<SleepReminderView> {
  static const String _enabledKey =
      'sleep_reminder_enabled';
  static const String _bedHourKey =
      'sleep_reminder_bed_hour';
  static const String _bedMinuteKey =
      'sleep_reminder_bed_minute';
  static const String _wakeHourKey =
      'sleep_reminder_wake_hour';
  static const String _wakeMinuteKey =
      'sleep_reminder_wake_minute';
  static const String _daysKey =
      'sleep_reminder_days';

  bool reminderEnabled = false;
  bool isLoading = true;
  bool isSaving = false;

  TimeOfDay bedTime =
  const TimeOfDay(hour: 22, minute: 30);
  TimeOfDay wakeTime =
  const TimeOfDay(hour: 6, minute: 30);

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

      bedTime = TimeOfDay(
        hour: prefs.getInt(_bedHourKey) ?? 22,
        minute: prefs.getInt(_bedMinuteKey) ?? 30,
      );

      wakeTime = TimeOfDay(
        hour: prefs.getInt(_wakeHourKey) ?? 6,
        minute: prefs.getInt(_wakeMinuteKey) ?? 30,
      );

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

  Future<void> _pickBedTime() async {
    final TimeOfDay? result =
    await showTimePicker(
      context: context,
      initialTime: bedTime,
    );

    if (result == null || !mounted) return;

    setState(() {
      bedTime = result;
    });
  }

  Future<void> _pickWakeTime() async {
    final TimeOfDay? result =
    await showTimePicker(
      context: context,
      initialTime: wakeTime,
    );

    if (result == null || !mounted) return;

    setState(() {
      wakeTime = result;
    });
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

      await prefs.setInt(
        _bedHourKey,
        bedTime.hour,
      );

      await prefs.setInt(
        _bedMinuteKey,
        bedTime.minute,
      );

      await prefs.setInt(
        _wakeHourKey,
        wakeTime.hour,
      );

      await prefs.setInt(
        _wakeMinuteKey,
        wakeTime.minute,
      );

      await prefs.setStringList(
        _daysKey,
        selectedDayStrings,
      );

      if (reminderEnabled) {
        await NotificationService
            .scheduleSleepReminders(
          bedHour: bedTime.hour,
          bedMinute: bedTime.minute,
          wakeHour: wakeTime.hour,
          wakeMinute: wakeTime.minute,
          selectedDayIndexes:
          selectedDayIndexes,
        );
      } else {
        await NotificationService
            .cancelSleepReminders();
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            reminderEnabled
                ? context.tr(
              'sleepRemindersScheduled',
            )
                : context.tr(
              'sleepRemindersTurnedOff',
            ),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.tr('couldNotSaveSleepReminders')}: $error',
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

  Duration get sleepDuration {
    final int bedMinutes =
        (bedTime.hour * 60) + bedTime.minute;

    final int wakeMinutes =
        (wakeTime.hour * 60) + wakeTime.minute;

    int difference = wakeMinutes - bedMinutes;

    if (difference <= 0) {
      difference += 24 * 60;
    }

    return Duration(minutes: difference);
  }

  String get sleepDurationText {
    final int hours = sleepDuration.inHours;
    final int minutes =
    sleepDuration.inMinutes.remainder(60);

    if (minutes == 0) {
      return '$hours ${context.tr('hours')}';
    }

    return '$hours ${context.tr('hoursShort')} '
        '$minutes ${context.tr('minuteShort')}';
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
          context.tr('sleepReminder'),
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
                  'enableSleepReminder',
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
                  'sleepRemindersActive',
                )
                    : context.tr(
                  'sleepRemindersOff',
                ),
                style: TextStyle(
                  color:
                  TColor.sceondarText,
                ),
              ),
              secondary: Icon(
                Icons.bedtime_rounded,
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
            context.tr('sleepSchedule'),
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
            Icons.bedtime_rounded,
            title:
            context.tr('bedTime'),
            subtitle: context.tr(
              'prepareForSleepReminder',
            ),
            time: bedTime,
            enabled:
            reminderEnabled,
            onTap: _pickBedTime,
          ),
          const SizedBox(height: 12),
          _timeTile(
            icon:
            Icons.wb_sunny_rounded,
            title:
            context.tr('wakeUpTime'),
            subtitle: context.tr(
              'morningWakeUpNotification',
            ),
            time: wakeTime,
            enabled:
            reminderEnabled,
            onTap: _pickWakeTime,
          ),
          const SizedBox(height: 14),
          Container(
            padding:
            const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(
                20,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration:
                  BoxDecoration(
                    color:
                    TColor.primaryLight,
                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Icon(
                    Icons.schedule_rounded,
                    color: TColor.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        context.tr(
                          'plannedSleep',
                        ),
                        style:
                        const TextStyle(
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        sleepDurationText,
                        style: TextStyle(
                          color:
                          TColor.primary,
                          fontSize: 18,
                          fontWeight:
                          FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
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
                  labelStyle:
                  TextStyle(
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
                  'saveSleepReminder',
                ),
                textAlign:
                TextAlign.center,
                style:
                const TextStyle(
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
        borderRadius:
        BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color:
              Colors.white.withOpacity(0.16),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.nightlight_round,
              color: Colors.white,
              size: 35,
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
                    'healthySleepRoutine',
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
                    'sleepReminderHeaderSubtitle',
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

  Widget _timeTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required TimeOfDay time,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return _settingCard(
      child: ListTile(
        contentPadding:
        EdgeInsets.zero,
        enabled: enabled,
        onTap: enabled ? onTap : null,
        leading: Container(
          width: 47,
          height: 47,
          decoration: BoxDecoration(
            color: enabled
                ? TColor.primaryLight
                : Colors.grey.shade200,
            borderRadius:
            BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: enabled
                ? TColor.primary
                : Colors.grey,
          ),
        ),
        title: Text(
          title,
          maxLines: 2,
          overflow:
          TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight:
            FontWeight.w800,
          ),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 2,
          overflow:
          TextOverflow.ellipsis,
          style: TextStyle(
            color:
            TColor.sceondarText,
            fontSize: 11,
          ),
        ),
        trailing: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          crossAxisAlignment:
          CrossAxisAlignment.end,
          children: [
            Text(
              time.format(context),
              style: TextStyle(
                color: enabled
                    ? TColor.primary
                    : Colors.grey,
                fontSize: 15,
                fontWeight:
                FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: enabled
                  ? TColor.primary
                  : Colors.grey,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingCard({
    required Widget child,
  }) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
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
