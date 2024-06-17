// import 'package:flutter/material.dart';
// import 'package:pushy_flutter/pushy_flutter.dart';
// import 'package:dio/dio.dart';

// class PushyService {
//   static final GlobalKey<NavigatorState> navigatorKey =
//       GlobalKey<NavigatorState>();

//   static Future<void> initialize() async {
//     try {
//       // Register the device for push notifications
//       String? deviceToken = await Pushy.register();
//       if (deviceToken == null || deviceToken.isEmpty) {
//         throw Exception('Device token is null or empty');
//       }
//       print(
//           'Pushy device token: $deviceToken'); // Log the device token for verification

//       // Optionally send the token to your backend
//       int userId = 1; // Replace with the actual user ID
//       await Dio().post(
//         'http://10.0.2.2:8000/register',
//         data: {'userId': userId.toString(), 'token': deviceToken},
//       );

//       // Display the device token in a dialog or snackbar for easy copying
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (navigatorKey.currentContext != null) {
//           showDialog(
//             context: navigatorKey.currentContext!,
//             builder: (context) => AlertDialog(
//               title: Text('Pushy Device Token'),
//               content: SelectableText(
//                   deviceToken), // Allow the token to be selectable for easy copying
//               actions: <Widget>[
//                 TextButton(
//                   child: const Text('OK'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             ),
//           );
//         } else {
//           print('Navigator context is null');
//         }
//       });

//       Pushy.setNotificationListener((data) {
//         if (navigatorKey.currentContext != null) {
//           // Display an alert with the "message" payload value
//           showDialog(
//             context: navigatorKey.currentContext!,
//             builder: (context) => AlertDialog(
//               title: Text('Pushy'),
//               content: Text(data['message']),
//               actions: <Widget>[
//                 TextButton(
//                   child: const Text('OK'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             ),
//           );
//         } else {
//           print('Navigator context is null');
//         }
//       });
//     } catch (e) {
//       print('Pushy registration failed: $e');
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:dio/dio.dart';

class PushyService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> initialize() async {
    try {
      // Register the device for push notifications
      String? deviceToken = await Pushy.register();
      if (deviceToken == null || deviceToken.isEmpty) {
        throw Exception('Device token is null or empty');
      }
      print(
          'Pushy device token: $deviceToken'); // Log the device token for verification

      // Optionally send the token to your backend
      int userId = 1; // Replace with the actual user ID
      await Dio().post(
        _getBackendUrl('/register'),
        data: {'userId': userId.toString(), 'token': deviceToken},
      );

      // Display the device token in a dialog or snackbar for easy copying
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   if (navigatorKey.currentContext != null) {
      //     showDialog(
      //       context: navigatorKey.currentContext!,
      //       builder: (context) => AlertDialog(
      //         title: Text('Pushy Device Token'),
      //         content: SelectableText(
      //             deviceToken), // Allow the token to be selectable for easy copying
      //         actions: <Widget>[
      //           TextButton(
      //             child: const Text('OK'),
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //           ),
      //         ],
      //       ),
      //     );
      //   } else {
      //     print('Navigator context is null');
      //   }
      // });

      // Set notification listeners
      Pushy.setNotificationListener(backgroundNotificationListener);
      Pushy.setNotificationClickListener(notificationClickListener);
    } catch (e) {
      print('Pushy registration failed: $e');
    }
  }

  static String _getBackendUrl(String endpoint) {
    return 'http://10.0.2.2:8000$endpoint'; // Android emulator
  }

  @pragma('vm:entry-point')
  static void backgroundNotificationListener(Map<String, dynamic> data) {
    // Print notification payload data
    print('Received notification: $data');

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
    print('Notification click: $data');

    // Extract notification message
    String message = data['message'] ?? 'Hello World!';

    // Display an alert with the "message" payload value
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text('Notification click'),
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
