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

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    final TimezoneInfo timezoneInfo =
    await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(
      tz.getLocation(timezoneInfo.identifier),
    );

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

    const InitializationSettings settings =
    InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: settings,
    );

    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();

    final IOSFlutterLocalNotificationsPlugin? iosPlugin =
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static const NotificationDetails _notificationDetails =
  NotificationDetails(
    android: AndroidNotificationDetails(
      'workout_reminder_channel',
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

  static Future<void> scheduleWorkoutReminders({
    required int hour,
    required int minute,
    required List<int> selectedDayIndexes,
  }) async {
    await cancelWorkoutReminders();

    for (final int dayIndex in selectedDayIndexes) {
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
        AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents:
        DateTimeComponents.dayOfWeekAndTime,
        payload: 'workout_reminder',
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
      scheduledDate =
          scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  static Future<void> cancelWorkoutReminders() async {
    for (int dayIndex = 0; dayIndex < 7; dayIndex++) {
      await flutterLocalNotificationsPlugin.cancel(
        id: _workoutNotificationBaseId + dayIndex,
      );
    }
  }

  static Future<void> showTestNotification() async {
    await flutterLocalNotificationsPlugin.show(
      id: 1,
      title: 'Workout Time',
      body: 'Time to complete today\'s workout!',
      notificationDetails: _notificationDetails,
      payload: 'workout_reminder',
    );
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
