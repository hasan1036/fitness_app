import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/color_extention.dart';
import '../../l10n/app_localizations.dart';
import '../../service/notification_service.dart';

class WaterReminderView extends StatefulWidget {
  const WaterReminderView({super.key});

  @override
  State<WaterReminderView> createState() =>
      _WaterReminderViewState();
}

class _WaterReminderViewState
    extends State<WaterReminderView> {
  static const String _enabledKey =
      'water_reminder_enabled';
  static const String _startHourKey =
      'water_reminder_start_hour';
  static const String _startMinuteKey =
      'water_reminder_start_minute';
  static const String _endHourKey =
      'water_reminder_end_hour';
  static const String _endMinuteKey =
      'water_reminder_end_minute';
  static const String _intervalKey =
      'water_reminder_interval';
  static const String _daysKey =
      'water_reminder_days';

  bool reminderEnabled = false;
  bool isLoading = true;
  bool isSaving = false;

  TimeOfDay startTime =
  const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime =
  const TimeOfDay(hour: 22, minute: 0);
  int intervalMinutes = 60;

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

      startTime = TimeOfDay(
        hour: prefs.getInt(_startHourKey) ?? 8,
        minute: prefs.getInt(_startMinuteKey) ?? 0,
      );

      endTime = TimeOfDay(
        hour: prefs.getInt(_endHourKey) ?? 22,
        minute: prefs.getInt(_endMinuteKey) ?? 0,
      );

      intervalMinutes =
          prefs.getInt(_intervalKey) ?? 60;

      if (savedDays.isNotEmpty) {
        selectedDays = List<bool>.generate(
          7,
              (index) => savedDays.contains(index.toString()),
        );
      }

      isLoading = false;
    });
  }

  Future<void> _pickStartTime() async {
    final TimeOfDay? value = await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    if (value == null || !mounted) return;

    setState(() {
      startTime = value;
    });
  }

  Future<void> _pickEndTime() async {
    final TimeOfDay? value = await showTimePicker(
      context: context,
      initialTime: endTime,
    );

    if (value == null || !mounted) return;

    setState(() {
      endTime = value;
    });
  }

  Future<void> _saveReminder() async {
    if (reminderEnabled &&
        !selectedDays.contains(true)) {
      _showMessage(
        context.tr('selectAtLeastOneDay'),
      );
      return;
    }

    final int startMinutes =
        (startTime.hour * 60) + startTime.minute;
    final int endMinutes =
        (endTime.hour * 60) + endTime.minute;

    if (reminderEnabled && endMinutes <= startMinutes) {
      _showMessage(
        context.tr('endTimeAfterStartTime'),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final List<String> savedIndexes = [];
      final List<int> selectedIndexes = [];

      for (int i = 0; i < selectedDays.length; i++) {
        if (selectedDays[i]) {
          savedIndexes.add(i.toString());
          selectedIndexes.add(i);
        }
      }

      await prefs.setBool(
        _enabledKey,
        reminderEnabled,
      );

      await prefs.setInt(
        _startHourKey,
        startTime.hour,
      );

      await prefs.setInt(
        _startMinuteKey,
        startTime.minute,
      );

      await prefs.setInt(
        _endHourKey,
        endTime.hour,
      );

      await prefs.setInt(
        _endMinuteKey,
        endTime.minute,
      );

      await prefs.setInt(
        _intervalKey,
        intervalMinutes,
      );

      await prefs.setStringList(
        _daysKey,
        savedIndexes,
      );

      if (reminderEnabled) {
        await NotificationService.scheduleWaterReminders(
          startHour: startTime.hour,
          startMinute: startTime.minute,
          endHour: endTime.hour,
          endMinute: endTime.minute,
          intervalMinutes: intervalMinutes,
          selectedDayIndexes: selectedIndexes,
        );
      } else {
        await NotificationService.cancelWaterReminders();
      }

      if (!mounted) return;

      _showMessage(
        reminderEnabled
            ? context.tr('waterReminderScheduled')
            : context.tr('waterReminderTurnedOff'),
      );
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        '${context.tr('couldNotSaveReminder')}: $error',
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String _intervalLabel(int minutes) {
    if (minutes < 60) {
      return '$minutes ${context.tr('minuteShort')}';
    }

    if (minutes == 60) {
      return '1 ${context.tr('hour')}';
    }

    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;

    if (remainingMinutes == 0) {
      return '$hours ${context.tr('hoursShort')}';
    }

    return '$hours ${context.tr('hoursShort')} '
        '$remainingMinutes ${context.tr('minutesShort')}';
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
          context.tr('waterReminder'),
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
          const SizedBox(height: 22),
          _settingCard(
            child: SwitchListTile(
              contentPadding:
              EdgeInsets.zero,
              value: reminderEnabled,
              activeColor:
              TColor.primary,
              title: Text(
                context.tr('enableReminder'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
              subtitle: Text(
                reminderEnabled
                    ? context.tr('reminderActive')
                    : context.tr('reminderTurnedOff'),
                style: TextStyle(
                  color:
                  TColor.sceondarText,
                ),
              ),
              secondary: Icon(
                Icons.water_drop_rounded,
                color: reminderEnabled
                    ? TColor.primary
                    : Colors.grey,
              ),
              onChanged: (value) {
                setState(() {
                  reminderEnabled = value;
                });
              },
            ),
          ),
          const SizedBox(height: 14),
          _timeCard(
            title: context.tr('startTime'),
            time: startTime,
            onTap: _pickStartTime,
          ),
          const SizedBox(height: 14),
          _timeCard(
            title: context.tr('endTime'),
            time: endTime,
            onTap: _pickEndTime,
          ),
          const SizedBox(height: 22),
          Text(
            context.tr('reminderInterval'),
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
            children: [30, 60, 90, 120]
                .map((minutes) {
              return ChoiceChip(
                label: Text(
                  _intervalLabel(minutes),
                ),
                selected:
                intervalMinutes == minutes,
                selectedColor:
                TColor.primary,
                backgroundColor:
                Colors.white,
                labelStyle: TextStyle(
                  color: intervalMinutes == minutes
                      ? Colors.white
                      : TColor.primaryText,
                  fontWeight:
                  FontWeight.w700,
                ),
                onSelected:
                reminderEnabled
                    ? (_) {
                  setState(() {
                    intervalMinutes =
                        minutes;
                  });
                }
                    : null,
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          Text(
            context.tr('repeatDays'),
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
              dayKeys.length,
                  (index) {
                final bool selected =
                selectedDays[index];

                return ChoiceChip(
                  label: Text(
                    context.tr(dayKeys[index]),
                  ),
                  selected: selected,
                  selectedColor:
                  TColor.primary,
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
                      selectedDays[index] =
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
                  : Text(
                context.tr('saveReminder'),
                style: const TextStyle(
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

  Widget _buildHeader(BuildContext context) {
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
              Icons.water_drop_rounded,
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
                  context.tr('stayHydrated'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  context.tr('chooseWaterReminderSchedule'),
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

  Widget _timeCard({
    required String title,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return _settingCard(
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
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          time.format(context),
          style: TextStyle(
            color: TColor.sceondarText,
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
        onTap:
        reminderEnabled ? onTap : null,
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
