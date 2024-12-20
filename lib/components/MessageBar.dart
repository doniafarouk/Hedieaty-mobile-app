import 'package:flutter/material.dart';

class CustomMessageBar extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;

  CustomMessageBar({
    required this.message,
    this.backgroundColor = Colors.green,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      color: backgroundColor,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: textColor),
          SizedBox(width: 10),
          Text(
            message,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
