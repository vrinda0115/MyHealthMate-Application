import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class FNotification extends StatefulWidget {
  const FNotification({Key? key}) : super(key: key);

  @override
  State<FNotification> createState() => _FNotificationState();
}

class _FNotificationState extends State<FNotification> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  Future<void> scheduleNotifications() async {
    final reminders = await getReminders();
    reminders.forEach((reminder) {
      final data = reminder.data() as Map<String, dynamic>;
      final name = data['name'] as String;
      final notificationTime = data['notification'] as String;
      final days = int.parse(data['days'] as String);
      scheduleNotification(name, notificationTime, days);
    });
  }

  Future<void> scheduleNotification(
      String name, String notificationTime, int days) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
       AndroidNotificationDetails(
  'reminder_channel_id', // Change to your channel ID
  'Reminders', // Change to your channel name
  channelDescription: 'Time to take your medicines', // Change to your channel description
  importance: Importance.high,
  priority: Priority.high,
);;

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final now = DateTime.now();
    final notificationHour =
        int.tryParse(notificationTime.split(':')[0]) ?? 0;
    final notificationMinute =
        int.tryParse(notificationTime.split(':')[1]) ?? 0;

    // Construct the notification time
    final notificationDateTime = DateTime(now.year, now.month, now.day + days,
        notificationHour, notificationMinute);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Change to a unique ID for each notification
      'Reminder', // Notification title
      'Time for $name', // Notification body
      tz.TZDateTime.from(notificationDateTime, tz.local), // Scheduled date and time
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true, // Allow notifications while the device is idle
    );
  }

  Future<List<DocumentSnapshot>> getReminders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('Reminders')
          .where('email', isEqualTo: user.email)
          .get();
      return snapshot.docs;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            scheduleNotifications();
          },
          child: Text('Schedule Reminders'),
        ),
      ),
    );
  }
}
