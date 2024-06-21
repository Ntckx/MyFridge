import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:myfridgeapp/theme/color_theme.dart';

class TermofServicePage extends StatelessWidget {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  const TermofServicePage({
    super.key,
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkblue),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Wrapper(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 20, 48, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Terms of Service",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColors.darkblue,
                    ),
              ),
              const SizedBox(
                height: 25,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    'By using MyFridge, you agree to our Terms of Service. You are responsible for verifying food expiration dates, as the app assists but does not guarantee accuracy or safety. Freemium users manage up to five items; premium users have unlimited access. We collect and use data per our Privacy Policy, with security measures in place. MyFridge and its content are protected by intellectual property laws and provided "as is" without warranties. We are not liable for any damages from app use. Terms may change, and continued use indicates acceptance. Contact support@myfridgeapp.com for questions.',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.darkblue,
                        ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(
                      '/signup',
                      extra: {
                        'username': username,
                        'email': email,
                        'password': password,
                        'confirmPassword': confirmPassword,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkblue,
                  ),
                  child: Text(
                    'Understood',
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
    );
  }
}
