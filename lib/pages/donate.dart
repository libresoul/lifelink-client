import 'package:flutter/material.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final List<Map<String, String>> campaigns = [
    {
      'title': 'Central City Hospital Blood Drive',
      'location': '123 Medical Way, Suite 4',
      'datetime': 'Oct 16, 08:00 AM - 04:00 PM',
      'badge': 'High Urgency',
      'image':
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80',
      'description':
          'City-wide blood drive focused on replenishing emergency reserves. Walk-ins are welcome; ID required.'
    },
    {
      'title': 'Community Health Center',
      'location': '406 Wellness Rd',
      'datetime': 'Oct 19, 09:00 AM - 05:00 PM',
      'badge': 'Medium Urgency',
      'image':
          'https://images.unsplash.com/photo-1504439904031-93ded9f93e7d?auto=format&fit=crop&w=1200&q=80',
      'description':
          'Community clinic hosting a day-long donation fair with on-site wellness checks and refreshments.'
    },
    {
      'title': 'Westside Regional Mobile Unit',
      'location': '785 Paradise Square',
      'datetime': 'Oct 20, 10:00 AM - 05:30 PM',
      'badge': 'Low Urgency',
      'image':
          'https://images.unsplash.com/photo-1582719478248-87f26127bc5b?auto=format&fit=crop&w=1200&q=80',
      'description':
          'Mobile blood unit stationed at the plaza. Easy parking, quick 20-minute experience, and free snacks.'
    },
    {
      'title': 'Lakeside University Drive',
      'location': '40 Campus Loop, Hall B',
      'datetime': 'Oct 22, 09:00 AM - 02:00 PM',
      'badge': 'High Urgency',
      'image':
          'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=1200&q=80',
      'description':
          'Student-organized drive supporting local hospitals ahead of the holiday season rush.'
    },
    {
      'title': 'Harborview Community Hall',
      'location': '11 Bayfront Ave',
      'datetime': 'Oct 24, 11:00 AM - 06:00 PM',
      'badge': 'Medium Urgency',
      'image':
          'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1200&q=80',
      'description':
          'Neighborhood-led campaign with kids’ corner, food trucks, and nurse-led eligibility guidance.'
    },
  ];

  final List<Map<String, String>> donations = [
    {
      'title': 'Central Medical Hub',
      'amount': '450ml',
      'date': 'October 24, 2023',
      'status': 'SUCCESS',
      'notes':
          'Post-donation check: BP stable, hydrated well. Received thank-you badge for critical need support.'
    },
    {
      'title': 'City Red Cross',
      'amount': '500ml',
      'date': 'August 12, 2023',
      'status': 'SUCCESS',
      'notes':
          'First-time platelet donation at this center. Smooth process, scheduled follow-up in 3 months.'
    },
    {
      'title': 'St. Jude Hospital',
      'amount': '450ml',
      'date': 'May 05, 2023',
      'status': 'SUCCESS',
      'notes':
          'Helped replenish trauma wing inventory. Quick recovery with juice and snack provided.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: const Color(0xFFF6F7FB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: () {},
            ),
            title: const Text(
              'LIFELINK',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.person, color: Colors.black87),
                ),
              )
            ],
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
            children: [
              _campaignsTab(),
              _exploreTab(),
              _historyTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campaignsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchField(),
          const SizedBox(height: 16),
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
    return Container(
      color: const Color(0xFFF6F7FB),
      alignment: Alignment.center,
      child: const Text(
        'Explore is empty for now.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _historyTab() {
    return SingleChildScrollView(
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
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
    );
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

  Widget _campaignCard(Map<String, String> item) {
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
                  tag: item['title'] ?? '',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      item['image']!,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item['badge']!,
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
                    item['title']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 18, color: Colors.red),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item['location']!,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 18, color: Colors.red),
                      const SizedBox(width: 6),
                      Text(
                        item['datetime']!,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => _openDetails(item),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(Icons.favorite, color: Colors.white, size: 36),
          SizedBox(height: 10),
          Text(
            'IMPACT SCORE',
            style: TextStyle(color: Colors.white70, letterSpacing: 1),
          ),
          SizedBox(height: 6),
          Text(
            '12',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Total Lives Saved',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyItem(Map<String, String> item) {
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

  void _openDetails(Map<String, String> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CampaignDetailPage(data: item),
      ),
    );
  }

  void _openHistoryDetail(Map<String, String> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistoryDetailPage(data: item),
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

class CampaignDetailPage extends StatelessWidget {
  final Map<String, String> data;
  const CampaignDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
              tag: data['title'] ?? '',
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(24)),
                child: Image.network(
                  data['image'] ?? '',
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
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
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          data['badge'] ?? '',
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.favorite, color: Colors.red),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    data['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: Colors.red),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          data['location'] ?? '',
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
                      Text(
                        data['datetime'] ?? '',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'About this campaign',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['description'] ??
                        'Blood donations help trauma patients, cancer care, and emergency surgeries.',
                    style:
                        const TextStyle(fontSize: 15, color: Colors.black87),
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
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'What to expect',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                        SizedBox(height: 8),
                        Text('• Quick eligibility screening at arrival.'),
                        Text('• Donation takes about 8–10 minutes.'),
                        Text('• Complimentary snacks and hydration provided.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 14),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.bolt),
                      label: const Text(
                        'Schedule Donation',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HistoryDetailPage extends StatelessWidget {
  final Map<String, String> data;
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
                  )
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
                            child:
                                const Icon(Icons.water_drop, color: Colors.red),
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
                            fontWeight: FontWeight.w800, fontSize: 16),
                      )
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
                            color: Colors.green, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Notes',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5),
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
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'After-care tips',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15.5),
                  ),
                  SizedBox(height: 6),
                  Text('• Keep the bandage on for at least 4 hours.'),
                  Text('• Drink plenty of fluids today.'),
                  Text('• Avoid heavy lifting for 24 hours.'),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
                onPressed: () => _openSchedule(context),
                child: const Text(
                  'Schedule Next Donation',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
