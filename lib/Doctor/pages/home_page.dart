import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uipages/components/drawerdoc.dart';

class HomePageDoctor extends StatefulWidget {
  const HomePageDoctor({Key? key}) : super(key: key);

  @override
  State<HomePageDoctor> createState() => _HomePageDoctorState();
}

class _HomePageDoctorState extends State<HomePageDoctor> {
  late Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && mounted) {
      final usersCollection =
          FirebaseFirestore.instance.collection('doctors');
      final querySnapshot = await usersCollection
          .where('email', isEqualTo: currentUser.email)
          .get();
      if (querySnapshot.docs.isNotEmpty && mounted) {
        final userDataMap = querySnapshot.docs.first.data();
        setState(() {
          userData = {
            'firstName': userDataMap['first name'] ?? '',
            'lastName': userDataMap['last name'] ?? '',
          };
        });
      }
    }
  } catch (e) {
    print('Error fetching user info: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: Text(
          'Hello, ${userData['firstName'] ?? 'User'} ${userData['lastName'] ?? ''}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const MyDrawerDoc(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 25),
              Center(
                child: Image.asset(
                  'lib/icons/doctor.png',
                  height: 100,
                  width: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
