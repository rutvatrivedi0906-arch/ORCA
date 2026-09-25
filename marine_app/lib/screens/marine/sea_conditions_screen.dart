import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../core/theme/app_theme.dart';
import '../../models/marine_conditions.dart';
import '../../services/marine_service.dart';

class SeaConditionsScreen extends StatefulWidget {
  const SeaConditionsScreen({super.key});

  @override
  State<SeaConditionsScreen> createState() => _SeaConditionsScreenState();
}

class _SeaConditionsScreenState extends State<SeaConditionsScreen> {
  MarineConditionsData? data;
  Position? position;

  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<Position> _getPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      throw Exception('Location service is disabled. Enable GPS and retry.');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission is required to load marine conditions near you.',
      );
    }

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    );

    return Geolocator.getCurrentPosition(locationSettings: locationSettings);
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final currentPosition = await _getPosition();

      final result = await MarineService.getConditions(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
      );

      if (!mounted) return;

      setState(() {
        position = currentPosition;
        data = result;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'LOW':
        return AppTheme.success;
      case 'CAUTION':
        return AppTheme.warning;
      case 'HIGH':
        return AppTheme.danger;
      default:
        return const Color(0xFF7A8B92);
    }
  }

  String _value(double? value, String unit, {int decimals = 1}) {
    if (value == null) return 'Unavailable';

    return '${value.toStringAsFixed(decimals)} $unit';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FA),
      appBar: AppBar(
        title: const Text('Sea Conditions'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: loading ? null : _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
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
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 52,
              color: AppTheme.oceanBlue,
            ),
            const SizedBox(height: 16),
            Text(
              error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF5E727B), height: 1.45),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content() {
    final d = data!;
    final p = position!;

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          _mapCard(p.latitude, p.longitude),
          const SizedBox(height: 16),
          _screeningCard(d),
          const SizedBox(height: 18),
          const Text(
            'Live marine conditions',
            style: TextStyle(
              color: AppTheme.navy,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 11),
          _grid(d),
          const SizedBox(height: 18),
          _evidenceCard(d),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.warning.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppTheme.warning,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    d.navigationNotice,
                    style: const TextStyle(
                      color: Color(0xFF6B6047),
                      fontSize: 12.5,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapCard(double latitude, double longitude) {
    final point = LatLng(latitude, longitude);

    return Container(
      height: 260,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFDCE8EC)),
      ),
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(initialCenter: point, initialZoom: 7.5),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.orca.marine_app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: point,
                    width: 50,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.oceanBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.16),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.navigation_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '${latitude.toStringAsFixed(4)}, '
                '${longitude.toStringAsFixed(4)}',
                style: const TextStyle(
                  color: AppTheme.navy,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _screeningCard(MarineConditionsData d) {
    final color = _statusColor(d.screeningStatus);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.shield_outlined, color: Colors.white),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prototype screening: '
                  '${d.screeningStatus}',
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  d.screeningReason,
                  style: const TextStyle(
                    color: Color(0xFF61747C),
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _grid(MarineConditionsData d) {
    final items = [
      ('Wave height', _value(d.waveHeightM, 'm'), Icons.waves_rounded),
      ('Wave period', _value(d.wavePeriodS, 's'), Icons.timelapse_rounded),
      ('Swell', _value(d.swellHeightM, 'm'), Icons.water_rounded),
      (
        'Sea temperature',
        _value(d.seaSurfaceTemperatureC, '°C'),
        Icons.thermostat_rounded,
      ),
      (
        'Ocean current',
        _value(d.oceanCurrentVelocityMs, 'm/s', decimals: 2),
        Icons.trending_up_rounded,
      ),
      ('Wind', _value(d.windSpeedMs, 'm/s'), Icons.air_rounded),
      ('Wind gust', _value(d.windGustMs, 'm/s'), Icons.storm_rounded),
      (
        'Sea level',
        _value(d.seaLevelHeightMslM, 'm', decimals: 2),
        Icons.height_rounded,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 11,
        mainAxisSpacing: 11,
        childAspectRatio: 1.42,
      ),
      itemBuilder: (_, index) {
        final item = items[index];

        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE0E9ED)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.$3, color: AppTheme.oceanBlue, size: 23),
              const Spacer(),
              Text(
                item.$1,
                style: const TextStyle(
                  color: Color(0xFF71838B),
                  fontSize: 11.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.$2,
                style: const TextStyle(
                  color: AppTheme.navy,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _evidenceCard(MarineConditionsData d) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE0E9ED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.fact_check_outlined, color: AppTheme.oceanBlue),
              SizedBox(width: 9),
              Text(
                'Evidence & freshness',
                style: TextStyle(
                  color: AppTheme.navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...d.evidence.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.source,
                    style: const TextStyle(
                      color: AppTheme.navy,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    e.modelTime == null
                        ? e.freshnessLabel
                        : '${e.freshnessLabel} • ${e.modelTime}',
                    style: const TextStyle(
                      color: Color(0xFF6F828A),
                      fontSize: 12,
                    ),
                  ),
                  if (e.note != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      e.note!,
                      style: const TextStyle(
                        color: Color(0xFF829199),
                        fontSize: 11.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Text(
            'Official India reference: '
            '${d.officialIndiaReference}',
            style: const TextStyle(
              color: AppTheme.oceanBlue,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
