
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

class ApiService {
  final String _baseUrl;
  final Logger _logger = Logger('ApiService');
  ApiService() : _baseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    } else {
      return 'http://localhost:8000';
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

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setInt('userId', data['userId']);

      return data;
    } catch (e) {
      _logger.severe('Error signing up: $e');
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
      _logger.severe('Error signing up: $e');

      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllItems(int userId) async {
    try {
      final response =
          await _dio.get('/items', queryParameters: {'userId': userId});
      final items = List<Map<String, dynamic>>.from(response.data);

      final currentDate = DateTime.now();
      for (var item in items) {
        final expDate = DateTime.parse(item['ExpirationDate']);
        item['isExpired'] = expDate.isBefore(currentDate);
      }
      _logger.info('Items processed: $items');

      return items;
    } catch (e) {
      _logger.severe('Error fetching items: $e');
      rethrow;
    }
  }

  bool _isCreatingItem = false;

  Future<void> createItem(int userId, Map<String, dynamic> item) async {
    if (_isCreatingItem) return;
    _isCreatingItem = true;
    try {
      item['UserID'] = userId;
      await _dio.post('/items', data: item);
    } catch (e) {
      _logger.severe('Error creating item: $e');
      rethrow;
    } finally {
      _isCreatingItem = false;
    }
  }

  Future<void> updateItem(int id, Map<String, dynamic> item) async {
    try {
      await _dio.put('/items/$id', data: item);
    } catch (e) {
      _logger.severe('Error updating item: $e');
      rethrow;
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await _dio.delete('/items/$id');
    } catch (e) {
      _logger.severe('Error deleting item: $e');
      rethrow;
    }
  }

  Future<int> markItemAsEaten(int id, int quantityEaten) async {
    try {
      final response = await _dio.put(
        '/items/eaten/$id',
        data: {'QuantityEaten': quantityEaten},
      );
      _logger.info('Response: ${response.data}');
      return response.data['remainingQuantity'];
    } catch (e) {
      _logger.severe('Error marking item as eaten: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserById(int userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return response.data;
    } catch (e) {
      _logger.severe('Error fetching user: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getNotifications(int userId) async {
    try {
      final response = await _dio.get('/notifications/$userId');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      _logger.severe('Error fetching notifications: $e');
      rethrow;
    }
  }
}
