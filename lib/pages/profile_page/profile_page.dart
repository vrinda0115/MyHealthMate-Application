// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  //current logged in user
  final user = FirebaseAuth.instance.currentUser;
  

  //future to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.deepPurple[100],
      ),
      backgroundColor: Colors.grey[300],
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //error
          else if (snapshot.hasError) {
            return Text("Error:  ${snapshot.error}");
          }
          //data received
          else if (snapshot.hasData) {
            // Extract data
            Map<String, dynamic>? user = snapshot.data!.data();
            if (user != null) {
              return Column(
                children: [
                  Text(user['email'] ?? 'No email'), // Ensure email is not null
                  Text(user['first name'] ??
                      'No first name'), // Ensure first name is not null
                ],
              );
            } else {
              return Text('No user data');
            }
          } else {
            return Text('No data');
          }
        },
      ),
    );
  }
}
