import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Appointment {
  final String id;
  final DateTime date;
  final TimeOfDay time;
  final String patientEmail;
  final String doctorEmail;

  Appointment({
    required this.id,
    required this.date,
    required this.time,
    required this.patientEmail,
    required this.doctorEmail,
  });

  // Convert Appointment object to Map
  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'time': '${time.hour}:${time.minute}', // Store time as string
      'patient': patientEmail,
      'email': doctorEmail,
    };
  }

  // Create Appointment object from Firestore document snapshot
  static Appointment fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Appointment(
      id: snapshot.id,
      date: (data['date'] as Timestamp).toDate(),
      time: TimeOfDay(
        hour: int.parse(data['time'].split(':')[0]),
        minute: int.parse(data['time'].split(':')[1]),
      ),
      patientEmail: data['patient'],
      doctorEmail: data['email'],
    );
  }

  final CollectionReference _appointmentsCollection =
      FirebaseFirestore.instance.collection('Appointments');

  Future<void> addAppointment(Appointment appointment) async {
    await _appointmentsCollection.add(appointment.toMap());
  }

  Future<List<Appointment>> getAppointments(String doctorEmail) async {
  final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _appointmentsCollection
          .where('email', isEqualTo: doctorEmail)
          .orderBy('date')
          .orderBy('time')
          .get() as QuerySnapshot<Map<String, dynamic>>; // Explicit cast
  return querySnapshot.docs
      .map((doc) => Appointment.fromSnapshot(doc))
      .toList();
}


  Future<void> updateAppointment(Appointment appointment) async {
    await _appointmentsCollection
        .doc(appointment.id)
        .update(appointment.toMap());
  }

  Future<void> deleteAppointment(String appointmentId) async {
    await _appointmentsCollection.doc(appointmentId).delete();
  }
}
