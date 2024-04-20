import 'dart:developer';

import 'dart:typed_data';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:uipages/main.dart';
import 'package:uipages/pages/medication_management/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    // Check if the notification time is in HH:mm format
    final RegExp regExp = RegExp(
      r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$',
      caseSensitive: false,
      multiLine: false,
    );
    if (!regExp.hasMatch(notification)) {
      throw FormatException('Invalid time format: $notification. Please use HH:mm format.');
    }

    // Parse the notification time
    TimeOfDay time = TimeOfDay(
      hour: int.parse(notification.split(":")[0]),
      minute: int.parse(notification.split(":")[1]),
    );

    CollectionReference reminderDB =
        FirebaseFirestore.instance.collection('Reminder');

    await reminderDB.add(
      {
        "name": name,
        "notification": notification,
        "email": FirebaseAuth.instance.currentUser!.email,
        "quantity": quantity,
        "days": days,
      },
    );

    // Calculate the total milliseconds for the delay
    final int delay = int.parse(days) * 24 * 60 * 60 * 1000;

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder for $name',
      'Time to take $quantity of $name!',
      _nextInstanceOfTime(time, delay),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'mhealthmate',
          'Medicine Alert',
        ),
      ),
      // androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    return true;
  } catch (e) {
    showErrorMessage(context, e.toString());
    return false;
  }
}

TZDateTime _nextInstanceOfTime(TimeOfDay time, int delay) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );
  scheduledDate = scheduledDate.add(Duration(milliseconds: delay));
  return scheduledDate;
}



void showErrorMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.deepPurple,
        title: Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    },
  );
}
/* /// Calculate the next instance of time by adding the delay
TZDateTime _nextInstanceOfTime(int hour, int minute, int delay) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  scheduledDate = scheduledDate.add(Duration(milliseconds: delay));
  return scheduledDate;
} */

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
  CollectionReference bibliDB = FirebaseFirestore.instance.collection('Reminder');
  var list = await bibliDB
      .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .get();
  return list.docs.toList();
}

Future<bool> removeReminders(String id) async {
  CollectionReference bibliDB = FirebaseFirestore.instance.collection('Reminder');
  try {
    var ref = await bibliDB.doc("$id");
    ref.delete();
    return true;
  } catch (e) {
    return false;
  }
}
