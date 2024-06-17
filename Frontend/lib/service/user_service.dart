import 'package:dio/dio.dart';
import 'package:myfridgeapp/models/user_models.dart';

class LoginService {
  final Dio _dio = Dio();

  Future<UserModel?> login(String email, String password) async {
    try { 
      // Update this URL based on your environment
     String baseUrl = 'http://10.0.2.2:8000/'; // Replace with your server's IP and port
      // final String baseUrl = 'http://10.0.2.2:3000'; 

      Response response = await _dio.post(
        '$baseUrl/login',
        data: {'email': email, 'password': password},
      );

     print('Response data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('email') && data.containsKey('token')) {
          return UserModel.fromJson(data);
        } else {
          throw Exception('Invalid response from server');
        }
        
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
