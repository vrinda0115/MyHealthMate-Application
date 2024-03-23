import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uipages/pages/booked_appointment_page.dart';

class LabReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booked Appointments"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBookedAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            List<Map<String, dynamic>> appointments = snapshot.data ?? [];
            return appointments.isEmpty
                ? Center(child: Text("No appointments found"))
                : ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> appointment = appointments[index];
                      DateTime dateTime = appointment['dateTime'].toDate();
                      String title = appointment['title'];

                      return ListTile(
                        title: Text(title),
                        subtitle: Text(dateTime.toString()),
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
                      );
                    },
                  );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchBookedAppointments() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Appointments')
              .orderBy('dateTime', descending: true)
              .get();

      List<Map<String, dynamic>> appointments =
          querySnapshot.docs.map((doc) => doc.data()).toList();
      return appointments;
    } catch (e) {
      throw Exception('Failed to fetch appointments: $e');
    }
  }
}
