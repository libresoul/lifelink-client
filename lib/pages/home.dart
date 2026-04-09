import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifelink/core/network/api_client.dart';
import 'package:lifelink/pages/donate.dart';
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
  final _api = ApiClient();
  final _sessionStore = SessionStore();
  late Future<DonorProfile> _profileFuture;
  late Future<List<Map<String, dynamic>>> _campaignsFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
    _campaignsFuture = _loadCampaigns();
  }

  Future<DonorProfile> _loadProfile() async {
    final token = await _sessionStore.getAccessToken();
    if (token == null) {
      throw Exception('No active session');
    }

    return _api.getMyDonorProfile(accessToken: token);
  }

  Future<List<Map<String, dynamic>>> _loadCampaigns() async {
    try {
      final serverList = await _api.getCampaigns();
      final list = serverList.map((e) {
        return {
          'title': e['title'] ?? '',
          'location': e['location'] ?? '',
          'datetime': e['start_ts']?.toString() ?? '',
          'image': e['image_url'] ?? '',
          'raw': e,
        };
      }).toList();
      return List<Map<String, dynamic>>.from(list);
    } catch (e) {
      rethrow;
    }
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
                    Text(
                      'Welcome back',
                      style: GoogleFonts.syne(
                        fontSize: 20,
                        color: Colors.grey,
                        height: 1.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          donor.fullName,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: Color(0xFFe71b34),
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
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DonatePage(initialIndex: 2),
                          ),
                        );
                      },
                      child: Row(
                        children: const [
                          Text('Your Donations'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_right_outlined),
                        ],
                      ),
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
                    const SizedBox(height: 18),

                    // Nearby campaigns header
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DonatePage(initialIndex: 0),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Nearby campaigns',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Icon(Icons.arrow_right_outlined),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _campaignsFuture,
                      builder: (context, csnap) {
                        if (csnap.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (csnap.hasError ||
                            csnap.data == null ||
                            csnap.data!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(child: Text('No nearby campaigns')),
                          );
                        }

                        final list = csnap.data!;
                        final preview = list.take(3).toList();
                        return Column(
                          children: preview.map((c) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CampaignDetailPage(data: c['raw'] ?? c),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: (c['image'] as String).isNotEmpty
                                          ? Image.network(
                                              c['image'],
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  const Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                            )
                                          : const Icon(
                                              Icons.image,
                                              color: Colors.black26,
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            c['title'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            c['location'] ?? '',
                                            style: const TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
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
