import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

void saveUser({
  required String name,
  required String user,
  required String email,
}) async {
  DocumentReference userDB =
      FirebaseFirestore.instance.collection('users').doc(email);

  await userDB.get().then((DocumentSnapshot doc) async {
    if (doc.exists) {
      return await userDB.update({
        'name': name,
        'user': user,
        'email': email,
      });
    } else {
      return await userDB.set({
        'name': name,
        'user': user,
        'email': email,
      });
    }
  });
}

Future<bool> addReminders({
  required BuildContext context,
  required String name,
  required String quantity,
  required String days,
  required String notification,
}) async {
  try {
    // Check if the current user is authenticated
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('Error: Current user is null');
      return false;
    }

    CollectionReference reminderDB =
        FirebaseFirestore.instance.collection('Reminder');

    await reminderDB.add(
      {
        "name": name,
        "notification": notification,
        "email": currentUser.email,
        "quantity": quantity,
        "days": days,
      },
    );

    // Schedule notification for the added reminder
    await scheduleNotification(name, notification, int.parse(days));

    return true;
  } catch (e, stackTrace) {
    print('Error adding reminder: $e');
    print('StackTrace: $stackTrace');
    // Handle error by displaying a message to the user
    // You may need to import the correct Message module or handle the error differently here
    return false;
  }
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
     );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  final now = DateTime.now();
  final notificationHour =
      int.tryParse(notificationTime.split(':')[0]) ?? 0;
  final notificationMinute =
      int.tryParse(notificationTime.split(':')[1]) ?? 0;

  // Construct the notification time
  final notificationDateTime = tz.TZDateTime(
    tz.local,
    now.year, 
    now.month, 
    now.day + days,
    notificationHour,
    notificationMinute,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0, // Change to a unique ID for each notification
    'Reminder', // Notification title
    'Time for $name', // Notification body
    notificationDateTime, // Scheduled date and time
    platformChannelSpecifics,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    androidAllowWhileIdle: true, // Allow notifications while the device is idle
  );
}


Future<List<QueryDocumentSnapshot>> getReminders() async {
  CollectionReference reminderDB =
      FirebaseFirestore.instance.collection('Reminder');
  var list = await reminderDB
      .where(
        "email",
        isEqualTo: FirebaseAuth.instance.currentUser!.email,
      )
      .get();
  return list.docs.toList();
}

Future<List<QueryDocumentSnapshot>> getMyReminders() async {
  CollectionReference bibliDB =
      FirebaseFirestore.instance.collection('Reminder');
  var list = await bibliDB
      .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .get();
  return list.docs.toList();
}

Future<bool> removeReminders(String id) async {
  CollectionReference bibliDB =
      FirebaseFirestore.instance.collection('Reminder');
  try {
    var ref = await bibliDB.doc("$id");
    ref.delete();
    return true;
  } catch (e) {
    return false;
  }
}
