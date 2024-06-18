import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:myfridgeapp/theme/color_theme.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          const Wrapper(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 50, color: Color(0xFFFFFFFF)),
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
                  padding: const EdgeInsets.fromLTRB(48, 20, 48, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: AppColors.green),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TextFormField(),
                      const SizedBox(
                        height: 15,
                        width: double.infinity,
                      ),
                      Text(
                        "Password",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: AppColors.green),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TextFormField(),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkblue,
                          ),
                          child: Text(
                            'Sign in',
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
