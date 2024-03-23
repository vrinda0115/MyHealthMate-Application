import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uipages/agora/index.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final String appointmentId;
  final Map<String, dynamic> appointment;

  const AppointmentDetailsPage({
    Key? key,
    required this.appointmentId,
    required this.appointment,
  }) : super(key: key);

  Future<void> _deleteAppointment(BuildContext context, Map<String, dynamic> appointment) async {
  try {
    final appointmentsCollection = FirebaseFirestore.instance.collection('Appointments');
    final querySnapshot = await appointmentsCollection
        .where('email', isEqualTo: appointment['email'])
        .where('year', isEqualTo: appointment['year'])
        .where('month', isEqualTo: appointment['month'])
        .where('day', isEqualTo: appointment['day'])
        .where('hour', isEqualTo: appointment['hour'])
        .where('minute', isEqualTo: appointment['minute'])
        .where('booked_by', isEqualTo: appointment['booked_by'])
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final appointmentId = querySnapshot.docs.first.id;
      await appointmentsCollection.doc(appointmentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment deleted successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate back to the previous page after deleting appointment
      Navigator.pop(context);
    } else {
      print('Appointment not found.');
    }
  } catch (error) {
    print('Error deleting appointment: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error deleting appointment. Please try again later.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final appointmentDateTime = DateTime(
      appointment['year'],
      appointment['month'],
      appointment['day'],
      appointment['hour'],
      appointment['minute'],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${_formatDateTime(appointmentDateTime)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Patient Email: ${appointment['booked_by']}'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                ElevatedButton(
                  onPressed: () {
                    // Delete Appointment
                    _deleteAppointment(context, appointment);

                  },
                  child: Text('Delete Appointment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}, ${_formatTime(dateTime)}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final amPm = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $amPm';
  }
}
