import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/navbar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String username;
  late String email;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() {
    // Simulate fetching data from a backend
    Map<String, String> userData = getMockUserData();
    setState(() {
      username = userData['username']!;
      email = userData['email']!;
    });
  }

  Map<String, String> getMockUserData() {
    // Mock user data
    return {
      'username': 'JohnDoe',
      'email': 'john.doe@example.com',
    };
  }

  @override
  Widget build(BuildContext context) {
    String username = this.username;
    String email = this.email;

    return Scaffold(
      appBar: const CustomAppBar(
        title: '',
      ),
      bottomNavigationBar: const BottomNav(path: "/profile"),
      body: Stack(
        children: [
          Wrapper(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: AppColors.white,
                              ),
                    ),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.darkblue,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 130),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Wrapper(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(48, 20, 48, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => context.go("/editprofile"),
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 30),
                              Text(
                                'Edit Profile',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: AppColors.darkblue,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                          ),
                          child: Text(
                            'Log out',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: AppColors.white,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
