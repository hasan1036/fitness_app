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
  static const int _mealNotificationBaseId = 5000;
  static const int _sleepNotificationBaseId = 7000;

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



  static const NotificationDetails _mealNotificationDetails =
      NotificationDetails(
    android: AndroidNotificationDetails(
      'meal_reminder_channel_v1',
      'Meal Reminders',
      channelDescription:
          'Notifications for breakfast, snack, lunch and dinner',
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

  static Future<void> scheduleMealReminders({
    required int breakfastHour,
    required int breakfastMinute,
    required int snackHour,
    required int snackMinute,
    required int lunchHour,
    required int lunchMinute,
    required int dinnerHour,
    required int dinnerMinute,
    required List<int> selectedDayIndexes,
  }) async {
    await cancelMealReminders();

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

    final List<Map<String, dynamic>> meals = [
      {
        'title': 'Breakfast Time',
        'body': 'Start your day with a healthy breakfast.',
        'hour': breakfastHour,
        'minute': breakfastMinute,
        'offset': 0,
      },
      {
        'title': 'Healthy Snack Time',
        'body': 'Choose a light and healthy snack.',
        'hour': snackHour,
        'minute': snackMinute,
        'offset': 1,
      },
      {
        'title': 'Lunch Time',
        'body': 'Time for a balanced and nutritious lunch.',
        'hour': lunchHour,
        'minute': lunchMinute,
        'offset': 2,
      },
      {
        'title': 'Dinner Time',
        'body': 'Enjoy a light and healthy dinner.',
        'hour': dinnerHour,
        'minute': dinnerMinute,
        'offset': 3,
      },
    ];

    for (final int dayIndex in selectedDayIndexes) {
      if (dayIndex < 0 || dayIndex > 6) {
        continue;
      }

      final int weekday = dayIndex + 1;

      for (final Map<String, dynamic> meal in meals) {
        final tz.TZDateTime scheduledDate =
            _nextWeekdayTime(
          weekday: weekday,
          hour: meal['hour'] as int,
          minute: meal['minute'] as int,
        );

        await flutterLocalNotificationsPlugin.zonedSchedule(
          id: _mealNotificationBaseId +
              (dayIndex * 10) +
              (meal['offset'] as int),
          title: meal['title'] as String,
          body: meal['body'] as String,
          scheduledDate: scheduledDate,
          notificationDetails: _mealNotificationDetails,
          androidScheduleMode:
              AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents:
              DateTimeComponents.dayOfWeekAndTime,
          payload: 'meal_reminder',
        );
      }
    }
  }

  static Future<void> cancelMealReminders() async {
    for (int dayIndex = 0; dayIndex < 7; dayIndex++) {
      for (int mealIndex = 0; mealIndex < 4; mealIndex++) {
        await flutterLocalNotificationsPlugin.cancel(
          id: _mealNotificationBaseId +
              (dayIndex * 10) +
              mealIndex,
        );
      }
    }
  }



  static const NotificationDetails _sleepNotificationDetails =
      NotificationDetails(
    android: AndroidNotificationDetails(
      'sleep_reminder_channel_v1',
      'Sleep Reminders',
      channelDescription:
          'Bedtime and wake-up reminder notifications',
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

  static Future<void> scheduleSleepReminders({
    required int bedHour,
    required int bedMinute,
    required int wakeHour,
    required int wakeMinute,
    required List<int> selectedDayIndexes,
  }) async {
    await cancelSleepReminders();

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

      final tz.TZDateTime bedDate =
          _nextWeekdayTime(
        weekday: weekday,
        hour: bedHour,
        minute: bedMinute,
      );

      final tz.TZDateTime wakeDate =
          _nextWeekdayTime(
        weekday: weekday,
        hour: wakeHour,
        minute: wakeMinute,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: _sleepNotificationBaseId +
            (dayIndex * 10),
        title: 'Time to Sleep',
        body:
            'Wind down and get enough rest for tomorrow.',
        scheduledDate: bedDate,
        notificationDetails:
            _sleepNotificationDetails,
        androidScheduleMode:
            AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents:
            DateTimeComponents.dayOfWeekAndTime,
        payload: 'sleep_bedtime_reminder',
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: _sleepNotificationBaseId +
            (dayIndex * 10) +
            1,
        title: 'Good Morning',
        body:
            'Wake up refreshed and start your healthy day.',
        scheduledDate: wakeDate,
        notificationDetails:
            _sleepNotificationDetails,
        androidScheduleMode:
            AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents:
            DateTimeComponents.dayOfWeekAndTime,
        payload: 'sleep_wakeup_reminder',
      );
    }
  }

  static Future<void> cancelSleepReminders() async {
    for (int dayIndex = 0;
        dayIndex < 7;
        dayIndex++) {
      await flutterLocalNotificationsPlugin.cancel(
        id: _sleepNotificationBaseId +
            (dayIndex * 10),
      );

      await flutterLocalNotificationsPlugin.cancel(
        id: _sleepNotificationBaseId +
            (dayIndex * 10) +
            1,
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
