import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:uipages/components/buttons.dart';
import 'package:uipages/Doctor/auth/auth_doctor.dart';
import 'package:uipages/pages/Auth/auth_page.dart';


class DoctorOrUser extends StatefulWidget {

  const DoctorOrUser({super.key });

  @override
  State<DoctorOrUser> createState() => _DoctorOrUserState();
}

class _DoctorOrUserState extends State<DoctorOrUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: 
        Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          //Doctors Button to login and registeration
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SizedBox(
              height: 50,
              width:150,
              child: ElevatedButton(
                  
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AuthPageDoc()),
                    );
                      },
                  
                  child: const Text('Doctor Login'),),
            ),
          ),
          
          //user Button to login and registeration
          const SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                height: 50,
                width:150,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to user login screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthPage()),
                    );
                  },
                  child: const Text('User Login',style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
            )
          
          ],
        ),
      )
          
    );
  }
}