import 'package:flutter/material.dart';
import '../theme/color_theme.dart';

class NotificationCard extends StatelessWidget {
  final String notificationText;

  const NotificationCard({super.key, required this.notificationText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10), // Adjust this value for more spacing
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 10,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            Expanded(
              child: Container(
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      notificationText,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.darkblue,
                          ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

