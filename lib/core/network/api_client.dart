import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String userId;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });
}

class DonorProfile {
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? district;
  final String? bloodType;
  final String? gender;
  final String? dateOfBirth;
  final String? weightKg;
  final DonorStats stats;

  const DonorProfile({
    required this.fullName,
    required this.email,
    required this.stats,
    this.phoneNumber,
    this.district,
    this.bloodType,
    this.gender,
    this.dateOfBirth,
    this.weightKg,
  });
}

class DonorStats {
  final int totalDonations;
  final String? lastDonationDate;
  final String? nextEligibleDate;
  final int remainingDays;
  final double eligibilityProgress;

  const DonorStats({
    required this.totalDonations,
    required this.lastDonationDate,
    required this.nextEligibleDate,
    required this.remainingDays,
    required this.eligibilityProgress,
  });
}

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

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = body is Map && body['message'] != null
          ? body['message'].toString()
          : 'Login failed';
      throw Exception(message);
    }

    if (body is! Map ||
        body['accessToken'] == null ||
        body['refreshToken'] == null ||
        body['userId'] == null) {
      throw Exception('Login succeeded but session data was missing');
    }

    return LoginResponse(
      accessToken: body['accessToken'].toString(),
      refreshToken: body['refreshToken'].toString(),
      userId: body['userId'].toString(),
    );
  }

  Future<DonorProfile> getMyDonorProfile({required String accessToken}) async {
    final uri = Uri.parse('$baseUrl/api/donors/me');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = body is Map && body['message'] != null
          ? body['message'].toString()
          : 'Failed to load donor profile';
      throw Exception(message);
    }

    if (body is! Map || body['donor'] is! Map) {
      throw Exception('Invalid donor profile response');
    }

    final donor = body['donor'] as Map;
    final stats = donor['stats'] is Map ? donor['stats'] as Map : const {};

    return DonorProfile(
      fullName: donor['full_name']?.toString() ?? '-',
      email: donor['email']?.toString() ?? '-',
      stats: DonorStats(
        totalDonations: _toInt(stats['total_donations']),
        lastDonationDate: stats['last_donation_date']?.toString(),
        nextEligibleDate: stats['next_eligible_date']?.toString(),
        remainingDays: _toInt(stats['remaining_days']),
        eligibilityProgress: _toDouble(stats['eligibility_progress']),
      ),
      phoneNumber: donor['phone_number']?.toString(),
      district: donor['district']?.toString(),
      bloodType: donor['blood_type']?.toString(),
      gender: donor['gender']?.toString(),
      dateOfBirth: donor['date_of_birth']?.toString(),
      weightKg: donor['weight_kg']?.toString(),
    );
  }

  int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
