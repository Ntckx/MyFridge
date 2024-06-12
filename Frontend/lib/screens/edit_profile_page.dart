import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String _username = '';

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
          _username = userData['Username'] ?? '';
          _usernameController.text = _username;
        });
      }
      print('User data fetched successfully');
    } catch (e) {
      print('Error fetching user data $e');
    }
  }

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  final _usernameController = TextEditingController();

  void updateUserProfile(String username) async {
    try {
      final response = await Dio().patch(
        'http://localhost:8000/updateUsername',
        data: {
          // Waiting For UserID
          'UserId': 1,
          'Username': username,
        },
      );
      if (response.statusCode == 200) {
        GoRouter.of(context).go('/profile');
        // _logger.info('User data updated successfully');
        print('Updated user data successfully');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update username. Please try again.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
      // _logger.severe('Error patch user data: $e');
      print('Error update username $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '',
      ),
      bottomNavigationBar: const BottomNav(path: "/editprofile"),
      body: Wrapper(
          child: Stack(children: [
        Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Edit Profile",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: AppColors.white)),
                    const SizedBox(height: 20),
                    Text("Username",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: AppColors.white)),
                    const SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(color: AppColors.darkblue),
                      decoration: const InputDecoration(
                        hintText: 'Enter your username',
                      ),
                      onChanged: (value) => {
                        setState(() {
                          _username = value;
                        })
                      },
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          updateUserProfile(_username);
                        },
                        child: Text(
                          'Save Changes',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppColors.white,
                                  ),
                        ),
                      ),
                    ),
                  ],
                )),
            const Spacer(),
          ],
        ),
      ])),
    );
  }
}
