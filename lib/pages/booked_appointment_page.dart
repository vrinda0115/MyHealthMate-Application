import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uipages/agora/index.dart';

class BookedAppointmentPage extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const BookedAppointmentPage({Key? key, required this.appointment})
      : super(key: key);

  void _deleteAppointment(BuildContext context, Map<String, dynamic> appointment) async {
  try {
    // Get the current user's email
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    
    // Query the appointments collection based on the current user's email
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('Appointments')
            .where('booked_by', isEqualTo: currentUserEmail)
            .where('year', isEqualTo: appointment['year'])
            .where('month', isEqualTo: appointment['month'])
            .where('day', isEqualTo: appointment['day'])
            .where('hour', isEqualTo: appointment['hour'])
            .where('minute', isEqualTo: appointment['minute'])
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the document ID of the appointment
      String appointmentId = querySnapshot.docs.first.id;
      
      // Delete the appointment
      await FirebaseFirestore.instance
          .collection('Appointments')
          .doc(appointmentId)
          .delete();

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Appointment Cancelled'),
            content: Text('Your appointment has been successfully cancelled.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      throw Exception('Appointment not found for current user');
    }
  } catch (e) {
    // Show error dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to cancel appointment: $e'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}




  @override
  Widget build(BuildContext context) {
    // Extract appointment details
    String bookedBy = appointment['booked_by'];
    int day = appointment['day'];
    int month = appointment['month'];
    int year = appointment['year'];
    int hour = appointment['hour'];
    int minute = appointment['minute'];
    String description = appointment['description'];
    String doctorEmail = appointment['email'];

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Appointment Details"),
        backgroundColor: Colors.deepPurple[100],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: fetchDoctorDetails(doctorEmail),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            var doctorData = snapshot.data?.data();
            String doctorFirstName = doctorData?['first name'] ?? 'Unknown';
            String doctorLastName = doctorData?['last name'] ?? 'Unknown';

            // Construct DateTime object for appointment date
            DateTime appointmentDate = DateTime(year, month, day, hour, minute);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Booked By: $bookedBy"),
                  ), */
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Doctor: $doctorFirstName $doctorLastName"),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text(
                        "Appointment Date: ${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year} ${appointmentDate.hour > 12 ? appointmentDate.hour - 12 : appointmentDate.hour}:${appointmentDate.minute} ${appointmentDate.hour >= 12 ? 'PM' : 'AM'}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.description),
                    title: Text("Description: $description"),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                  onPressed: () {
                   Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IndexPage()),
                        );
                  },
                  child: Text('Start Consultation'),
                ),
                  SizedBox(height: 12),
                  ElevatedButton(
                  onPressed: () {
                    // Delete Appointment
                    _deleteAppointment(context, appointment);

                  },
                  child: Text('Delete Appointment'),
                ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchDoctorDetails(
      String doctorEmail) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('doctors')
              .where('email', isEqualTo: doctorEmail)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        throw Exception('Doctor not found with email: $doctorEmail');
      }
    } catch (e) {
      throw Exception('Failed to fetch doctor details: $e');
    }
  }
}
