import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:myfridgeapp/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:myfridgeapp/widget/wrapper.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  String _errorMessage = '';
  final ApiService _apiService = ApiService();

  bool _isMounted = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _isMounted = false;
    super.dispose();
  }

  Future<void> signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final response = await _apiService.signIn(
          emailController.text,
          passwordController.text,
        );
        final userId = response['userId'];
        if (_isMounted) {
          context.go('/home', extra: userId);
        }
      } catch (error) {
        if (_isMounted) {
          setState(() {
            if (error is DioError && error.response != null) {
              if (error.response?.statusCode == 400) {
                _errorMessage = error.response?.data['message'];
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
            context.go('/');
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
                    'Sign In',
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
                                          r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$');
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
                                      return null;
                                    },
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
                                      onPressed: signIn,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.darkblue,
                                      ),
                                      child: Text(
                                        'Sign In',
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
