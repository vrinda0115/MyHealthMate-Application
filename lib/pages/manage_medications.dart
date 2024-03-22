import 'package:flutter/material.dart';
import 'package:uipages/components/drawer.dart';
import 'package:uipages/pages/medication_management/home_screen.dart';

class ManageMedication extends StatelessWidget {
  const ManageMedication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.deepPurple[100],
        title: const Text("Manage Medication"),),
      drawer: MyDrawer(),
      body: Container(
        child: const HomeScreen(),
      ),
    );
  }
}