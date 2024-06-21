
import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:myfridgeapp/widget/notification_card.dart';
import 'package:myfridgeapp/services/api_service.dart';

class NotificationPage extends StatefulWidget {
  final int userId;

  const NotificationPage({super.key, required this.userId});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  late Future<List<Map<String, dynamic>>> notifications;

  @override
  void initState() {
    super.initState();
    notifications = ApiService().getNotifications(widget.userId);
  }

  List<Map<String, dynamic>> deduplicateNotifications(List<Map<String, dynamic>> notifications) {
    final seenMessages = <String>{};
    return notifications.where((notification) {
      final message = notification['message'];
      if (seenMessages.contains(message)) {
        return false;
      } else {
        seenMessages.add(message);
        return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80.0),
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
            padding: const EdgeInsets.only(left: 40, bottom: 50),
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
                padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: notifications,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No notifications found.',
                          style: TextStyle(color: AppColors.darkblue),
                        ),
                      );
                    } else {
                      final uniqueNotifications = deduplicateNotifications(snapshot.data!);

                      return ListView.builder(
                        itemCount: uniqueNotifications.length,
                        itemBuilder: (context, index) {
                          final notification = uniqueNotifications[index];
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