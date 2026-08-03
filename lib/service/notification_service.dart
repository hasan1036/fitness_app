import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const int _workoutNotificationBaseId = 100;
  static const int _waterNotificationBaseId = 3000;

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    try {
      final TimezoneInfo timezoneInfo =
      await FlutterTimezone.getLocalTimezone();

      tz.setLocalLocation(
        tz.getLocation(timezoneInfo.identifier),
      );
    } catch (error) {
      // Bangladesh fallback timezone.
      tz.setLocalLocation(
        tz.getLocation('Asia/Dhaka'),
      );
    }

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings(
      'ic_notification',
    );

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    await requestPermissions();
  }

  static Future<bool> requestPermissions() async {
    bool permissionGranted = true;

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final bool? notificationPermission =
    await androidPlugin?.requestNotificationsPermission();

    if (notificationPermission == false) {
      permissionGranted = false;
    }

    final IOSFlutterLocalNotificationsPlugin? iosPlugin =
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    final bool? iosPermission =
    await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (iosPermission == false) {
      permissionGranted = false;
    }

    return permissionGranted;
  }

  static const NotificationDetails _notificationDetails =
  NotificationDetails(
    android: AndroidNotificationDetails(
      'workout_reminder_channel_v5',
      'Workout Reminders',
      channelDescription:
      'Notifications for scheduled workout reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: 'ic_notification',
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  static Future<bool> showTestNotification() async {
    final bool permissionGranted =
    await requestPermissions();

    if (!permissionGranted) {
      return false;
    }

    await flutterLocalNotificationsPlugin.show(
      id: 1,
      title: 'Workout Time',
      body: 'Notification and sound are working!',
      notificationDetails: _notificationDetails,
      payload: 'workout_test',
    );

    return true;
  }

  static Future<void> scheduleWorkoutReminders({
    required int hour,
    required int minute,
    required List<int> selectedDayIndexes,
  }) async {
    await cancelWorkoutReminders();

    final bool permissionGranted =
    await requestPermissions();

    if (!permissionGranted) {
      throw Exception(
        'Notification permission was not allowed',
      );
    }

    if (selectedDayIndexes.isEmpty) {
      throw Exception(
        'Select at least one reminder day',
      );
    }

    for (final int dayIndex in selectedDayIndexes) {
      if (dayIndex < 0 || dayIndex > 6) {
        continue;
      }

      final int weekday = dayIndex + 1;

      final tz.TZDateTime scheduledDate =
      _nextWeekdayTime(
        weekday: weekday,
        hour: hour,
        minute: minute,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: _workoutNotificationBaseId + dayIndex,
        title: 'Workout Time',
        body:
        'Time to complete today\'s workout. Keep your streak alive!',
        scheduledDate: scheduledDate,
        notificationDetails: _notificationDetails,
        androidScheduleMode:
        AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents:
        DateTimeComponents.dayOfWeekAndTime,
        payload: 'workout_reminder',
      );
    }
  }

  static Future<void> scheduleTestNotification() async {
    final bool permissionGranted =
    await requestPermissions();

    if (!permissionGranted) {
      throw Exception(
        'Notification permission was not allowed',
      );
    }

    final tz.TZDateTime scheduledDate =
    tz.TZDateTime.now(tz.local).add(
      const Duration(seconds: 10),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 999,
      title: 'Workout Test Reminder',
      body: 'The scheduled reminder is working!',
      scheduledDate: scheduledDate,
      notificationDetails: _notificationDetails,
      androidScheduleMode:
      AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'scheduled_test',
    );
  }



  static const NotificationDetails _waterNotificationDetails =
      NotificationDetails(
    android: AndroidNotificationDetails(
      'water_reminder_channel_v1',
      'Water Reminders',
      channelDescription:
          'Notifications that remind you to drink water',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: 'ic_notification',
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  static Future<void> scheduleWaterReminders({
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
    required int intervalMinutes,
    required List<int> selectedDayIndexes,
  }) async {
    await cancelWaterReminders();

    final bool permissionGranted =
        await requestPermissions();

    if (!permissionGranted) {
      throw Exception(
        'Notification permission was not allowed',
      );
    }

    if (selectedDayIndexes.isEmpty) {
      throw Exception(
        'Select at least one reminder day',
      );
    }

    final int startTotalMinutes =
        (startHour * 60) + startMinute;
    final int endTotalMinutes =
        (endHour * 60) + endMinute;

    if (endTotalMinutes <= startTotalMinutes) {
      throw Exception(
        'End time must be later than start time',
      );
    }

    int slotIndex = 0;

    for (final int dayIndex in selectedDayIndexes) {
      if (dayIndex < 0 || dayIndex > 6) {
        continue;
      }

      final int weekday = dayIndex + 1;

      for (
        int minuteOfDay = startTotalMinutes;
        minuteOfDay <= endTotalMinutes;
        minuteOfDay += intervalMinutes
      ) {
        final int hour = minuteOfDay ~/ 60;
        final int minute = minuteOfDay % 60;

        final tz.TZDateTime scheduledDate =
            _nextWeekdayTime(
          weekday: weekday,
          hour: hour,
          minute: minute,
        );

        await flutterLocalNotificationsPlugin.zonedSchedule(
          id: _waterNotificationBaseId + slotIndex,
          title: 'Drink Water',
          body: 'Time to drink a glass of water.',
          scheduledDate: scheduledDate,
          notificationDetails: _waterNotificationDetails,
          androidScheduleMode:
              AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents:
              DateTimeComponents.dayOfWeekAndTime,
          payload: 'water_reminder',
        );

        slotIndex++;
      }
    }
  }

  static Future<void> cancelWaterReminders() async {
    for (int id = _waterNotificationBaseId;
        id < _waterNotificationBaseId + 500;
        id++) {
      await flutterLocalNotificationsPlugin.cancel(
        id: id,
      );
    }
  }

  static tz.TZDateTime _nextWeekdayTime({
    required int weekday,
    required int hour,
    required int minute,
  }) {
    final tz.TZDateTime now =
    tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate =
    tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (scheduledDate.weekday != weekday ||
        !scheduledDate.isAfter(now)) {
      scheduledDate = scheduledDate.add(
        const Duration(days: 1),
      );
    }

    return scheduledDate;
  }

  static Future<void> cancelWorkoutReminders() async {
    for (int dayIndex = 0;
    dayIndex < 7;
    dayIndex++) {
      await flutterLocalNotificationsPlugin.cancel(
        id: _workoutNotificationBaseId + dayIndex,
      );
    }

    await flutterLocalNotificationsPlugin.cancel(
      id: 999,
    );
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
