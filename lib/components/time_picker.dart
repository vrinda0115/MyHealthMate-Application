
import "package:flutter/material.dart";

class TimePicker extends StatefulWidget {
  const TimePicker({super.key});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  //create TimeOfDay variable
  TimeOfDay _timeOfDay = TimeOfDay(hour: 8, minute: 30);
  //show time picker method
  
  //show time picker method
  void _showTimePicker() {
    showTimePicker(
     context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState((){
        _timeOfDay = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
       children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: MaterialButton(onPressed: _showTimePicker,
          child: Text('Pick Time ', style: TextStyle(color: Colors.white,fontSize: 20),),
          color: Colors.deepPurple[300],),
        ),

      ] ,
      ),
    );
  }
}