import 'package:flutter/material.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:pushy_flutter/pushy_flutter.dart'; // Import Pushy Flutter SDK
import '../api_service.dart';
import 'package:flutter/gestures.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _isNotValidate = false;
  String _errorMessage = '';
  bool _isChecked = false;
  final ApiService _apiService = ApiService();

  bool _isMounted = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _isMounted = false;
    super.dispose();
  }

  Future<void> signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_isChecked) {
        if (_isMounted) {
          setState(() {
            _errorMessage = "You must accept the terms and conditions";
          });
        }
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        if (_isMounted) {
          setState(() {
            _errorMessage = "Passwords do not match";
          });
        }
        return;
      }

      try {
        String? pushyToken = await Pushy.register();

        if (pushyToken == null || pushyToken.isEmpty) {
          if (_isMounted) {
            setState(() {
              _errorMessage = "Failed to register for Pushy notifications.";
            });
          }
          return;
        }

        final response = await _apiService.signUp(
          usernameController.text,
          emailController.text,
          passwordController.text,
          pushyToken,
        );
        print('User created: $response');
        if (_isMounted) {
          context.go('/signin');
        }
      } catch (error) {
        if (_isMounted) {
          setState(() {
            if (error is DioException && error.response != null) {
              if (error.response?.statusCode == 400) {
                _errorMessage = error.response?.data['msg'];
              } else {
                _errorMessage = 'Server error: ${error.response?.statusCode}';
              }
            } else {
              _errorMessage = 'Unexpected error: $error';
            }
          });
        }
        print('Error: $error');
      }
    } else {
      if (_isMounted) {
        setState(() {
          _isNotValidate = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            context.go('/welcome');
          },
        ),
      ),
      body: Stack(
        children: [
          const Wrapper(
            child: Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create',
                    style: TextStyle(fontSize: 50, color: Color(0xFFFFFFFF)),
                  ),
                  Text(
                    'Account',
                    style: TextStyle(fontSize: 50, color: Color(0xFFFFFFFF)),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 180),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Wrapper(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(48, 20, 48, 20),
                            child: Form(
                              key: _formKey,
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
                                  const SizedBox(height: 2),
                                  TextFormField(
                                    controller: usernameController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: "Username",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter correct name';
                                      }
                                      if (!RegExp(r'^[a-zA-Z]+$')
                                          .hasMatch(value)) {
                                        return 'Only alphabetical characters are allowed';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "Email",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.green),
                                  ),
                                  const SizedBox(height: 2),
                                  TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: "Email",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter correct email address';
                                      }
                                      final emailRegex = RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "Password",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.green),
                                  ),
                                  const SizedBox(height: 2),
                                  TextFormField(
                                    controller: passwordController,
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      final RegExp passwordRegExp = RegExp(
                                        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$',
                                      );
                                      if (!passwordRegExp.hasMatch(value)) {
                                        return 'Password must include at least one letter, one number, and one special character';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "Confirm Password",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.green),
                                  ),
                                  const SizedBox(height: 2),
                                  TextFormField(
                                    controller: confirmPasswordController,
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: "Confirm Password",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (value != passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _isChecked,
                                        onChanged: (bool? value) {
                                          if (_isMounted) {
                                            setState(() {
                                              _isChecked = value ?? false;
                                            });
                                          }
                                        },
                                        activeColor: AppColors.darkblue,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "By signing up to an account you accept the ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color:
                                                              AppColors.green),
                                                ),
                                                TextSpan(
                                                  text: "terms and conditions",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        color: AppColors.green,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          context.go(
                                                              '/termofservice');
                                                        },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_errorMessage.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        _errorMessage,
                                        style: const TextStyle(
                                            color: AppColors.red),
                                      ),
                                    ),
                                  const SizedBox(height: 30),
                                  SizedBox(
                                    height: 45,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: signUp,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.darkblue,
                                      ),
                                      child: Text(
                                        'Sign Up',
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
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
