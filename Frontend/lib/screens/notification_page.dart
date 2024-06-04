import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/navbar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/widget/wrapper.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
      ),
      bottomNavigationBar: BottomNav(path: "/notifications"),
      body: Wrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("This is the notification page"),
          ],
        ),
      ),
    );
  }
}
