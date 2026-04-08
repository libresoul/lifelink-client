import 'package:flutter/material.dart';
import 'package:lifelink/core/network/api_client.dart';
import 'package:lifelink/core/storage/session_store.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeContent();
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final _api = ApiClient('http://192.168.240.1:8787');
  final _sessionStore = SessionStore();
  late Future<DonorProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<DonorProfile> _loadProfile() async {
    final token = await _sessionStore.getAccessToken();
    if (token == null) {
      throw Exception('No active session');
    }

    return _api.getMyDonorProfile(accessToken: token);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<DonorProfile>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Failed to load home data: ${snapshot.error}'),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('No donor data available'));
            }

            final donor = snapshot.data!;
            final stats = donor.stats;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        height: 1.0,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          donor.fullName,
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.red,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Icon(Icons.notifications),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const SizedBox(
                            width: 250,
                            height: 250,
                            child: CircularProgressIndicator(
                              value: 1,
                              strokeWidth: 16,
                              color: Color.fromARGB(255, 242, 235, 235),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            height: 250,
                            child: CircularProgressIndicator(
                              value: stats.eligibilityProgress,
                              strokeWidth: 16,
                              color: Colors.red,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Column(
                            children: [
                              const Text('Today'),
                              const SizedBox(height: 10),
                              Text(
                                stats.remainingDays == 0
                                    ? 'You can donate'
                                    : 'You can donate in',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 25,
                                  height: 1.0,
                                ),
                              ),
                              Text(
                                stats.remainingDays == 0
                                    ? 'today'
                                    : '${stats.remainingDays} days',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 25,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                stats.nextEligibleDate == null
                                    ? 'Add first donation record'
                                    : 'Next eligibility: ${stats.nextEligibleDate}',
                                style: const TextStyle(color: Colors.red),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: const [
                        Text('Your Donations'),
                        Icon(Icons.arrow_right_outlined),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.4),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Completed Donations',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${stats.totalDonations}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.watch_later_outlined,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Last: ${stats.lastDonationDate ?? '-'}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  donor.district ?? '-',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
