import 'package:flutter/material.dart';
import 'package:uipages/components/drawerdoc.dart';

class ManageAppointements extends StatelessWidget {
  const ManageAppointements({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.deepPurple[100],
        title: const Text("Manage Appointments"),),
      drawer: const MyDrawerDoc(),
      body: Container(
        
    )
    
  );
  }
}