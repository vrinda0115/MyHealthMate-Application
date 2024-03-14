// ignore_for_file: must_be_immutable


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:uipages/components/text_box.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final user = FirebaseAuth.instance.currentUser;
  //final String documentId;
    
    // edit field
    Future editField(String s) async {

    }
  //future to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email!)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple[100],
      ),
      backgroundColor: Colors.grey[300],
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance.collection('users').snapshots(), builder: (BuildContext context,snapshot) { 

      //     // get user data
      //     List<Row> userWidgets = [];
      //       if (!snapshot.hasData){
      //         const CircularProgressIndicator();
      //       }else{
      //         final users = snapshot.data?.docs.reversed.toList();
      //         for (var user in users!){
      //           final userWidgets = Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Text(user['first name']),
      //               Text(user['last name']),
      //               Text(user['age'].toString()),
      //             ],
      //           );
      //         }
      //       }
          
      //       ListView(
      //         children: userWidgets,
      //       );
          
      //   },

      // ),
    );
  }
}


