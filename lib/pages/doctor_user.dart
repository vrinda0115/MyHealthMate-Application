import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:uipages/components/buttons.dart';
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
              height: 100,
              width:250,
              child: ElevatedButton(
                  
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AuthPage()),
                    );
                      },
                  
                  child: Text('Doctor Login'),),
            ),
          ),
          
          //user Button to login and registeration
          SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to user login screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AuthPage()),
                  );
                },
                child: Text('User Login',style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            )
          
          ],
        ),
      )
          
    );
  }
}