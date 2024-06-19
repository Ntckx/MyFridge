import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Service {
  final String _baseUrl;

  final Logger _logger = Logger('Service');

  Service() : _baseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:8000';
    } else {
      return 'http://10.0.2.2:8000';
    }
  }

  Dio get _dio => Dio(BaseOptions(baseUrl: _baseUrl));


  // For profile_page
  Future<Map<String, dynamic>> fetchUserData(int userId) async {
    try {
      final response = await _dio.post(
        '/getUser',
        data: {'UserID': userId},
      );
      final userData = response.data;
      if (response.statusCode == 200) {
        _logger.info('User data fetched successfully');
        return userData;
      } else {
        _logger.warning(
            'Failed to fetch user data with status: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      _logger.severe('Error fetching user data: $e');
      rethrow;
    }
  }

  // For edit_profile_page
  Future<void> updateUserProfile(int userId, String username) async {
    try {
      final response = await _dio.patch(
        '/updateUsername',
        data: {
          'UserId': userId,
          'Username': username,
        },
      );
      if (response.statusCode == 200) {
        _logger.info('User data updated successfully');
      } else {
        _logger.warning(
            'Failed to update username with status: ${response.statusCode}');
      }
    } catch (e) {
      _logger.severe('Error updating username: $e');
    }
  }

  // For shopping_list_page
  Future<List<Map<String, dynamic>>> fetchListData(int userId) async {
    try {
      final response = await _dio.post('/allList', data: {'UserID': userId});
      final listData = response.data;
      if (response.statusCode == 200) {
        _logger.info('List data fetched successfully');
        return List<Map<String, dynamic>>.from(listData);
      } else {
        _logger.warning(
            'Failed to fetch list data with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _logger.severe('Error fetching list data: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userId');
}


  Future<void> checkBoxChanged(int listId, bool? value) async {
    try {
      final response = await _dio.patch('/updateList', data: {
        'ListId': listId,
        'isChecked': value,
      });
      if (response.statusCode == 200) {
        _logger.info('Checkbox changed successfully');
      } else {
        _logger.warning(
            'Failed to update checkbox with status: ${response.statusCode}');
      }
    } catch (e) {
      _logger.severe('Error updating checkbox: $e');
    }
  }

  Future<void> saveNewItem(int userId, String itemName, int quantity) async {
    try {
      final response = await _dio.post('/createList', data: {
        'UserId': userId,
        'Listname': itemName,
        'Quantity': quantity,
        'isChecked': false,
      });
      if (response.statusCode == 200) {
        _logger.info('New item created successfully');
      } else {
        _logger.warning(
            'Failed to create new item with status: ${response.statusCode}');
      }
    } catch (e) {
      _logger.severe('Error creating new item: $e');
    }
  }

  Future<void> deleteItem(int listId) async {
    try {
      final response = await _dio.delete('/deleteList', data: {
        'ListId': listId,
      });
      if (response.statusCode == 200) {
        _logger.info('Item deleted successfully');
      } else {
        _logger.warning(
            'Failed to delete item with status: ${response.statusCode}');
      }
    } catch (e) {
      _logger.severe('Error deleting item: $e');
    }
  }

  Future<void> clearAllItems(int userId) async {
    try {
      final response = await _dio.delete('/deleteAllList', data: {
        'UserId': userId,
      });
      if (response.statusCode == 200) {
        _logger.info('All items deleted successfully');
      } else {
        _logger.warning(
            'Failed to delete all items with status: ${response.statusCode}');
      }
    } catch (e) {
      _logger.severe('Error deleting all items: $e');
    }
  }

  // For payment_page
  Future<bool> updateUserPremiumStatus(int userId) async {
    try {
      final response = await _dio.patch(
        '/updatePremium',
        data: {
          'UserId': userId,
          'isPremium': true,
        },
      );
      if (response.statusCode == 200) {
        _logger.info('User premium status updated successfully');
        return true;
      } else {
        _logger.warning(
            'Failed to update user premium status with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _logger.severe('Error updating user premium status: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    _logger.info('Creating payment intent with amount: $amount, currency: $currency');

    // Log the API key for debugging purposes (remove before deploying)
    _logger.info('Using Stripe Secret Key: ${dotenv.env['STRIPE_SECRET_KEY']}');

    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      _logger.info('Payment intent response: ${response.body}');
      return json.decode(response.body);
    } catch (err) {
      _logger.severe('Error creating payment intent: $err');
      throw Exception(err.toString());
    }
  }

  Future<void> initPaymentSheet(Map<String, dynamic> paymentIntent) async {
    _logger.info('Initializing payment sheet with payment intent: $paymentIntent');
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'MyFridgeApp',
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'TH',
            currencyCode: 'THB',
            testEnv: true,
          ),
        ),
      );
      _logger.info('Payment sheet initialized');
    } catch (e) {
      _logger.severe('Error initializing payment sheet: $e');
      throw Exception('Error initializing payment sheet');
    }
  }

  Future<void> displayPaymentSheet(BuildContext context, int userId) async {
    _logger.info('Displaying payment sheet');
    try {
      await Stripe.instance.presentPaymentSheet();
      bool isUpdated = await updateUserPremiumStatus(userId);
      if (isUpdated) {
        _logger.info('Payment successfully completed and user premium status updated');
        context.go("/home/profile", extra: userId);
      } else {
        _logger.warning('Payment completed but failed to update user status');
      }
    } catch (e) {
      _logger.severe('Error displaying payment sheet: $e');
      throw Exception('Error displaying payment sheet');
    }
  }
}
