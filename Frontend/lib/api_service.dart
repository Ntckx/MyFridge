import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8000')); // Replace with your backend URL

  Future<List<Map<String, dynamic>>> getAllItems() async {
    try {
      final response = await _dio.get('/items');
      final items = List<Map<String, dynamic>>.from(response.data);

      final currentDate = DateTime.now();
      for (var item in items) {
        final expDate = DateTime.parse(item['ExpirationDate']);
        item['isExpired'] = expDate.isBefore(currentDate);
      }

      return items;
    } catch (e) {
      print('Error fetching items: $e');
      throw e;
    }
  }

  Future<void> createItem(Map<String, dynamic> item) async {
    try {
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
}
