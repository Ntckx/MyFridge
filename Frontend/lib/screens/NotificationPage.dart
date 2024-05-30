import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/NavBar.dart';
import 'package:myfridgeapp/widget/CustomAppBar.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
      ),
      bottomNavigationBar: const BottomNav(path: "/notifications"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("This is the notification page"),
          ],
        ),
      ),
    );
  }
}
