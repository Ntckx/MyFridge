import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/screens/shopping_list_page.dart';
import 'package:myfridgeapp/screens/home_page.dart';
import 'package:myfridgeapp/screens/profile_page.dart';
import 'package:myfridgeapp/screens/notification_page.dart';
import 'package:myfridgeapp/screens/edit_profile_page.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      builder: (context, state) => const HomePage(),
      routes: <RouteBase>[
        GoRoute(path: "shoppinglist", builder: (context, state) => const ShoppingListPage()),
        GoRoute(path: "profile", builder: (context, state) => const ProfilePage()),
        GoRoute(path: "notifications", builder: (context, state) => const NotificationPage()),
        GoRoute(path: "editprofile", builder: (context, state) => const EditProfilePage()),
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
