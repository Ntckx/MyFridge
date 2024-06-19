import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:myfridgeapp/services/service.dart';
import 'package:myfridgeapp/widget/plan_list.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class PaymentPage extends StatefulWidget {
  final int userId;
  const PaymentPage({super.key, required this.userId});

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  final Service _service = Service();
  final Logger _logger = Logger('PaymentPage');
  bool isPremium = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _handlePayment(BuildContext context) async {
    try {
      final paymentIntent = await _service.createPaymentIntent('5000', 'thb');
      await _service.initPaymentSheet(paymentIntent);
      await _service.displayPaymentSheet(context, widget.userId);
    } catch (e) {
      _logger.severe('Error handling payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final userData = await _service.fetchUserData(widget.userId);
      setState(() {
        isPremium = userData['isPremium'];
      });
    } catch (e) {
      _logger.severe('Error fetching user data: $e');
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
              child: Column(
                children: [
                  Text(
                    'Upgrade',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: AppColors.white,
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
                            text: 'Unlocked all features choco signature layer custom',
                          ),
                          PlanList(
                            iconData: Icons.check_circle_rounded,
                            text: 'Unlimited storage',
                          ),
                        ],
                      ),
                      const Spacer(),
                      isPremium
                          ? SizedBox(
                              height: 55,
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: null,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Premium Member',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: AppColors.white,
                                            ),
                                      ),
                                      Text(
                                        'You are currently in a premium plan.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: AppColors.blue,
                                            ),
                                      ),
                                    ],
                                  )),
                            )
                          : SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    if (kIsWeb) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Payment available only in the mobile app.'),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    } else {
                                      await _handlePayment(context);
                                    }
                                  } catch (e) {
                                    _logger.severe('Payment failed: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Payment failed. Please try again.'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  '50 baht',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
          ),
        ],
      ),
    );
  }
}
