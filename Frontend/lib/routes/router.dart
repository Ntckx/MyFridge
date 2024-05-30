import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/screens/ShoppingListPage.dart';
import 'package:myfridgeapp/screens/HomePage.dart';
import 'package:myfridgeapp/screens/ProfilePage.dart';
import 'package:myfridgeapp/screens/NotificationPage.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      builder: (context, state) => const HomePage(),
      routes: <RouteBase>[
        GoRoute(path: "shoppinglist", builder: (context, state) => const ShoppingListPage()),
        GoRoute(path: "profile", builder: (context, state) => const ProfilePage()),
        GoRoute(path: "notifications", builder: (context, state) => const NotificationPage()),
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
