import 'package:flutter/material.dart';
import 'package:lifelink/core/network/api_client.dart';
import 'package:lifelink/core/storage/session_store.dart';
import 'package:lifelink/screens/onboarding/welcome.dart';

class DonorHomePage extends StatefulWidget {
  const DonorHomePage({super.key});

  @override
  State<DonorHomePage> createState() => _DonorHomePageState();
}

class _DonorHomePageState extends State<DonorHomePage> {
  final _api = ApiClient();
  final _sessionStore = SessionStore();
  late Future<DonorProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<DonorProfile> _loadProfile() async {
    final accessToken = await _sessionStore.getAccessToken();

    if (accessToken == null) {
      throw Exception('No active session. Please log in.');
    }

    return _api.getMyDonorProfile(accessToken: accessToken);
  }

  Future<void> _logout() async {
    await _sessionStore.clear();

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Welcome()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: FutureBuilder<DonorProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Failed to load donor data: ${snapshot.error}'),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No donor data found'));
          }

          final donor = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildInfoTile('Full Name', donor.fullName),
              _buildInfoTile('Email', donor.email),
              _buildInfoTile('Phone Number', donor.phoneNumber ?? '-'),
              _buildInfoTile('District', donor.district ?? '-'),
              _buildInfoTile('Blood Type', donor.bloodType ?? '-'),
              _buildInfoTile('Gender', donor.gender ?? '-'),
              _buildInfoTile('Date of Birth', donor.dateOfBirth ?? '-'),
              _buildInfoTile('Weight (kg)', donor.weightKg ?? '-'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(title: Text(title), subtitle: Text(value)),
    );
  }
}
