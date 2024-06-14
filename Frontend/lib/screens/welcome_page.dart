import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:myfridgeapp/widget/wrapper.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380; // Adjust the breakpoint as needed

    return Scaffold(
      body: Center(
        child: Wrapper(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(48, 20, 48, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'MyFridge',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 50, color: Color(0xFFFFFFFF)),
                ),
                const SizedBox(height: 50),
                Image(
                  image: const AssetImage('assets/LogoMyFridge.png'),
                  height: isSmallScreen ? 200 : 400,
                  width: isSmallScreen ? 200 : 400,
                ),
                const SizedBox(height: 50),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/signin');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkblue,
                    ),
                    child: Text(
                      'Sign in',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.white,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/signup');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.grey,
                    ),
                    child: Text(
                      'Sign up',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.darkblue,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
