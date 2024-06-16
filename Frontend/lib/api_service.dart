import 'package:dio/dio.dart';
import 'dart:io';

class ApiService {
  final String _baseUrl;
  final int _testUserId = 1; // Mock user ID for testing purposes

  ApiService() : _baseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000'; // Android emulator
    } else {
      return 'http://localhost:8000'; // Local development
    }
    // return 'http://localhost:8000';
  }

  Dio get _dio => Dio(BaseOptions(baseUrl: _baseUrl));

  int get testUserId => _testUserId; // Getter for the test user ID

  Future<List<Map<String, dynamic>>> getAllItems() async {
    try {
      final response = await _dio.get('/items');
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

  Future<void> createItem(Map<String, dynamic> item) async {
    try {
      // Add UserID to the item data
      item['UserID'] = _testUserId;
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
      final response = await _dio
          .put('/items/eaten/$id', data: {'QuantityEaten': quantityEaten});
      print('Response: ${response.data}');
    } catch (e) {
      print('Error marking item as eaten: $e');
      throw e;
    }
  }
  

  //for fetching user name (Dont for get to delete this i non)
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
