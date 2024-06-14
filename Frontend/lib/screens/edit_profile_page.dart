import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:myfridgeapp/services/service.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Service _service = Service();
  final Logger _logger = Logger('EditProfilePage');
  String _username = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userData = await _service.fetchUserData(_service.userId);
      setState(() {
        _username = userData['Username'];
        _usernameController.text = _username;
      });
    } catch (e) {
      _logger.severe('Error fetching user data: $e');
    }
  }

  final _usernameController = TextEditingController();

  void updateUserProfile(String username) async {
    try {
      await _service.updateUserProfile(username);
      GoRouter.of(context).go('/profile');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update username. Please try again.'),
        ),
      );
       _logger.severe('Error updating username: $e');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
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
