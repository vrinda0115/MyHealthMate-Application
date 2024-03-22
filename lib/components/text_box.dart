import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String sectionName;
  final TextEditingController controller;
  final void Function()? onPressed;
  final void Function(String)? onChanged;

  const MyTextBox({
    Key? key,
    required this.sectionName,
    required this.controller,
    this.onPressed,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.only(left: 15, bottom: 15),
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Section name
                Text(
                  sectionName,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            // Text Field
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                enabled: onPressed != null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}