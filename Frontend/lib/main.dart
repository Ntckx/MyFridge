import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:myfridgeapp/theme/custom_theme.dart';
import 'pushy_service.dart';
import 'package:pushy_flutter/pushy_flutter.dart'; // Add this import
import './routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize PushyService
  await PushyService.initialize();
  Pushy.listen(); // Start the Pushy service

  Logger.level = Level.debug;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "MyFridge",
      theme: CustomTheme.customTheme,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      builder: (context, child) {
        return Navigator(
          key: PushyService.navigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => child!,
            );
          },
        );
      },
    );
  }
}
