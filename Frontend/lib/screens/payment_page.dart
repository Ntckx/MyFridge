import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/widget/plan_list.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> initPaymentSheet(Map<String, dynamic> paymentIntent) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: 'MyFridgeApp',
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'TH',
            currencyCode: 'THB',
            testEnv: true,
          ),
        ),
      );
    } catch (e) {
      print('Error initializing payment sheet: $e');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
        updateUserPremiumStatus();
      });
    } catch (e) {
      print('$e');
    }
  }

  void updateUserPremiumStatus() async {
    try {
      final response = await Dio().patch(
        'http://localhost:8000/updatePremium',
        data: {
          // Waiting For UserID
          'UserId': 1,
          'isPremium': true,
        },
      );
      print('User premium status updated successfully');
    } catch (e) {
      print('Error updating user premium status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '',
      ),
      bottomNavigationBar: const BottomNav(path: "/payment"),
      body: Stack(
        children: [
          Wrapper(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
            child: Column(children: [
              Text(
                'Upgrade',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColors.white,
                    ),
              ),
            ]),
          )),
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
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Premium',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: AppColors.darkblue,
                            ),
                      ),
                      const Column(
                        children: [
                          SizedBox(height: 20),
                          PlanList(
                            iconData: Icons.check_circle_rounded,
                            text: 'Create unlimited item in your inventory',
                          ),
                          PlanList(
                            iconData: Icons.check_circle_rounded,
                            text:
                                'Unlocked all features choco signature layer custom',
                          ),
                          PlanList(
                            iconData: Icons.check_circle_rounded,
                            text: 'Unlimited storage',
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              var paymentIntent =
                                  await createPaymentIntent('5000', 'thb');
                              var currentContext = context;
                              if (kIsWeb) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Payment available only in the mobile app.'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              } else {
                                await initPaymentSheet(paymentIntent);
                                await displayPaymentSheet();

                                if (currentContext.mounted) {
                                  currentContext.go('/profile');
                                }
                              }
                            } catch (e) {
                              print('Error: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Payment failed'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          child: Text(
                            '50 baht/month after*',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: AppColors.white,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
