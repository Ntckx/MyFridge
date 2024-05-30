import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/ShoppingListPage.dart';
import '../screens/HomePage.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      builder: (context, state) => const HomePage(),
      routes: <RouteBase>[
        GoRoute(path: "shoppinglist", builder: (context, state) => const ShoppingListPage()),
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
