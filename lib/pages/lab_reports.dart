import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uipages/pages/booked_appointment_page.dart';

class LabReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Booked Appointments"),
        backgroundColor: Colors.deepPurple[100],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Appointments')
            .where('booked_by', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .orderBy('year', descending: true)
            .orderBy('month', descending: true)
            .orderBy('day', descending: true)
            .orderBy('hour', descending: true)
            .orderBy('minute', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            List<Map<String, dynamic>> appointments = snapshot.data!.docs.map((doc) => doc.data()).toList();
            return appointments.isEmpty
                ? Center(child: Text("No appointments found"))
                : ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> appointment = appointments[index];
                      int year = appointment['year'];
                      int month = appointment['month'];
                      int day = appointment['day'];
                      int hour = appointment['hour'];
                      int minute = appointment['minute'];
                      String title = appointment['email'];

                      // Construct DateTime object
                      DateTime dateTime =
                          DateTime(year, month, day, hour, minute);

                      return Card(
                        color: Colors.deepPurple[200],
                        child: ListTile(
                          title: Text(title),
                          subtitle: Text(
                              "Appointment Date: ${_formatDateTime(dateTime)}"),
                          onTap: () {
                            // Navigate to appointment details page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookedAppointmentPage(
                                  appointment: appointment,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
          }
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    String amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
    int hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    String formattedMinute =
        dateTime.minute < 10 ? '0${dateTime.minute}' : '${dateTime.minute}';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${hour}:${formattedMinute} $amPm';
  }
}
