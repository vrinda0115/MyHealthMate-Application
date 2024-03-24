import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uipages/pages/doctor_user.dart';
import 'package:uipages/pages/home_page1.dart';
import 'package:uipages/pages/lab_reports.dart';
import 'package:uipages/pages/manage_medications.dart';
import 'package:uipages/pages/profile_page/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

 // Sign user out method
  void signUserOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the doctor or user page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DoctorOrUser()),
      );
    } catch (e) {
      print('Error signing out: $e');
      // Handle sign out errors if needed
    }
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Column(
          children: [
            //Drawer header
        const DrawerHeader(
          child: Icon(Icons.star_border_purple500_sharp, size: 50,color: Colors.deepPurple,)
          ),

        // Home
        const SizedBox(height: 25,),
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: ListTile(
            leading: const Icon(Icons.home, size:40),
            title: const Text(
            'H O M E',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context){
                            return HomePagee();
                          }));
            },
          ),
        ),

        //Users tile
        const SizedBox(height: 25,),
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: ListTile(
            leading: const Icon(Icons.person, size:40),
            title: const Text(
            'P R O F I L E',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ProfilePage();
                          }));
            },
          ),
        ),


        //Manage Medications
        const SizedBox(height: 25,),
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: ListTile(
            leading: const Icon(Icons.medication, size:40),
            title: const Text(
            'M A N A G E \nM E D I C A T I O N S',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ManageMedication();
                          }));
            },
          ),
        ),
         //Lab Reports
        const SizedBox(height: 25,),
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: ListTile(
            leading: const Icon(Icons.notes, size:40),
            title: const Text(
            'B O O K  \nA P P O I N T M E N T S',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context){
                            return LabReport();
                          }));
            },
          ),
        ), 
        ],
        ),
        
        
        //Log out
        const SizedBox(height: 25,),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, bottom: 25),
          child: ListTile(
            leading: const Icon(Icons.medication, size:40),
            title: const Text(
            'L O G O U T',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);

              //logout
              signUserOut(context);
            },
          ),
        ),
      ],)
    );
  }
}