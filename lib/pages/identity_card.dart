import 'package:flutter/material.dart';
import 'package:lifelink/core/network/api_client.dart';
import 'package:lifelink/core/storage/session_store.dart';

class IdentityCardPage extends StatefulWidget {
  final DonorProfile donor;

  const IdentityCardPage({super.key, required this.donor});

  @override
  State<IdentityCardPage> createState() => _IdentityCardPageState();
}

class _IdentityCardPageState extends State<IdentityCardPage> {
  final _api = ApiClient();
  final _store = SessionStore();
  late Future<List<Map<String, dynamic>>> _donationsFuture;
  bool _showAllDonations = false;

  @override
  void initState() {
    super.initState();
    _donationsFuture = _loadDonations();
  }

  Future<List<Map<String, dynamic>>> _loadDonations() async {
    final token = await _store.getAccessToken();
    if (token == null) return [];
    final list = await _api.getDonations(accessToken: token);
    return list;
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw).toLocal();
      const months = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final donor = widget.donor;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text('Identity card'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Identity card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFe71b34), Color(0xFFb21a2a)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // blood badge
                        Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                donor.bloodType ?? '-',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Rh-',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                donor.fullName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'DOB',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.85,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          donor.dateOfBirth ?? '-',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sex',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.85,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          donor.gender ?? '-',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                donor.district ?? '-',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                donor.phoneNumber ?? '-',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'DONOR ID',
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'NBTS-2023-04821',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Donation history card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Donation Record',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${donor.stats.totalDonations} donations recorded',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _donationsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                'Failed to load donations: ${snapshot.error}',
                              ),
                            ),
                          );
                        }

                        final list = snapshot.data ?? [];
                        if (list.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: Text('No donations recorded')),
                          );
                        }

                        final displayList = _showAllDonations
                            ? list
                            : list.take(4).toList();

                        return Column(
                          children: [
                            ...List.generate(displayList.length, (idx) {
                              final item = displayList[idx];
                              final dateRaw =
                                  item['donated_at']?.toString() ?? '-';
                              final date = _formatDate(dateRaw);
                              final vol = item['volume_ml']?.toString() ?? '-';
                              final loc =
                                  item['location']?.toString() ??
                                  item['campaign_name']?.toString() ??
                                  '-';

                              return Column(
                                children: [
                                  ListTile(
                                    leading: Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFfdecea),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        (idx + 1).toString().padLeft(2, '0'),
                                        style: const TextStyle(
                                          color: Color(0xFFe71b34),
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      date,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    subtitle: Text(loc),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          vol,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFfdecea),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(
                                                Icons.check,
                                                size: 14,
                                                color: Color(0xFFe71b34),
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                'Verified',
                                                style: TextStyle(
                                                  color: Color(0xFFe71b34),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (idx != displayList.length - 1)
                                    const Divider(height: 1),
                                ],
                              );
                            }),
                            if (list.length > 4)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                child: TextButton(
                                  onPressed: () => setState(
                                    () =>
                                        _showAllDonations = !_showAllDonations,
                                  ),
                                  child: Text(
                                    _showAllDonations
                                        ? 'Show less'
                                        : 'Show more',
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
