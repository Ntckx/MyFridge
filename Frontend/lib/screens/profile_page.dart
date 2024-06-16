import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  String? email;
  bool isPremium = false;
  final ApiService _apiService = ApiService();
  final int _userId = 1; // Use a mock user ID for testing

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final userData = await _apiService.getUserById(_userId);
      setState(() {
        username = userData['Username'];
        email = userData['Email'];
        isPremium = userData['isPremium'] == true;
      });
    } catch (e) {
      print('Error fetching user data: $e');
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
                ),
                const SizedBox(height: 5),
                Text(
                  "Are you sure you want to log out?",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.white,
                      ),
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
                  if (username != null && email != null) ...[
                    Text(
                      username!,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: AppColors.white),
                    ),
                    Text(
                      email!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: AppColors.darkblue),
                    ),
                  ] else ...[
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading...',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: AppColors.white),
                    ),
                  ],
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
                                    .copyWith(color: AppColors.darkblue),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => context.go("/payment"),
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.crown),
                              SizedBox(width: 30),
                              Text(
                                'Upgrade Plan',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: AppColors.darkblue),
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
                          onPressed: _showLogoutDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                          ),
                          child: Text(
                            'Log out',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: AppColors.white),
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
