import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lifelink/core/network/api_client.dart';
import 'package:lifelink/screens/explore_map.dart';
import 'package:lifelink/core/storage/session_store.dart';
import 'package:lifelink/screens/auth/login.dart';
// import 'package:lifelink/widgets/loading_button.dart';

Widget campaignImage(
  String source, {
  double? height,
  double? width,
  BoxFit fit = BoxFit.cover,
}) {
  final fallback = Container(
    color: Colors.grey.shade200,
    height: height,
    width: width,
    alignment: Alignment.center,
    child: const Icon(
      Icons.image_not_supported_outlined,
      color: Colors.black38,
    ),
  );

  final isAsset = source.startsWith('assets/');
  return isAsset
      ? Image.asset(
          source,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (_, __, ___) => fallback,
        )
      : Image.network(
          source,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (_, __, ___) => fallback,
        );
}

class DonatePage extends StatefulWidget {
  final int initialIndex;
  const DonatePage({super.key, this.initialIndex = 0});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage>
    with SingleTickerProviderStateMixin {
  final _api = ApiClient();
  final _sessionStore = SessionStore();
  bool _creatingDonation = false;
  // campaigns will be loaded from the server
  final List<Map<String, dynamic>> campaigns = [];
  bool _loadingCampaigns = false;

  // donations list will be loaded from server
  final List<Map<String, dynamic>> donations = [];
  bool _loadingDonations = false;

  late final AnimationController _waveController;
  late final Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _loadDonations();
    _loadCampaigns();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _heartScale = Tween<double>(
      begin: 0.9,
      end: 1.05,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_waveController);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: DefaultTabController(
        length: 3,
        initialIndex: widget.initialIndex,
        child: Scaffold(
          backgroundColor: const Color(0xFFF6F7FB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leadingWidth: 0,
            automaticallyImplyLeading: false,
            title: const Text(''),
            actions: const [],
            bottom: const TabBar(
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.red,
              tabs: [
                Tab(text: 'Campaigns'),
                Tab(text: 'Explore'),
                Tab(text: 'History'),
              ],
            ),
          ),
          body: TabBarView(
            children: [_campaignsTab(), _exploreTab(), _historyTab()],
          ),
        ),
      ),
    );
  }

  Widget _campaignsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchField(),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _filterChip('Near Me', selected: true),
              _filterChip('Urgent'),
              _filterChip('All'),
            ],
          ),
          const SizedBox(height: 16),
          ...campaigns.map((item) => _campaignCard(item)).toList(),
        ],
      ),
    );
  }

  Widget _exploreTab() {
    return const ExploreMap();
  }

  Widget _historyTab() {
    return RefreshIndicator(
      onRefresh: _loadDonations,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Donation Journey',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            _impactCard(),
            const SizedBox(height: 20),
            const Text(
              'Past Donations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            if (_loadingDonations)
              const Center(child: CircularProgressIndicator())
            else if (donations.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text('No donations yet.')),
              )
            else
              ...donations.map((item) => _historyItem(item)).toList(),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                "You're making a massive difference.\nReady for your next one?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87, height: 1.3),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
                onPressed: () => _openSchedule(context),
                child: const Text(
                  'Schedule New Donation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _mapServerDonationToUi(Map<String, dynamic> row) {
    final donatedAt = row['donated_at'] ?? row['created_at'] ?? '';
    final dateStr = donatedAt is String ? donatedAt : donatedAt?.toString();
    final volume = row['volume_ml']?.toString() ?? '';
    String status = (row['status'] as String?)?.toLowerCase() ?? 'pending';
    String uiStatus = 'PENDING';
    if (status == 'completed' || status == 'success')
      uiStatus = 'SUCCESS';
    else if (status == 'pending')
      uiStatus = 'PENDING';
    else
      uiStatus = status.toUpperCase();

    return {
      'id': row['id'],
      'title': row['campaign_name'] ?? 'Donation',
      'amount': '${volume}ml',
      'date': dateStr,
      'status': uiStatus,
      'notes': row['notes'],
      '_server': row,
    };
  }

  Future<void> _loadDonations() async {
    final token = await _sessionStore.getAccessToken();
    if (token == null) return;

    try {
      if (mounted) setState(() => _loadingDonations = true);
      final serverList = await _api.getDonations(accessToken: token);
      if (mounted) {
        setState(() {
          donations.clear();
          donations.addAll(serverList.map(_mapServerDonationToUi));
        });
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load donations: ${e.toString()}')),
        );
    } finally {
      if (mounted) setState(() => _loadingDonations = false);
    }
  }

  Map<String, dynamic> _mapCampaignToUi(Map<String, dynamic> row) {
    // parse gallery (could be stored as jsonb array or text)
    List<String> gallery = [];
    try {
      final g = row['gallery'];
      if (g is List)
        gallery = g.cast<String>();
      else if (g is String) {
        // stored as JSON text
        gallery = (g.isNotEmpty)
            ? List<String>.from(jsonDecode(g))
            : <String>[];
      }
    } catch (_) {
      gallery = <String>[];
    }

    final start = row['start_ts'] != null
        ? DateTime.tryParse(row['start_ts'].toString())
        : null;
    final end = row['end_ts'] != null
        ? DateTime.tryParse(row['end_ts'].toString())
        : null;
    final datetime = start == null
        ? ''
        : (end == null
              ? '${start.toLocal()}'
              : '${start.toLocal()} - ${end.toLocal()}');

    return {
      'title': row['title'] ?? 'Campaign',
      'location': row['location'] ?? '',
      'datetime': datetime,
      'badge': row['badge'] ?? '',
      'image': row['image_url'] ?? '',
      'gallery': gallery,
      'description': row['description'] ?? '',
      'raw': row,
    };
  }

  Future<void> _loadCampaigns() async {
    try {
      if (mounted) setState(() => _loadingCampaigns = true);
      final list = await _api.getCampaigns();
      if (mounted)
        setState(() {
          campaigns.clear();
          campaigns.addAll(list.map(_mapCampaignToUi));
        });
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load campaigns: ${e.toString()}')),
        );
    } finally {
      if (mounted) setState(() => _loadingCampaigns = false);
    }
  }

  Widget _searchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.black54),
          hintText: 'Search for campaigns...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _filterChip(String label, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.red.shade50 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: selected ? Colors.red : Colors.transparent,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _campaignCard(Map<String, dynamic> item) {
    final title = item['title'] as String? ?? '';
    final location = item['location'] as String? ?? '';
    final datetime = item['datetime'] as String? ?? '';
    final badge = item['badge'] as String? ?? '';
    final image = item['image'] as String? ?? '';

    return GestureDetector(
      onTap: () => _openDetails(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: title,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: campaignImage(
                      image,
                      height: 160,
                      width: double.infinity,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        datetime,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => _openDonateForm(item),
                      child: const Text(
                        'Donate Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _impactCard() {
    const impactScore = 12;
    const maxScore = 20;
    final level = (impactScore / maxScore).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFFEF5350)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomPaint(
                  painter: _WavePainter(
                    animationValue: _waveController.value,
                    level: level,
                    primaryColor: Colors.white.withOpacity(0.28),
                    secondaryColor: Colors.white.withOpacity(0.18),
                  ),
                  child: const SizedBox(height: 140, width: double.infinity),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: _heartScale.value,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.25),
                            blurRadius: 18 * _heartScale.value,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'IMPACT SCORE',
                    style: TextStyle(color: Colors.white70, letterSpacing: 1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$impactScore',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Total Lives Saved',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _historyItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => _openHistoryDetail(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.water_drop, color: Colors.red),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['date']!,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.circle, size: 10, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        'STATUS: SUCCESS',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              item['amount']!,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetails(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CampaignDetailPage(data: item)),
    );
  }

  void _openHistoryDetail(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HistoryDetailPage(data: item)),
    );
  }

  void _openSchedule(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Schedule new donation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            const Text('Pick a preferred center and time.'),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Scheduling flow to be connected.'),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<String?> _requireAccessToken() async {
    final token = await _sessionStore.getAccessToken();
    if (token != null) return token;

    // Prompt user to login
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login required'),
        content: const Text('You need to be logged in to record a donation.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Login'),
          ),
        ],
      ),
    );

    if (result == true) {
      // Navigate to login page
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return await _sessionStore.getAccessToken();
    }

    return null;
  }

  Future<void> _openDonateForm(Map<String, dynamic> campaign) async {
    final volumeController = TextEditingController(text: '450');
    final locationController = TextEditingController(
      text: campaign['location'] as String? ?? '',
    );
    final notesController = TextEditingController();
    bool isSubmitting = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: StatefulBuilder(
              builder: (context, setModalState) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Record donation for ${campaign['title']}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: volumeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Volume (ml)'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              setModalState(() => isSubmitting = true);
                              final token = await _requireAccessToken();
                              if (token == null) {
                                setModalState(() => isSubmitting = false);
                                return;
                              }

                              final donatedAt = DateTime.now();
                              final volume =
                                  int.tryParse(volumeController.text.trim()) ??
                                  450;
                              final location = locationController.text.trim();
                              final notes = notesController.text.trim();

                              // optimistic add
                              final localId =
                                  DateTime.now().millisecondsSinceEpoch;
                              setState(() {
                                donations.insert(0, {
                                  'title': campaign['title'] ?? 'Donation',
                                  'amount': '${volume}ml',
                                  'date': donatedAt.toIso8601String(),
                                  'status': 'PENDING',
                                  'notes': notes,
                                  '_local_id': localId,
                                });
                              });

                              Navigator.of(context).pop();

                              try {
                                final server = await _api.createDonation(
                                  accessToken: token,
                                  donatedAt: donatedAt,
                                  volumeMl: volume,
                                  location: location.isEmpty ? null : location,
                                  campaignName: campaign['title'] as String?,
                                  notes: notes.isEmpty ? null : notes,
                                  status: 'SUCCESS',
                                );

                                // reconcile server response (server may return { donation: {...} } or the row)
                                Map<String, dynamic> serverRow;
                                if (server['donation'] != null) {
                                  serverRow = Map<String, dynamic>.from(
                                    server['donation'] as Map,
                                  );
                                } else {
                                  serverRow = Map<String, dynamic>.from(
                                    server as Map,
                                  );
                                }

                                final mapped = _mapServerDonationToUi(
                                  serverRow,
                                );
                                setState(() {
                                  final idx = donations.indexWhere(
                                    (d) => d['_local_id'] == localId,
                                  );
                                  if (idx != -1) {
                                    donations[idx] = mapped;
                                  } else {
                                    donations.insert(0, mapped);
                                  }
                                });

                                if (mounted)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Donation recorded'),
                                    ),
                                  );
                              } catch (e) {
                                if (mounted)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Saved locally — server unavailable',
                                      ),
                                    ),
                                  );
                              } finally {
                                if (mounted)
                                  setState(() => _creatingDonation = false);
                              }
                            },
                      child: isSubmitting
                          ? const CircularProgressIndicator()
                          : const Text('Record Donation'),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CampaignDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const CampaignDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String? ?? '';
    final location = data['location'] as String? ?? '';
    final datetime = data['datetime'] as String? ?? '';
    final badge = data['badge'] as String? ?? '';
    final image = data['image'] as String? ?? '';
    final description =
        data['description'] as String? ??
        'Blood donations help trauma patients, cancer care, and emergency surgeries.';
    final gallery = (data['gallery'] as List?)?.cast<String>() ?? const [];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Campaign Details',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: title,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
                child: campaignImage(
                  image,
                  height: 240,
                  width: double.infinity,
                ),
              ),
            ),
            if (gallery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Campaign Gallery',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 110,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: gallery.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final url = gallery[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: campaignImage(url, width: 150, height: 110),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.favorite, color: Colors.red),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Colors.red),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.red),
                      const SizedBox(width: 6),
                      Text(datetime, style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'About this campaign',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'What to expect',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('- Quick eligibility screening at arrival.'),
                        Text('- Donation takes about 8–10 minutes.'),
                        Text('- Complimentary snacks and hydration provided.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.bolt),
                      label: const Text(
                        'Schedule Donation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const HistoryDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Donation Details',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.water_drop,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['title'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                data['date'] ?? '',
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        data['amount'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Icon(Icons.verified, size: 18, color: Colors.green),
                      SizedBox(width: 6),
                      Text(
                        'Status: Success',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Notes',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data['notes'] ??
                        'Donation completed and processed successfully.',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'After-care tips',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.5,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text('- Keep the bandage on for at least 4 hours.'),
                  Text('- Drink plenty of fluids today.'),
                  Text('- Avoid heavy lifting for 24 hours.'),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                onPressed: () => _openSchedule(context),
                child: const Text(
                  'Schedule Next Donation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSchedule(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Schedule new donation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            const Text('Pick a preferred center and time.'),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Scheduling flow to be connected.'),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double animationValue;
  final double level;
  final Color primaryColor;
  final Color secondaryColor;

  const _WavePainter({
    required this.animationValue,
    required this.level,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final clampedLevel = level.clamp(0.0, 1.0);
    final baseHeight = size.height * (1 - clampedLevel);
    const amplitude = 8.0;

    Path buildWave(double phaseShift, double amplitudeFactor) {
      final path = Path()..moveTo(0, baseHeight);
      for (double x = 0; x <= size.width; x += size.width / 40) {
        final y =
            baseHeight +
            math.sin((x / size.width * 2 * math.pi) + phaseShift) *
                (amplitude * amplitudeFactor);
        path.lineTo(x, y);
      }
      path
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      return path;
    }

    final primaryPath = buildWave(animationValue * 2 * math.pi, 1.0);
    final secondaryPath = buildWave(
      animationValue * 2 * math.pi + math.pi / 2,
      1.3,
    );

    canvas.drawPath(primaryPath, Paint()..color = primaryColor);
    canvas.drawPath(secondaryPath, Paint()..color = secondaryColor);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return animationValue != oldDelegate.animationValue ||
        level != oldDelegate.level ||
        primaryColor != oldDelegate.primaryColor ||
        secondaryColor != oldDelegate.secondaryColor;
  }
}
