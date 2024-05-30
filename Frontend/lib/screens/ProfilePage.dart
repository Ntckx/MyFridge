import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/NavBar.dart';
import 'package:myfridgeapp/widget/CustomAppBar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
      ),
      bottomNavigationBar: const BottomNav(path: "/profile"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("This is the profile page"),
          ],
        ),
      ),
    );
  }
}