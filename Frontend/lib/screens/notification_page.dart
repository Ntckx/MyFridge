import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import '../theme/color_theme.dart';
import '../widget/notification_card.dart'; // Import the NotificationCard widget

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mocked notifications data
    final List<String> notifications = [
      'Your milk is about to expire in 2 days.',
      'Your egg is about to expire in 1 day',
      'Your meat is about to expire in 5 days',
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(80.0), // Set your desired height here
        child: CustomAppBar(
          title: 'MyFridge',
          height: 80.0, // Ensure the height is set here as well
        ),
      ),
      bottomNavigationBar: const BottomNav(path: "/notifications"),
      backgroundColor: AppColors.blue,
      body: Stack(
        children: [
          Container(
            color: AppColors.blue,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(
                top: 10), // Add padding to position the text
            child: const Text(
              'Notification',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 60, // Adjust this value to increase the blue area
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                      60.0), // Change this to your desired radius
                ),
              ),
              height: MediaQuery.of(context).size.height -
                  150, // Adjust height as needed
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return NotificationCard(
                        notificationText: notifications[index]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
