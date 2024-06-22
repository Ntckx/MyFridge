import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:myfridgeapp/widget/wrapper.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;

    return Scaffold(
      body: Center(
        child: Wrapper(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(48, 50, 48, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'MyFridge',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 50, color: Color(0xFFFFFFFF)),
                  ),
                  const SizedBox(height: 60),
                  Image(
                    image: const AssetImage('assets/logo3.png'),
                    height: isSmallScreen ? 200 : 320,
                    width: isSmallScreen ? 200 : 320,
                  ),
                  const SizedBox(height: 65),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint('Navigating to Signin');
                        try {
                          context.go('/signin');
                        } catch (e) {
                          debugPrint('Error during navigation: $e');
                        }
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
                        debugPrint('Navigating to Signup');
                        try {
                          context.go('/signup');
                        } catch (e) {
                          debugPrint('Error during navigation: $e');
                        }
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
      ),
    );
  }
}
