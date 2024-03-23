import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uipages/components/custom_button.dart';
import 'package:uipages/components/time_picker.dart';
import 'package:uipages/pages/medication_management/messages.dart';

class EditAppointmentPage extends StatefulWidget {
  final DocumentReference appointmentRef;
  final Map<String, dynamic> appointmentData;

  const EditAppointmentPage({
    Key? key,
    required this.appointmentRef,
    required this.appointmentData,
  }) : super(key: key);

  @override
  _EditAppointmentPageState createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.parse(
      widget.appointmentData['date'] ?? DateTime.now().toIso8601String(),
    );
    _selectedTime = TimeOfDay(
      hour: widget.appointmentData['hour'] as int,
      minute: widget.appointmentData['minute'] as int,
    );
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

  Future<void> _deleteAppointment() async {
    try {
      await widget.appointmentRef.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment deleted successfully')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      Message.showError(context, "Unable to delete appointment");
    }
  }

  Future<void> _saveChanges() async {
    try {
      await widget.appointmentRef.update({
        'date': _selectedDate.toIso8601String(),
        'hour': _selectedTime.hour,
        'minute': _selectedTime.minute,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment updated successfully')),
      );
      Navigator.of(context).pop();
    } catch (error) {
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
                onPressed: () => _selectTime(context),
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
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: CustomButton(
                backgroundColor: Color(0xFFD11B1B),
                text: "Delete",
                onTap: _deleteAppointment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
