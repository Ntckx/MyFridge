import 'package:dio/dio.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl;

  ApiService() : _baseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000'; // Android emulator
    } else {
      return 'http://localhost:8000'; // Local development
    }
  }

  Dio get _dio => Dio(BaseOptions(baseUrl: _baseUrl));

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      final data = response.data;

      // Store the token and user ID in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setInt('userId', data['userId']);

      return data;
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> signUp(
      String username, String email, String password, String pushyToken) async {
    try {
      final response = await _dio.post('/users', data: {
        'username': username,
        'email': email,
        'password': password,
        'pushyToken': pushyToken,
      });
      return response.data;
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllItems(int userId) async {
    try {
      final response = await _dio.get('/items', queryParameters: {'userId': userId});
      final items = List<Map<String, dynamic>>.from(response.data);

      final currentDate = DateTime.now();
      for (var item in items) {
        final expDate = DateTime.parse(item['ExpirationDate']);
        item['isExpired'] = expDate.isBefore(currentDate);
      }
      print('Items processed: $items');

      return items;
    } catch (e) {
      print('Error fetching items: $e');
      throw e;
    }
  }

  Future<void> createItem(int userId, Map<String, dynamic> item) async {
    try {
      item['UserID'] = userId; // Add UserID to the item data
      await _dio.post('/items', data: item);
    } catch (e) {
      print('Error creating item: $e');
      throw e;
    }
  }

  Future<void> updateItem(int id, Map<String, dynamic> item) async {
    try {
      await _dio.put('/items/$id', data: item);
    } catch (e) {
      print('Error updating item: $e');
      throw e;
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await _dio.delete('/items/$id');
    } catch (e) {
      print('Error deleting item: $e');
      throw e;
    }
  }

  Future<void> markItemAsEaten(int id, int quantityEaten) async {
    try {
      final response = await _dio.put('/items/eaten/$id', data: {'QuantityEaten': quantityEaten});
      print('Response: ${response.data}');
    } catch (e) {
      print('Error marking item as eaten: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> getUserById(int userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return response.data;
    } catch (e) {
      print('Error fetching user: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getNotifications(int userId) async {
    try {
      final response = await _dio.get('/notifications/$userId');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('Error fetching notifications: $e');
      throw e;
    }
  }
}
