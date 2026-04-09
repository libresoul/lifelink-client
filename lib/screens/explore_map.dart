import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:lifelink/core/network/api_client.dart';
import 'package:lifelink/pages/donate.dart' show CampaignDetailPage;

class ExploreMap extends StatefulWidget {
  const ExploreMap({super.key});

  @override
  State<ExploreMap> createState() => _ExploreMapState();
}

class _ExploreMapState extends State<ExploreMap> {
  final ApiClient _api = ApiClient();
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  bool _loading = true;

  static final ll.LatLng _sriLanka = ll.LatLng(7.8731, 80.7718);

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    try {
      final rows = await _api.getCampaigns();
      final markers = <Marker>[];
      for (final row in rows) {
        final lat = row['latitude'];
        final lng = row['longitude'];
        if (lat == null || lng == null) continue;
        markers.add(
          Marker(
            point: ll.LatLng((lat as num).toDouble(), (lng as num).toDouble()),
            width: 48,
            height: 48,
            // Marker child is used in flutter_map v8
            child: IconButton(
              icon: const Icon(Icons.location_on, color: Colors.red, size: 36),
              onPressed: () => _openCampaign(row),
            ),
          ),
        );
      }

      if (!mounted) return;
      setState(() {
        _markers = markers;
        _loading = false;
      });

      // fit to markers
      if (_markers.isNotEmpty) {
        final latitudes = _markers.map((m) => m.point.latitude).toList();
        final longitudes = _markers.map((m) => m.point.longitude).toList();
        final north = latitudes.reduce((a, b) => a > b ? a : b);
        final south = latitudes.reduce((a, b) => a < b ? a : b);
        final east = longitudes.reduce((a, b) => a > b ? a : b);
        final west = longitudes.reduce((a, b) => a < b ? a : b);

        // build LatLngBounds from flutter_map and fit camera using CameraFit
        final bounds = LatLngBounds(
          ll.LatLng(south, west),
          ll.LatLng(north, east),
        );
        try {
          _mapController.fitCamera(
            CameraFit.bounds(bounds: bounds, padding: EdgeInsets.all(64)),
          );
        } catch (_) {}
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load map markers: ${e.toString()}')),
      );
    }
  }

  void _openCampaign(Map<String, dynamic> row) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CampaignDetailPage(data: row)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(initialCenter: _sriLanka, initialZoom: 7.5),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.lifelink',
            ),
            MarkerLayer(markers: _markers),
          ],
        ),
        if (_loading)
          const Positioned(
            top: 16,
            left: 16,
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
