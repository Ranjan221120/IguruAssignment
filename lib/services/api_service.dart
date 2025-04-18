import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {

  Future<List<User>> getUsers({int page = 1}) async {
    try {
      final response = await http.get(Uri.parse('https://reqres.in/api/users?page=$page'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> usersData = data['data'];
        
        return usersData.map((userData) => User.fromJson(userData)).toList();
      } else {
        throw Exception('Failed to load users - Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }
} 