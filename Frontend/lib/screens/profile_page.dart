import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:myfridgeapp/services/service.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  final int userId;
  const ProfilePage({super.key, required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Service _service = Service();
  String username = '';
  String email = '';
  bool isPremium = false;
  final Logger _logger = Logger('ProfilePage');
  String? token;

  @override
  void initState() {
    super.initState();
    _getToken();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userData = await _service.fetchUserData(widget.userId);
      setState(() {
        username = userData['Username'];
        email = userData['Email'];
        isPremium = userData['isPremium'];
      });
    } catch (e) {
      _logger.severe('Error fetching user data: $e');
    }
  }

  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      if (token != null) {
        print("TokenData: $token");
      } else {
        _logger.severe('Token is null');
      }
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
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
                    side: WidgetStateProperty.all<BorderSide>(
                      const BorderSide(color: AppColors.white),
                    ),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(AppColors.darkblue),
                  ),
              child: Text(
                "Cancel",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: AppColors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await logout();
                context.go('/');
              },
              style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(AppColors.white),
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
                  Row(
                    children: [
                      Text(
                        username,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: AppColors.white,
                            ),
                      ),
                      const SizedBox(width: 10),
                      if (isPremium == true)
                        const Icon(FontAwesomeIcons.crown,
                            color: AppColors.yellow),
                    ],
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
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => context.go("/home/editprofile"),
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
                          onPressed: () => context.go("/home/payment"),
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
