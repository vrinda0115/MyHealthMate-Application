import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final VoidCallback onTap;
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.backgroundColor = const Color.fromRGBO(149, 117, 205, 1),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      height: 60,
      textColor: Colors.white,
      color: backgroundColor,
      onPressed: onTap,
      child: Text(
        "$text",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
