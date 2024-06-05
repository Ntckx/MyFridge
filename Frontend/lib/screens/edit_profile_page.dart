import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/navbar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:myfridgeapp/theme/custom_theme.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '',
      ),
      bottomNavigationBar: const BottomNav(path: "/editprofile"),
      body: Wrapper(
          child: Column(
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
                    height: 2,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      // labelText: 'Username',
                      // labelStyle: TextStyle(
                      //   color: AppColors.darkblue,
                      // ),
                      hintText: 'Enter your username',
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Save Changes',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: AppColors.white,
                            ),
                      ),
                    ),
                  ),
                ],
              )),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/LogoMyFridge.png',
                width: 200,
                height: 200,
              ),
            ],
          )
        ],
      )),
    );
  }
}
