import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:logger/logger.dart';
import 'package:myfridgeapp/routes/router.dart';
import 'package:myfridgeapp/theme/custom_theme.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'services/pushy_service.dart';

// Import your pages
import 'package:myfridgeapp/screens/welcome_page.dart';
import 'package:myfridgeapp/screens/signin_page.dart';
import 'package:myfridgeapp/screens/signup_page.dart';
import 'package:myfridgeapp/screens/termofservice_page.dart';
import 'package:myfridgeapp/screens/home_page.dart';
import 'package:myfridgeapp/screens/profile_page.dart';
import 'package:myfridgeapp/screens/shopping_list_page.dart';
import 'package:myfridgeapp/screens/notification_page.dart';
import 'package:myfridgeapp/screens/edit_profile_page.dart';
import 'package:myfridgeapp/screens/payment_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  Logger logger = Logger();

  // Try loading the .env file and catch any errors
  try {
    await dotenv.load(fileName: '.env');
    logger.i('Stripe Publishable Key: ${dotenv.env['STRIPE_PUBLISHABLE_KEY']}');
  } catch (e) {
    logger.e('Error loading .env file');
  }

  // Initialize PushyService
  try {
    await PushyService.initialize();
    Pushy.listen(); // Start the Pushy service
  } catch (e) {
    logger.e('Pushy initialization failed');
  }

  Logger.level = Level.debug;

  // Set Stripe publishable key
  if (dotenv.env['STRIPE_PUBLISHABLE_KEY'] != null) {
    Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  } else {
    logger.e('Stripe key is not set');
    // Use a fallback key if necessary
    Stripe.publishableKey = 'your_fallback_publishable_key';
  }

  final userId = await loadUserState();
  setupLogging();
  runApp(MyApp(userId: userId));
}

Future<void> saveUserState(int userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('userId', userId);
}

Future<int?> loadUserState() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userId');
}

class MyApp extends StatelessWidget {
  final int? userId;

  const MyApp({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "MyFridge",
      theme: CustomTheme.customTheme,
      routerConfig: _createRouter(userId),
    );
  }

  GoRouter _createRouter(int? userId) {
    return GoRouter(
      initialLocation: userId == null ? '/' : '/home',
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
              builder: (context, state) {
                final extra = state.extra as Map<String, String?>?;
                return SignUpPage(
                  initialUsername: extra?['username'],
                  initialEmail: extra?['email'],
                  initialPassword: extra?['password'],
                  initialConfirmPassword: extra?['confirmPassword'],
                );
              },
            ),
            GoRoute(
              path: 'termofservice',
              builder: (context, state) {
                final extra = state.extra as Map<String, String>;
                return TermofServicePage(
                  username: extra['username']!,
                  email: extra['email']!,
                  password: extra['password']!,
                  confirmPassword: extra['confirmPassword']!,
                );
              },
            ),
            GoRoute(
              path: 'home',
              builder: (context, state) {
                final userId = state.extra as int? ?? this.userId;
                if (userId == null) {
                  return const WelcomePage(); // or an error page
                }
                return HomePage(userId: userId);
              },
              routes: [
                GoRoute(
                  path: 'profile',
                  builder: (context, state) {
                    final userId = state.extra as int? ?? this.userId;
                    if (userId == null) {
                      return const WelcomePage(); // or an error page
                    }
                    return ProfilePage(userId: userId);
                  },
                ),
                GoRoute(
                  path: 'shoppinglist',
                  builder: (context, state) {
                    final userId = state.extra as int? ?? this.userId;
                    if (userId == null) {
                      return const WelcomePage(); // or an error page
                    }
                    return ShoppingListPage(userId: userId);
                  },
                ),
                GoRoute(
                  path: 'notifications',
                  builder: (context, state) {
                    final userId = state.extra as int? ?? this.userId;
                    if (userId == null) {
                      return const WelcomePage(); // or an error page
                    }
                    return NotificationPage(userId: userId);
                  },
                ),
                GoRoute(
                  path: 'editprofile',
                  builder: (context, state) {
                    final userId = state.extra as int? ?? this.userId;
                    if (userId == null) {
                      return const WelcomePage(); // or an error page
                    }
                    return EditProfilePage(userId: userId);
                  },
                ),
                GoRoute(
                  path: 'payment',
                  builder: (context, state) {
                    final userId = state.extra as int? ?? this.userId;
                    if (userId == null) {
                      return const WelcomePage(); // or an error page
                    }
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
  }
}

void setupLogging() {
  Logger.level = Level.verbose; // Set the logging level
  // No need to use onRecord, just print logs as they come
  Logger logger = Logger();
  logger.i('Logger initialized');
}
