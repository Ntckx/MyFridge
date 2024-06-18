import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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


class Checktoken extends StatelessWidget {
  final String token;
  const Checktoken({Key? key, required this.token});

   @override
  Widget build(BuildContext context) {
    if (token.isNotEmpty && !JwtDecoder.isExpired(token)) {
      return HomePage();
    } else {
      return const WelcomePage();
    }
    
  }
}
GoRouter createRouter(String token) {
  return GoRouter(
    initialLocation: token.isNotEmpty && !JwtDecoder.isExpired(token) ? '/home' : '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => Checktoken(token: token),
        routes: <RouteBase>[
          GoRoute(path: 'welcome', builder: (context, state) => const WelcomePage()),
          GoRoute(path: 'signup', builder: (context, state) => SignUpPage()),
          GoRoute(path: 'signin', builder: (context, state) => SignInPage()),
          GoRoute(path: 'termofservice', builder: (context, state) => const TermofServicePage()),
          GoRoute(path: 'home', builder: (context, state) =>  HomePage()),
          GoRoute(path: 'shoppinglist', builder: (context, state) => const  ShoppingListPage()),
          GoRoute(path: 'profile', builder: (context, state) => const ProfilePage()),
          GoRoute(path: 'notifications', builder: (context, state) => const NotificationPage()),
          GoRoute(path: 'editprofile', builder: (context, state) => EditProfilePage()),
          GoRoute(path: 'payment', builder: (context, state) => PaymentPage()),
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
}
