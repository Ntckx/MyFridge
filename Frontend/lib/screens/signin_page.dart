import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> signin() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };
      try {
        Response response = await Dio().post(
          'http://localhost:8000/login',
          data: jsonEncode(regBody),
          options: Options(
            headers: {"content-type": "application/json"},
            validateStatus: (status) {
              return status != null && status < 500;
            },
          ),
        );
        if (response.statusCode == 200) {
          var jsonResponse = response.data;
          if (jsonResponse['status']) {
            var myToken = jsonResponse['token'];
            prefs.setString('token', myToken);
            context.go('/home', extra: myToken);
          } else {
            print('Something went wrong: ${jsonResponse['message']}');
          }
        } else {
          print('Failed with status code: ${response.statusCode}');
          print('Response data: ${response.data}');
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
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
                        "Email",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: AppColors.green),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "email",
                          errorText: _isNotValidate ? "Enter Proper Info" : null,
                        ),
                      ),
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
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "password",
                          errorText: _isNotValidate ? "Enter Proper Info" : null,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: signin,
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
