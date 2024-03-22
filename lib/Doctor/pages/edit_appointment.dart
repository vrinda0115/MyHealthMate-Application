import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uipages/components/custom_button.dart';
import 'package:uipages/components/time_picker.dart';

class EditAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> appointmentData;

  const EditAppointmentPage({Key? key, required this.appointmentData})
      : super(key: key);

  @override
  _EditAppointmentPageState createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  //create timeoftheday variable
  TimeOfDay _timeOfDay = const TimeOfDay(hour: 8, minute: 30);

  //callback for handling time picking
  void _handleTimePicked(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        // Update _timeOfDay with the picked time
        _timeOfDay = value;
        // Convert selected time to string
        String pickedTime = value.format(context);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Picked Time'),
              content: Text('You picked: ${value.format(context)}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.parse(
        widget.appointmentData['date'] ?? DateTime.now().toIso8601String());

    // Use the integer values directly without parsing
    _selectedTime = TimeOfDay(
        hour: widget.appointmentData['hour'] as int,
        minute: widget.appointmentData['minute'] as int);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimePicker(),
      ),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _saveChanges() async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final String appointmentId = widget.appointmentData[
          'id']; // Assuming 'id' field exists in appointmentData
      await _firestore.collection('Appointments').doc(appointmentId).update({
        'date': _selectedDate.toIso8601String(),
        'hour': _selectedTime.hour,
        'minute': _selectedTime.minute,
      });
      // Show success message or navigate back to previous page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment updated successfully')),
      );
      // Navigate back to previous page
      Navigator.of(context).pop();
    } catch (error) {
      // Show error message if update fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update appointment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: Text('Edit Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            Text('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: MaterialButton(
                onPressed: () => _selectDate(context),
                color: Colors.deepPurple[300],
                child: const Text(
                  'Pick Day ',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('Time: ${_selectedTime.format(context)}'),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: MaterialButton(
                onPressed: () => _handleTimePicked(context),
                color: Colors.deepPurple[300],
                child: const Text(
                  'Pick Time ',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Spacer(),
            CustomButton(
              text: 'Save Changes',
              onTap: _saveChanges,
            ),
          ],
        ),
      ),
    );
  }
}
