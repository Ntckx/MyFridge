import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:myfridgeapp/theme/color_theme.dart';

class TermofServicePage extends StatelessWidget {
  const TermofServicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.darkblue),
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
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
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
                    // Handle the button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkblue,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/signup');
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
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}