import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../core/theme/app_theme.dart';
import '../../models/gis_models.dart';
import '../../models/marine_conditions.dart';
import '../../services/gis_service.dart';
import '../../services/marine_service.dart';

class BoundaryGuardianScreen extends StatefulWidget {
  const BoundaryGuardianScreen({super.key});

  @override
  State<BoundaryGuardianScreen> createState() => _BoundaryGuardianScreenState();
}

class _BoundaryGuardianScreenState extends State<BoundaryGuardianScreen> {
  final MapController mapController = MapController();

  List<BoundaryZoneData> zones = const [];
  Position? currentPosition;
  LatLng? selectedPoint;

  BoundaryCheckData? result;
  MarineConditionsData? marineConditions;

  bool loading = true;
  bool checking = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<Position?> _tryPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();

    if (!enabled) return null;

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    );

    return Geolocator.getCurrentPosition(locationSettings: settings);
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final loadedZones = await GisService.getZones();
      final position = await _tryPosition();

      if (!mounted) return;

      setState(() {
        zones = loadedZones;
        currentPosition = position;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => error = e.toString());
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> _checkPoint(LatLng point) async {
    setState(() {
      selectedPoint = point;
      checking = true;
      marineConditions = null;
    });

    try {
      final boundary = await GisService.checkBoundary(
        latitude: point.latitude,
        longitude: point.longitude,
      );

      MarineConditionsData? marine;

      if (boundary.surface == 'WATER') {
        try {
          marine = await MarineService.getConditions(
            latitude: point.latitude,
            longitude: point.longitude,
          );
        } catch (_) {
          // Boundary awareness remains available
          // even if the live environmental source fails.
        }
      }

      if (!mounted) return;

      setState(() {
        result = boundary;
        marineConditions = marine;
      });
    } catch (e) {
      if (!mounted) return;
      _message(e.toString());
    } finally {
      if (mounted) {
        setState(() => checking = false);
      }
    }
  }

  Future<void> _checkMyPosition() async {
    final position = currentPosition ?? await _tryPosition();

    if (position == null) {
      _message('GPS is unavailable or location permission was not granted.');
      return;
    }

    final point = LatLng(position.latitude, position.longitude);

    mapController.move(point, 8);
    await _checkPoint(point);
  }

  void _showDemoZones() {
    mapController.move(const LatLng(20.30, 69.00), 7.4);
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'LAND':
        return const Color(0xFF795548);
      case 'INSIDE':
      case 'HIGH':
        return AppTheme.danger;
      case 'NEAR':
      case 'CAUTION':
      case 'INDICATIVE_INSIDE':
      case 'INDICATIVE_OUTSIDE':
        return AppTheme.warning;
      case 'UNAVAILABLE':
        return const Color(0xFF7A8B92);
      default:
        return AppTheme.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FA),
      appBar: AppBar(
        title: const Text('Boundary Guardian'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? _errorView()
          : _content(),
    );
  }

  Widget _errorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.public_off_rounded,
              size: 50,
              color: AppTheme.oceanBlue,
            ),
            const SizedBox(height: 14),
            Text(error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _content() {
    final initialCenter = currentPosition == null
        ? const LatLng(20.30, 69.00)
        : LatLng(currentPosition!.latitude, currentPosition!.longitude);

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
      children: [
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.navy, Color(0xFF0B6681)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.public_rounded, color: Colors.white, size: 30),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maritime awareness',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Check coast proximity, territorial-sea reference, '
                      'EEZ reference, restricted zones and temporary sea conditions.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.3,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        Container(
          height: 400,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFDCE8EC)),
          ),
          child: Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: initialCenter,
                  initialZoom: currentPosition == null ? 7.4 : 7.5,
                  onTap: (_, point) {
                    _checkPoint(point);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.orca.marine_app',
                  ),
                  PolygonLayer(
                    polygons: zones.map((zone) {
                      return Polygon(
                        points: zone.coordinates
                            .map((pair) => LatLng(pair[1], pair[0]))
                            .toList(),
                        color: AppTheme.danger.withValues(alpha: 0.14),
                        borderColor: AppTheme.danger,
                        borderStrokeWidth: 2,
                        label: zone.name,
                      );
                    }).toList(),
                  ),
                  MarkerLayer(
                    markers: [
                      if (currentPosition != null)
                        Marker(
                          point: LatLng(
                            currentPosition!.latitude,
                            currentPosition!.longitude,
                          ),
                          width: 46,
                          height: 46,
                          child: _marker(
                            Icons.my_location_rounded,
                            AppTheme.oceanBlue,
                          ),
                        ),
                      if (selectedPoint != null)
                        Marker(
                          point: selectedPoint!,
                          width: 46,
                          height: 46,
                          child: _marker(
                            Icons.place_rounded,
                            result?.surface == 'LAND'
                                ? const Color(0xFF795548)
                                : AppTheme.warning,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Column(
                  children: [
                    _mapButton(
                      icon: Icons.my_location_rounded,
                      tooltip: 'My position',
                      onTap: _checkMyPosition,
                    ),
                    const SizedBox(height: 8),
                    _mapButton(
                      icon: Icons.science_rounded,
                      tooltip: 'Show demo restricted zones',
                      onTap: _showDemoZones,
                    ),
                  ],
                ),
              ),
              if (checking)
                const Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: LinearProgressIndicator(),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Tap a point to build a maritime-awareness report.',
          style: TextStyle(color: Color(0xFF74868E), fontSize: 12.3),
        ),
        if (result != null) ...[const SizedBox(height: 18), _report(result!)],
      ],
    );
  }

  Widget _report(BoundaryCheckData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Boundary report',
          style: TextStyle(
            color: AppTheme.navy,
            fontSize: 21,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        _surfaceCard(data),
        if (data.surface == 'WATER') ...[
          const SizedBox(height: 11),
          _coastCard(data),
          const SizedBox(height: 11),
          if (data.territorialSea != null)
            _maritimeZoneCard(
              icon: Icons.flag_rounded,
              data: data.territorialSea!,
            ),
          const SizedBox(height: 11),
          if (data.eez != null)
            _maritimeZoneCard(icon: Icons.language_rounded, data: data.eez!),
          const SizedBox(height: 11),
          _restrictedCard(data),
          const SizedBox(height: 11),
          _hazardCard(data),
          const SizedBox(height: 13),
          _sourceNotice(data),
        ],
      ],
    );
  }

  Widget _surfaceCard(BoundaryCheckData data) {
    final color = _statusColor(data.surface);

    return _infoCard(
      icon: data.surface == 'LAND'
          ? Icons.landscape_rounded
          : Icons.water_rounded,
      title: 'Navigation surface',
      headline: data.surface,
      body: data.surface == 'LAND' ? data.message : 'Selected point is on navigable water according to the current land/water mask.',
      color: color,
    );
  }

  Widget _coastCard(BoundaryCheckData data) {
    final value = data.coastDistanceKm;

    return _infoCard(
      icon: Icons.beach_access_rounded,
      title: 'Coastline proximity',
      headline: value == null
          ? 'Unavailable'
          : '${value.toStringAsFixed(1)} km from land',
      body: data.coastDistanceNote ?? 'Approximate nearest coastline distance.',
      color: AppTheme.oceanBlue,
    );
  }

  Widget _maritimeZoneCard({
    required IconData icon,
    required MaritimeZoneData data,
  }) {
    final color = _statusColor(data.status);

    final distanceText = data.distanceToLimitKm == null
        ? null
        : '${data.distanceToLimitKm!.toStringAsFixed(1)} km';

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: const Color(0xFFE0E9ED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.label,
                      style: const TextStyle(
                        color: AppTheme.navy,
                        fontWeight: FontWeight.w900,
                        fontSize: 15.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.status,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (data.zoneName != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        data.zoneName!,
                        style: const TextStyle(
                          color: Color(0xFF647881),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (distanceText != null) ...[
            const SizedBox(height: 13),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F8FA),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    distanceText,
                    style: const TextStyle(
                      color: AppTheme.navy,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (data.distanceLabel != null)
                    Text(
                      data.distanceLabel!,
                      style: const TextStyle(
                        color: Color(0xFF72858D),
                        fontSize: 10.8,
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            data.source,
            style: const TextStyle(
              color: AppTheme.oceanBlue,
              fontSize: 11.3,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            data.sourceNote,
            style: const TextStyle(
              color: Color(0xFF7B8C93),
              fontSize: 10.8,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _restrictedCard(BoundaryCheckData data) {
    final color = _statusColor(data.status);

    final distance = data.distanceToZoneKm;

    return _infoCard(
      icon: Icons.gpp_maybe_rounded,
      title: 'Restricted / protected areas',
      headline: 'DEMO ${data.status}',
      body: data.status == 'CLEAR'
          ? (distance == null
                ? data.message
                : '${data.message} Nearest demo polygon: '
                      '${distance.toStringAsFixed(1)} km.')
          : data.message,
      color: color,
      footer: data.restrictedAreaNote,
    );
  }

  Widget _hazardCard(BoundaryCheckData data) {
    final marine = marineConditions;

    if (marine == null) {
      return _infoCard(
        icon: Icons.cloud_off_rounded,
        title: 'Temporary sea conditions',
        headline: 'Live data unavailable',
        body: data.temporaryHazardNote,
        color: const Color(0xFF7A8B92),
      );
    }

    final color = _statusColor(marine.screeningStatus);

    return _infoCard(
      icon: Icons.storm_rounded,
      title: 'Temporary sea conditions',
      headline: marine.screeningStatus,
      body: marine.screeningReason,
      color: color,
      footer:
          'Live model screening • ${marine.officialIndiaReference}. '
          'This is not an official cyclone/restricted-area polygon.',
    );
  }

  Widget _sourceNotice(BoundaryCheckData data) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: AppTheme.warning),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              data.maritimeBoundaryNote,
              style: const TextStyle(
                color: Color(0xFF6B6047),
                fontSize: 11.2,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String headline,
    required String body,
    required Color color,
    String? footer,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: const Color(0xFFE0E9ED)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF6C7F87),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  headline,
                  style: TextStyle(
                    color: color,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: const TextStyle(
                    color: Color(0xFF61747C),
                    fontSize: 12.2,
                    height: 1.4,
                  ),
                ),
                if (footer != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    footer,
                    style: const TextStyle(
                      color: Color(0xFF819198),
                      fontSize: 10.7,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _marker(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Icon(icon, color: Colors.white, size: 23),
    );
  }

  Widget _mapButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onTap,
        icon: Icon(icon, color: AppTheme.navy),
      ),
    );
  }
}
