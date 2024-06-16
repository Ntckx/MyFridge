import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/widget/plan_list.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import '../api_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late InAppPurchase _inAppPurchase;
  late Stream<List<PurchaseDetails>> _purchaseUpdates;
  final Set<String> _kIds = {'premium_upgrade'};
  final ApiService _apiService = ApiService();
  // final PaymentService _paymentService = PaymentService();
  late int _userId;

  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _inAppPurchase = InAppPurchase.instance;
    _purchaseUpdates = _inAppPurchase.purchaseStream;
    _purchaseUpdates.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    });
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    try {
      final user = await _apiService.getUserById(_apiService.testUserId);
      setState(() {
        _userId = user['UserID'];
      });
      _logger.i('User ID fetched: $_userId');
    } catch (e) {
      _logger.e('Error fetching user ID: $e');
    }
  }

  Future<void> _buyPremium() async {
    try {
      _logger.i('Querying product details...');
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product not found.')),
        );
        return;
      }
      final List<ProductDetails> products = response.productDetails;
      if (products.isNotEmpty) {
        final ProductDetails productDetails = products[0];
        final PurchaseParam purchaseParam =
            PurchaseParam(productDetails: productDetails);
        _logger.i('Initiating purchase...');
        _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      _logger.e('Error during purchase: $e');
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        _handleSuccessfulPurchase();
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        _handleError(purchaseDetails.error!);
      }
      if (purchaseDetails.pendingCompletePurchase) {
        InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
  }

  void _handleSuccessfulPurchase() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Purchase successful. You are now a premium user!')),
    );

    try {
      _logger.i('Updating backend with payment information...');
      // await _paymentService.createPayment(_userId, 50.0, 'THB');
      _logger.i('Backend update successful. Redirecting...');
      context.go('/');
    } catch (e) {
      _logger.e('Error updating user to premium: $e');
    }
  }

  void _handleError(IAPError error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Purchase failed. Please try again.')),
    );
    _logger.e('Purchase error: ${error.message}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: ''),
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
                          onPressed: _buyPremium,
                          child: Text(
                            '50 baht',
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
          ),
        ],
      ),
    );
  }
}
