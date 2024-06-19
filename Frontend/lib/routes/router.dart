import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/screens/shopping_list_page.dart';
import 'package:myfridgeapp/screens/home_page.dart';
import 'package:myfridgeapp/screens/profile_page.dart';
import 'package:myfridgeapp/screens/notification_page.dart';
import 'package:myfridgeapp/screens/edit_profile_page.dart';
import 'package:myfridgeapp/screens/payment_page.dart';
import 'package:myfridgeapp/screens/welcome_page.dart';
import 'package:myfridgeapp/screens/signin_page.dart';
import 'package:myfridgeapp/screens/signup_page.dart';
import 'package:myfridgeapp/screens/termofservice_page.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomePage(),
      routes: [
        GoRoute(
          path: 'signin',
          builder: (context, state) => const SignInPage(),
        ),
        GoRoute(
          path: 'signup',
          builder: (context, state) => SignUpPage(),
        ),
        GoRoute(
          path: 'termofservice',
          builder: (context, state) => const TermofServicePage(),
        ),
        GoRoute(
          path: 'home',
          builder: (context, state) {
            final userId = state.extra as int;
            return HomePage(userId: userId);
          },
          routes: [
            GoRoute(
              path: 'profile',
              builder: (context, state) {
                final userId = state.extra as int;
                return ProfilePage(userId: userId);
              },
            ),
            GoRoute(
              path: 'shoppinglist',
              builder: (context, state) {
                final userId = state.extra as int;
                return ShoppingListPage(userId: userId);
              },
            ),
            GoRoute(
              path: 'notifications',
              builder: (context, state) {
                final userId = state.extra as int;
                return NotificationPage(userId: userId);
              },
            ),
            GoRoute(
              path: 'editprofile',
              builder: (context, state) {
                final userId = state.extra as int;
                return EditProfilePage(userId: userId);
              },
            ),
            GoRoute(
              path: 'payment',
              builder: (context, state) {
                final userId = state.extra as int;
                return PaymentPage(userId: userId);
              },
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) {
    debugPrint('Error: ${state.error}');
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    );
  },
);
