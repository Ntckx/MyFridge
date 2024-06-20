import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:myfridgeapp/widget/notification_card.dart';
import 'package:myfridgeapp/services/api_service.dart';

class NotificationPage extends StatefulWidget {
  final int userId; // Add this line to accept the user ID

  const NotificationPage({super.key, required this.userId}); // Modify the constructor

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<Map<String, dynamic>>> notifications;

  @override
  void initState() {
    super.initState();
    notifications = ApiService().getNotifications(widget.userId); // Use the user ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: CustomAppBar(
          title: 'Notification',
        ),
      ),
      bottomNavigationBar: const BottomNav(path: "/notifications"),
      backgroundColor: AppColors.blue,
      body: Stack(
        children: [
          Container(
            color: AppColors.blue,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 40, bottom:50),
            // child: const Text(
            //   'Notification',
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 32,
            //   ),
            // ),
          ),
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(60.0),
                ),
              ),
              height: MediaQuery.of(context).size.height - 150,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 50.0, horizontal: 20.0),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: notifications,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No notifications found.',
                          style: TextStyle(color: AppColors.darkblue),));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final notification = snapshot.data![index];
                          return NotificationCard(
                            notificationText: notification['message'],
                          );
                        },
                      );
                    }
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
