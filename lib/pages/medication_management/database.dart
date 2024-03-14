import 'dart:developer';
import 'dart:typed_data';

import 'package:uipages/pages/medication_management/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

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

    return true;
  } catch (e) {
    Message.showError(context, 'Error');
    return false;
  }
}

Future<DocumentSnapshot?> getUser([String? email]) async {
  DocumentReference userDB = FirebaseFirestore.instance
      .collection('Users')
      .doc(email ?? FirebaseAuth.instance.currentUser!.email);

  DocumentSnapshot userDoc = await userDB.get();
  if (userDoc.exists) {
    return userDoc;
  }
}

Future<List<QueryDocumentSnapshot>> getReminders() async {
  CollectionReference reminderDB =
      FirebaseFirestore.instance.collection('Reminders');
  var list = await reminderDB
      .where(
        "email",
        isEqualTo: FirebaseAuth.instance.currentUser!.email,
      )
      .get();
  return list.docs.toList();
}

Future<List<QueryDocumentSnapshot>> getMyReminders() async {
  CollectionReference bibliDB = FirebaseFirestore.instance.collection('Reminders');
  var list = await bibliDB
      .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .get();
  return list.docs.toList();
}

Future<bool> removeReminders(String id) async {
  CollectionReference bibliDB = FirebaseFirestore.instance.collection('Reminders');
  try {
    var ref = await bibliDB.doc("$id");
    ref.delete();
    return true;
  } catch (e) {
    return false;
  }
}
