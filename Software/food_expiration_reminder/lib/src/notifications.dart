import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'food_data.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class Notifications {
  Notifications();

  static Future<void> initialisePlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            initializationSettingsAndroid, initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectNotificationSubject.add(payload);
    });

    _setTimeZone();
  }

  static Future<void> askIOSpermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<String> _getTimeZone() async {
    return await FlutterNativeTimezone.getLocalTimezone();
  }

  static Future<void> _setTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(await _getTimeZone()));
  }

  static Future<void> deleteNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

    static Future<void> deleteAllNotifications() async {
     await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> scheduleNotification(FoodData foodData) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      importance: Importance.Max,
      priority: Priority.Max,
      icon: 'app_icon',
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        foodData.id,
        "No Waste!",
        "Your ${foodData.name} is going off tomorrow. Eat it before it is too late!",
        //DateTime.now().add(Duration(seconds: 5)),
        //sets the notification one day before the expiration date
        foodData.date.subtract(Duration(days: 1)),
        platformChannelSpecifics);
  }
}
