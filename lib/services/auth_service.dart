import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  AuthService({required this.baseUrl});
  final String baseUrl;
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> register(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final body = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      // store token
      await _storage.write(key: 'jwt', value: body['token']);
      return body;
    }
    throw Exception(body['error'] ?? 'Register failed');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final body = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      await _storage.write(key: 'jwt', value: body['token']);
      return body;
    }
    throw Exception(body['error'] ?? 'Login failed');
  }

  Future<Map<String, dynamic>> me() async {
    final token = await _storage.read(key: 'jwt');
    if (token == null) throw Exception('Not authenticated');
    final res = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final body = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) return body;
    throw Exception(body['error'] ?? 'Failed fetching profile');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt');
  }

  Future<String?> getToken() => _storage.read(key: 'jwt');
}
