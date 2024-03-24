import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uipages/Doctor/pages/ManageAppointments.dart';
import 'package:uipages/Doctor/pages/home_page.dart';
import 'package:uipages/Doctor/pages/profilepage/profile_page_doc.dart';
import 'package:uipages/pages/doctor_user.dart';
//import 'package:uipages/pages/home_page1.dart';
//import 'package:uipages/pages/lab_reports.dart';
//import 'package:uipages/pages/manage_medications.dart';


class MyDrawerDoc extends StatelessWidget {
  const MyDrawerDoc({super.key});

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
                            return HomePageDoctor();
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
                            return DoctorProfilePage();
                          }));
            },
          ),
        ),


        //Manage Appointments
        const SizedBox(height: 25,),
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: ListTile(
            leading: const Icon(Icons.medication, size:40),
            title: const Text(
            'M A N A G E \nA P P O I N T M E N T S',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context){
                            return  AppointmentManagementPage();
                          }));
            },
          ),
        ),
        // //Lab Reports
        // const SizedBox(height: 25,),
        // Padding(
        //   padding: const EdgeInsets.only(left: 25.0),
        //   child: ListTile(
        //     leading: const Icon(Icons.notes, size:40),
        //     title: const Text(
        //     '',
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontWeight: FontWeight.bold),
        //     ),
        //     onTap: () {
        //       Navigator.pop(context);
        //       Navigator.push(context, MaterialPageRoute(builder: (context){
        //                     return LabReport();
        //                   }));
        //     },
        //   ),
        // ),
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