import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:dio/dio.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  final Logger _logger = Logger('ProfilePage');
  void fetchUserData() async {
    try {
      final response = await Dio().post(
        'http://localhost:8000/getUser',
        // Waiting For UserID
        data: {'UserID': 1},
      );
      final userData = response.data;
      if (response.statusCode == 200) {
        setState(() {
          username = userData['Username'];
          email = userData['Email'];
        });
      }
      _logger.info('User data fetched successfully');
      print('User data fetched successfully');
    } catch (e) {
      _logger.severe('Error fetching user data: $e');
      print('Error fetching user data');
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20.0),
          backgroundColor: AppColors.darkblue,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.logout,
                  size: 100.0,
                  color: AppColors.white,
                ),
                const SizedBox(height: 5),
                Text(
                  "Comeback soon",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColors.white,
                      ),
                  // textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  "Are you sure you want to log out?",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(color: AppColors.white),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.darkblue),
                  ),
              child: Text("Cancel",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: AppColors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Perform logout operation here
              },
              style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.white),
                  ),
              child: Text(
                "Log out",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: AppColors.darkblue),
              ),
            ),
          ],
        );
      },
    );
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
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
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
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
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
                              const Icon(Icons.edit),
                              const SizedBox(width: 30),
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
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => context.go("/payment"),
                          child: Row(
                            children: [
                              const Icon(FontAwesomeIcons.crown),
                              const SizedBox(width: 30),
                              Text(
                                'Upgrade Plan',
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
                      const Spacer(),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _showLogoutDialog,
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
