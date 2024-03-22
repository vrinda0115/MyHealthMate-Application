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

/* Future<void> getUserInfo() async {
  try {
    // Access the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    
    // Get a reference to the users collection
    CollectionReference users = firestore.collection('users');
    
    // Query for specific user document
    DocumentSnapshot userSnapshot = await users.doc('user_id').get();
    
    // Check if the user document exists
    if (userSnapshot.exists) {
      // Retrieve user data
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        // Access user fields
        String userName = userData['name'];
        String userEmail = userData['email'];
        
        // Do something with the user data
        print('User Name: $userName');
        print('User Email: $userEmail');
      } else {
        print('User data is null');
      }
    } else {
      print('User document does not exist');
    }
  } catch (e) {
    print('Error getting user info: $e');
  }
} */


/* Future<QuerySnapshot<Object?>> getUsers() async {
  CollectionReference db =
        FirebaseFirestore.instance.collection('users');
 final docRef = db.collection("cities").doc("SF");
docRef.get().then(
  (DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    // ...
  },
  onError: (e) => print("Error getting document: $e"),
);
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
