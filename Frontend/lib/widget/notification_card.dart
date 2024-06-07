import 'package:flutter/material.dart';
import '../theme/color_theme.dart';

class NotificationCard extends StatelessWidget {
  final String notificationText;

  const NotificationCard({required this.notificationText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        Expanded(
          child: Container(
            height: 80,
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  notificationText,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
