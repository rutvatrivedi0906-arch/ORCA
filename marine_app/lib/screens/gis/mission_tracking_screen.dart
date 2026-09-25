import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../core/theme/app_theme.dart';
import '../../models/gis_models.dart';
import '../../services/gis_service.dart';

class MissionTrackingScreen extends StatefulWidget {
  final RouteAlternativeData route;
  final double cruisingSpeedKnots;

  const MissionTrackingScreen({
    super.key,
    required this.route,
    required this.cruisingSpeedKnots,
  });

  @override
  State<MissionTrackingScreen> createState() => _MissionTrackingScreenState();
}

class _MissionTrackingScreenState extends State<MissionTrackingScreen> {
  final MapController mapController = MapController();

  StreamSubscription<Position>? subscription;
  Position? position;
  BoundaryCheckData? boundary;
  List<LatLng> track = [];

  double crossTrackNm = 0;
  double remainingNm = 0;
  double bearingToNext = 0;
  double etaMinutes = 0;
  double liveSpeedKnots = 0;
  int nextWaypointIndex = 0;
  int updateCount = 0;

  bool loading = true;
  String? error;

  List<LatLng> get routePoints => widget.route.waypoints
      .map((w) => LatLng(w.latitude, w.longitude))
      .toList();

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  Future<void> _start() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();

