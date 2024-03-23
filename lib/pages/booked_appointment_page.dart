import 'package:flutter/material.dart';

class BookedAppointmentPage extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const BookedAppointmentPage({super.key, required this.appointment});
  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text("Appointment Details"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Appointment Title: ${appointment['title']}"),
            Text("Appointment Date: ${appointment['dateTime'].toDate()}"),
            ElevatedButton(
              onPressed: () {
                // Start consultation action
              },
              child: Text("Start Consultation"),
            ),
            ElevatedButton(
              onPressed: () {
                // Delete appointment action
              },
              child: Text("Delete Appointment"),
            ),
          ],
        ),
      ),
    );
  }
}