import 'package:flutter/material.dart';
import 'package:myfridgeapp/theme/custom_theme.dart';
import 'package:myfridgeapp/routes/router.dart';
import 'package:myfridgeapp/services/service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  setupLogging();
  runApp(const MyApp());

  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    // providers: [

    // ],

    return Container(
      child: MaterialApp.router(
        title: "MyFridge",
        theme: CustomTheme.customTheme,
        routerConfig: router,
      ),
    );
  }
}