      if (!enabled) {
        throw Exception('Enable GPS to start mission tracking.');
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permission is required for live mission tracking.',
        );
      }

      const settings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 25,
      );

      final first = await Geolocator.getCurrentPosition(
        locationSettings: settings,
      );

      _consume(first);

      subscription = Geolocator.getPositionStream(locationSettings: settings)
          .listen(
            _consume,
            onError: (Object e) {
              if (mounted) {
                setState(() => error = e.toString());
              }
            },
          );

      if (mounted) {
        setState(() => loading = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _consume(Position p) {
    if (!mounted) return;

    final here = LatLng(p.latitude, p.longitude);

    final metrics = _progressMetrics(here);

    setState(() {
      position = p;
      track = [...track, here];
      crossTrackNm = metrics.$1;
      remainingNm = metrics.$2;
      nextWaypointIndex = metrics.$3;
      bearingToNext = metrics.$4;
      liveSpeedKnots = p.speed > 0.5
          ? p.speed * 1.94384449
          : widget.cruisingSpeedKnots;

      etaMinutes = liveSpeedKnots > 0 ? remainingNm / liveSpeedKnots * 60 : 0;
    });

    if (!loading) {
      mapController.move(here, 11);
    }

    updateCount += 1;

    if (updateCount == 1 || updateCount % 3 == 0) {
      _refreshBoundary(here);
    }
  }

  Future<void> _refreshBoundary(LatLng point) async {
    try {
      final result = await GisService.checkBoundary(
        latitude: point.latitude,
        longitude: point.longitude,
      );

      if (!mounted) return;

      setState(() => boundary = result);
    } catch (_) {
      // Live tracking continues even if boundary refresh fails.
    }
  }

  (double, double, int, double) _progressMetrics(LatLng here) {
    final points = routePoints;

    if (points.length < 2) {
      return (0, 0, 0, 0);
    }

    double bestSegmentDistanceKm = double.infinity;
    int bestSegment = 0;

    for (var i = 0; i < points.length - 1; i++) {
      final d = _pointSegmentDistanceKm(here, points[i], points[i + 1]);

      if (d < bestSegmentDistanceKm) {
        bestSegmentDistanceKm = d;
        bestSegment = i;
      }
    }

    final nextIndex = math.min(bestSegment + 1, points.length - 1);

    var remainingKm = _haversineKm(here, points[nextIndex]);

    for (var i = nextIndex; i < points.length - 1; i++) {
      remainingKm += _haversineKm(points[i], points[i + 1]);
    }

    final bearing = _bearing(here, points[nextIndex]);

    return (
      bestSegmentDistanceKm / 1.852,
      remainingKm / 1.852,
      nextIndex,
      bearing,
    );
  }

  double _haversineKm(LatLng a, LatLng b) {
    const radius = 6371.0088;

    final p1 = _rad(a.latitude);
    final p2 = _rad(b.latitude);
    final dp = _rad(b.latitude - a.latitude);
    final dl = _rad(b.longitude - a.longitude);

    final h =
        math.sin(dp / 2) * math.sin(dp / 2) +
        math.cos(p1) * math.cos(p2) * math.sin(dl / 2) * math.sin(dl / 2);

    return 2 * radius * math.asin(math.min(1, math.sqrt(h)));
  }

  double _bearing(LatLng a, LatLng b) {
    final p1 = _rad(a.latitude);
    final p2 = _rad(b.latitude);
    final dl = _rad(b.longitude - a.longitude);

    final y = math.sin(dl) * math.cos(p2);
    final x =
        math.cos(p1) * math.sin(p2) -
        math.sin(p1) * math.cos(p2) * math.cos(dl);

    return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
  }

  double _pointSegmentDistanceKm(LatLng p, LatLng a, LatLng b) {
    const radius = 6371.0088;
    final refLat = _rad((p.latitude + a.latitude + b.latitude) / 3);

    (double, double) xy(LatLng point) {
      return (
        _rad(point.longitude) * radius * math.cos(refLat),
        _rad(point.latitude) * radius,
      );
    }

    final pp = xy(p);
    final aa = xy(a);
    final bb = xy(b);

    final dx = bb.$1 - aa.$1;
    final dy = bb.$2 - aa.$2;

    if (dx == 0 && dy == 0) {
      return math.sqrt(math.pow(pp.$1 - aa.$1, 2) + math.pow(pp.$2 - aa.$2, 2));
    }

    var t = ((pp.$1 - aa.$1) * dx + (pp.$2 - aa.$2) * dy) / (dx * dx + dy * dy);

    t = t.clamp(0.0, 1.0).toDouble();

    final cx = aa.$1 + t * dx;
    final cy = aa.$2 + t * dy;

    return math.sqrt(math.pow(pp.$1 - cx, 2) + math.pow(pp.$2 - cy, 2));
  }

  double _rad(double value) => value * math.pi / 180;

  bool get routeDeviation => crossTrackNm > 0.5;

  bool get boundaryWarning =>
      boundary?.status == 'NEAR' || boundary?.status == 'INSIDE';

  String _etaText() {
    final minutes = etaMinutes.round();
    final h = minutes ~/ 60;
    final m = minutes % 60;

    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  Future<void> _stopMission() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop mission?'),
        content: const Text('Live GPS route tracking will end.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continue'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Stop Mission'),
          ),
        ],
      ),
    );

    if (yes != true) return;

    await subscription?.cancel();

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FA),
      appBar: AppBar(
        title: const Text('Mission Tracking'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _stopMission,
            child: const Text(
              'STOP',
              style: TextStyle(
                color: AppTheme.danger,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(error!, textAlign: TextAlign.center),
              ),
            )
          : _content(),
    );
  }

  Widget _content() {
    final here = position == null
        ? routePoints.first
        : LatLng(position!.latitude, position!.longitude);

    final safeNextIndex = nextWaypointIndex
        .clamp(0, widget.route.waypoints.length - 1)
        .toInt();

    final next = widget.route.waypoints[safeNextIndex];

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
      children: [
        if (routeDeviation)
          _warningCard(
            'ROUTE DEVIATION',
            'You are ${crossTrackNm.toStringAsFixed(2)} nm from the planned corridor.',
            AppTheme.danger,
          ),
        if (boundaryWarning)
          _warningCard(
            'BOUNDARY APPROACH',
            boundary!.message,
            AppTheme.warning,
          ),
        Container(
          height: 360,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFDCE8EC)),
          ),
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(initialCenter: here, initialZoom: 11),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.orca.marine_app',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints,
                    strokeWidth: 5,
                    color: AppTheme.oceanBlue,
                  ),
                  if (track.length > 1)
                    Polyline(
                      points: track,
                      strokeWidth: 4,
                      color: AppTheme.success,
                    ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: here,
                    width: 50,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: const Icon(
                        Icons.navigation_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.navy,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'NEXT WAYPOINT',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                '${bearingToNext.toStringAsFixed(0)}° • '
                '${_haversineKm(here, LatLng(next.latitude, next.longitude)).toStringAsFixed(1)} km',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Waypoint ${nextWaypointIndex + 1} of '
                '${widget.route.waypoints.length}',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _metric(
                'Remaining',
                '${remainingNm.toStringAsFixed(1)} nm',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: _metric('Updated ETA', _etaText())),
            const SizedBox(width: 10),
            Expanded(
              child: _metric(
                'Off route',
                '${crossTrackNm.toStringAsFixed(2)} nm',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _metric(
          'Live / planned speed',
          '${liveSpeedKnots.toStringAsFixed(1)} kn',
        ),
        const SizedBox(height: 12),
        _conditionCard(next.condition),
      ],
    );
  }

  Widget _warningCard(String title, String body, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_rounded, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: color, fontWeight: FontWeight.w900),
                ),
                Text(
                  body,
                  style: const TextStyle(
                    color: Color(0xFF5E727B),
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE1EAED)),
      ),
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.navy,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF788A92), fontSize: 10.5),
          ),
        ],
      ),
    );
  }

  Widget _conditionCard(RouteConditionData c) {
    String v(double? number, String unit) {
      if (number == null) return '--';
      return '${number.toStringAsFixed(1)} $unit';
    }

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1EAED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Conditions near next waypoint',
            style: TextStyle(
              color: AppTheme.navy,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Waves ${v(c.waveHeightM, 'm')} • '
            'Wind ${v(c.windSpeedMs, 'm/s')} • '
            'Current ${v(c.currentVelocityMs, 'm/s')}',
            style: const TextStyle(color: Color(0xFF62767E), height: 1.45),
          ),
        ],
      ),
    );
  }
}
