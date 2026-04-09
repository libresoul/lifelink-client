import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lifelink/core/config.dart';

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

  // If no baseUrl is provided, use the compile-time API_BASE_URL from config.
  ApiClient([String? baseUrl]) : baseUrl = baseUrl ?? apiBaseUrl;

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

  /// Create a donation record for the authenticated user.
  /// Returns the parsed response body (server row) on success.
  Future<Map<String, dynamic>> createDonation({
    required String accessToken,
    required DateTime donatedAt,
    required int volumeMl,
    String? location,
    String? campaignName,
    String? notes,
    String status = 'SUCCESS',
  }) async {
    final uri = Uri.parse('$baseUrl/api/donations');
    final Map<String, dynamic> body = {
      'donated_at': donatedAt.toIso8601String(),
      'volume_ml': volumeMl,
    };

    if (location != null) body['location'] = location;
    if (campaignName != null) body['campaign_name'] = campaignName;
    if (notes != null) body['notes'] = notes;
    if (status.isNotEmpty) body['status'] = status;

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    final respBody = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : null;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = respBody is Map && respBody['message'] != null
          ? respBody['message'].toString()
          : 'Failed to create donation';
      throw Exception(message);
    }

    if (respBody is! Map<String, dynamic>) {
      return <String, dynamic>{};
    }

    return respBody;
  }

  /// Fetch donations for the authenticated user
  Future<List<Map<String, dynamic>>> getDonations({
    required String accessToken,
  }) async {
    final uri = Uri.parse('$baseUrl/api/donations');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    final respBody = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : null;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = respBody is Map && respBody['message'] != null
          ? respBody['message'].toString()
          : 'Failed to fetch donations';
      throw Exception(message);
    }

    if (respBody is! Map || respBody['donations'] == null) {
      return <Map<String, dynamic>>[];
    }

    final list = (respBody['donations'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    return list;
  }

  /// Fetch campaigns (public) from the server
  Future<List<Map<String, dynamic>>> getCampaigns({String? accessToken}) async {
    final uri = Uri.parse('$baseUrl/api/campaigns');
    final response = accessToken == null
        ? await http.get(uri)
        : await http.get(
            uri,
            headers: {'Authorization': 'Bearer $accessToken'},
          );

    final respBody = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : null;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = respBody is Map && respBody['message'] != null
          ? respBody['message'].toString()
          : 'Failed to fetch campaigns';
      throw Exception(message);
    }

    if (respBody is! Map || respBody['campaigns'] == null)
      return <Map<String, dynamic>>[];

    final list = (respBody['campaigns'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    return list;
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
