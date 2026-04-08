import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient(this.baseUrl);

  Future<String> register({
    required String fullname,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/api/auth/register');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullname': fullname,
        'email': email,
        'password': password,
      }),
    );

    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = body is Map && body['message'] != null
          ? body['message'].toString()
          : 'Registration failed';
      throw Exception(message);
    }

    if (body is! Map || body['userId'] == null) {
      throw Exception('Registration succeeded but userId was missing');
    }

    return body['userId'].toString();
  }

  Future<void> registerDetails({
    required String userId,
    required String phoneNumber,
    required String district,
    required String bloodType,
    required String gender,
    required String dateOfBirth,
    required double weightKg,
  }) async {
    final uri = Uri.parse('$baseUrl/api/auth/register/details');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'phoneNumber': phoneNumber,
        'district': district,
        'bloodType': bloodType,
        'gender': gender,
        'dateOfBirth': dateOfBirth,
        'weightKg': weightKg,
      }),
    );

    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = body is Map && body['message'] != null
          ? body['message'].toString()
          : 'Failed to save donor details';
      throw Exception(message);
    }
  }
}
