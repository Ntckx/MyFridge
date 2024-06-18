// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:logger/logger.dart';
// import 'package:myfridgeapp/theme/custom_theme.dart';
// import 'package:myfridgeapp/services/service.dart';
// import 'package:pushy_flutter/pushy_flutter.dart';
// import 'pushy_service.dart';
// import 'package:myfridgeapp/routes/router.dart';
// import 'dart:io';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize logger
//   Logger logger = Logger();

//   // Print current directory to verify the path
//   logger.i('Current Directory: ${Directory.current.path}');

//   // Try loading the .env file and catch any errors
//   try {
//     await dotenv.load(fileName: '.env');
//     logger.i('Stripe Publishable Key: ${dotenv.env['STRIPE_PUBLISHABLE_KEY']}');
//   } catch (e) {
//     logger.e('Error loading .env file');
//   }

//   // Initialize PushyService
//   try {
//     await PushyService.initialize();
//     Pushy.listen(); // Start the Pushy service
//   } catch (e) {
//     logger.e('Pushy initialization failed');
//   }

//   Logger.level = Level.debug;

//   // Set Stripe publishable key
//   if (dotenv.env['STRIPE_PUBLISHABLE_KEY'] != null) {
//     Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
//   } else {
//     logger.e('Stripe key is not set');
//     // Use a fallback key if necessary
//     Stripe.publishableKey = 'your_fallback_publishable_key';
//   }

//   setupLogging();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: "MyFridge",
//       theme: CustomTheme.customTheme,
//       routerDelegate: router.routerDelegate,
//       routeInformationParser: router.routeInformationParser,
//       routeInformationProvider: router.routeInformationProvider,
//       builder: (context, child) {
//         return Navigator(
//           key: PushyService.navigatorKey,
//           onGenerateRoute: (settings) {
//             return MaterialPageRoute(
//               builder: (context) => child!,
//             );
//           },
//         );
//       },
//     );
//   }
// }

// void setupLogging() {
//   Logger.level = Level.verbose; // Set the logging level
//   // No need to use onRecord, just print logs as they come
//   Logger logger = Logger();
//   logger.i('Logger initialized');
// }

import 'package:myfridgeapp/theme/custom_theme.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myfridgeapp/services/service.dart';
import 'package:myfridgeapp/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'pushy_service.dart';
import 'package:pushy_flutter/pushy_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  Logger logger = Logger();
  setupLogging();
  try {
    await PushyService.initialize();
    Pushy.listen(); // Start the Pushy service
  } catch (e) {
    logger.e('Pushy initialization failed');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    // providers: [

    // ],

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
