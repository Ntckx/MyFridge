import 'package:flutter/material.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:logging/logging.dart';


class PushyService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final Logger _logger = Logger('ProfilePage');
  

  static Future<void> initialize() async {
    try {
      // Register the device for push notifications
      String? deviceToken = await Pushy.register();
      if ( deviceToken.isEmpty) {
        throw Exception('Device token is null or empty');
      }
      _logger.info(
          'Pushy device token: $deviceToken'); // Log the device token for verification

      // Optionally send the token to your backend
      // This should be done during the registration process in the frontend

      // Set notification listeners
      Pushy.setNotificationListener(backgroundNotificationListener);
      Pushy.setNotificationClickListener(notificationClickListener);
    } catch (e) {
      _logger.severe('Pushy registration failed: $e');
    }
  }

  static String getBackendUrl(String endpoint) {
    return 'http://10.0.2.2:8000$endpoint'; // Android emulator
  }

  @pragma('vm:entry-point')
  static void backgroundNotificationListener(Map<String, dynamic> data) {
    // Print notification payload data
    _logger.info('Received notification: $data');

    // Notification title
    String notificationTitle = 'MyApp';

    // Attempt to extract the "message" property from the payload: {"message":"Hello World!"}
    String notificationText = data['message'] ?? 'Hello World!';

    // Android: Displays a system notification
    // iOS: Displays an alert dialog
    Pushy.notify(notificationTitle, notificationText, data);

    // Clear iOS app badge number
    Pushy.clearBadge();
  }

  @pragma('vm:entry-point')
  static void notificationClickListener(Map<String, dynamic> data) {
    // Print notification payload data
    _logger.info('Notification click: $data');

    // Extract notification message
    String message = data['message'] ?? 'Hello World!';

    // Display an alert with the "message" payload value
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text('Notification click'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );

    // Clear iOS app badge number
    Pushy.clearBadge();
  }
}
