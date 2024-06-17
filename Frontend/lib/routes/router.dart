import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/main.dart';
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
import 'package:shared_preferences/shared_preferences.dart';




final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      builder: (context, state) => const WelcomePage(),
      routes: <RouteBase>[
        GoRoute(path: "welcome", builder: (context, state) => const WelcomePage()),
        GoRoute(path: "signup", builder: (context, state) => SignUpPage()),
        GoRoute(path: "signin", builder: (context, state) => SignInPage()),
        GoRoute(path: "termofservice", builder: (context, state) => const TermofServicePage()),
        GoRoute(
          path: "home",
          builder: (context, state) {
            // Extract the token from the state parameters
            final token = state.extra as String;
            return HomePage(token: token);
          },
        ),
        GoRoute(
            path: "shoppinglist",
            builder: (context, state) => const ShoppingListPage()),
        GoRoute(
            path: "profile", builder: (context, state) => const ProfilePage()),
        GoRoute(
            path: "notifications",
            builder: (context, state) => const NotificationPage()),
        GoRoute(
            path: "editprofile",
            builder: (context, state) => const EditProfilePage()),
        GoRoute(
          path: "payment",
          builder: (context, state) => const PaymentPage(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
);
