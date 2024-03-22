import 'package:flutter/material.dart';
import 'package:uipages/agora/index.dart';
import 'package:uipages/pages/firebase_api.dart';

class LabReport extends StatelessWidget {
  const LabReport({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Call"),),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => IndexPage()),
            );
          },
          child: Text('Video Calling'),
        ),
      ),


    );
  }
}