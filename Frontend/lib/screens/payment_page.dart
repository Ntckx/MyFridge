import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/widget/plan_list.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:go_router/go_router.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

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
            padding: const EdgeInsets.fromLTRB(20,50,0,0),
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
                            text: 'Unlocked all features choco signature layer custom',
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
                          onPressed: () {
                            context.go('/');
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
