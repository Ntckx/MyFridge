import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/navbar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/widget/wrapper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
      ),
      bottomNavigationBar: BottomNav(path: "/profile"),
      body: Wrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("This is the profile page"),
          ],
        ),
      ),
    );
  }
}