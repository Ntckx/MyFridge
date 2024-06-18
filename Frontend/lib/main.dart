import 'package:myfridgeapp/theme/custom_theme.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myfridgeapp/services/service.dart';
import 'package:myfridgeapp/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  setupLogging();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  runApp(MyApp(token: token ?? ''));
}

class MyApp extends StatelessWidget {
  final String token;
  const MyApp({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "MyFridge",
      theme: CustomTheme.customTheme,
      routerConfig: createRouter(token), // Pass the token to the createRouter function
    );
  }
}