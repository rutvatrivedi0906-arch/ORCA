class BoundaryZoneData {
  final String id;
  final String name;
  final String category;
  final bool isDemo;
  final List<List<double>> coordinates;
  final String note;

  const BoundaryZoneData({
    required this.id,
    required this.name,
    required this.category,
    required this.isDemo,
    required this.coordinates,
    required this.note,
  });

  factory BoundaryZoneData.fromJson(Map<String, dynamic> json) {
    final raw = json['coordinates'] as List<dynamic>? ?? const [];

    return BoundaryZoneData(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      isDemo: json['is_demo'] as bool? ?? true,
      coordinates: raw
          .whereType<List<dynamic>>()
          .map((pair) => pair.map((v) => (v as num).toDouble()).toList())
          .toList(),
      note: json['note'] as String,
    );
  }
}

class MaritimeZoneData {
  final String label;
  final String status;
  final String? zoneName;
  final double? distanceToLimitKm;
  final String? distanceLabel;
  final String source;
  final String sourceNote;

  const MaritimeZoneData({
    required this.label,
    required this.status,
    required this.zoneName,
    required this.distanceToLimitKm,
    required this.distanceLabel,
    required this.source,
    required this.sourceNote,
  });

  static double? _d(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  factory MaritimeZoneData.fromJson(Map<String, dynamic> json) {
    return MaritimeZoneData(
      label: json['label'] as String,
      status: json['status'] as String,
      zoneName: json['zone_name'] as String?,
      distanceToLimitKm: _d(json['distance_to_limit_km']),
      distanceLabel: json['distance_label'] as String?,
      source: json['source'] as String,
      sourceNote: json['source_note'] as String,
    );
  }
}

class BoundaryCheckData {
  final double latitude;
  final double longitude;
  final String surface;
  final String status;

  final double? coastDistanceKm;
  final String? coastDistanceNote;

  final MaritimeZoneData? territorialSea;
  final MaritimeZoneData? eez;

  final String? nearestZoneId;
  final String? nearestZoneName;
  final double? distanceToZoneKm;
  final bool insideZone;
  final String message;

  final String landMaskNote;
  final String maritimeBoundaryNote;
  final String restrictedAreaNote;
  final String temporaryHazardNote;
  final bool isDemoBoundaryData;

  const BoundaryCheckData({
    required this.latitude,
    required this.longitude,
    required this.surface,
    required this.status,
    required this.coastDistanceKm,
    required this.coastDistanceNote,
    required this.territorialSea,
    required this.eez,
    required this.nearestZoneId,
    required this.nearestZoneName,
    required this.distanceToZoneKm,
    required this.insideZone,
    required this.message,
    required this.landMaskNote,
    required this.maritimeBoundaryNote,
    required this.restrictedAreaNote,
    required this.temporaryHazardNote,
    required this.isDemoBoundaryData,
  });

  static double? _d(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  factory BoundaryCheckData.fromJson(Map<String, dynamic> json) {
    final territorial = json['territorial_sea'];
    final eez = json['eez'];

    return BoundaryCheckData(
      latitude: _d(json['latitude'])!,
      longitude: _d(json['longitude'])!,
      surface: json['surface'] as String,
      status: json['status'] as String,
      coastDistanceKm: _d(json['coast_distance_km']),
      coastDistanceNote: json['coast_distance_note'] as String?,
      territorialSea: territorial is Map<String, dynamic>
          ? MaritimeZoneData.fromJson(territorial)
          : null,
      eez: eez is Map<String, dynamic> ? MaritimeZoneData.fromJson(eez) : null,
      nearestZoneId: json['nearest_zone_id'] as String?,
      nearestZoneName: json['nearest_zone_name'] as String?,
      distanceToZoneKm: _d(json['distance_to_zone_km']),
      insideZone: json['inside_zone'] as bool? ?? false,
      message: json['message'] as String,
      landMaskNote: json['land_mask_note'] as String,
      maritimeBoundaryNote: json['maritime_boundary_note'] as String,
      restrictedAreaNote: json['restricted_area_note'] as String,
      temporaryHazardNote: json['temporary_hazard_note'] as String,
      isDemoBoundaryData: json['is_demo_boundary_data'] as bool? ?? true,
    );
  }
}

class RouteConditionData {
  final double? waveHeightM;
  final double? waveDirectionDeg;
  final double? wavePeriodS;
  final double? windSpeedMs;
  final double? windDirectionDeg;
  final double? windGustMs;
  final double? currentVelocityMs;
  final double? currentDirectionDeg;

  const RouteConditionData({
    required this.waveHeightM,
    required this.waveDirectionDeg,
    required this.wavePeriodS,
    required this.windSpeedMs,
    required this.windDirectionDeg,
    required this.windGustMs,
    required this.currentVelocityMs,
    required this.currentDirectionDeg,
  });

  static double? _d(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  factory RouteConditionData.fromJson(Map<String, dynamic> json) {
    return RouteConditionData(
      waveHeightM: _d(json['wave_height_m']),
      waveDirectionDeg: _d(json['wave_direction_deg']),
      wavePeriodS: _d(json['wave_period_s']),
      windSpeedMs: _d(json['wind_speed_ms']),
      windDirectionDeg: _d(json['wind_direction_deg']),
      windGustMs: _d(json['wind_gust_ms']),
      currentVelocityMs: _d(json['current_velocity_ms']),
      currentDirectionDeg: _d(json['current_direction_deg']),
    );
  }
}

class RouteWaypointData {
  final double latitude;
  final double longitude;
  final int sequence;
  final RouteConditionData condition;

  const RouteWaypointData({
    required this.latitude,
    required this.longitude,
    required this.sequence,
    required this.condition,
  });

  factory RouteWaypointData.fromJson(Map<String, dynamic> json) {
    return RouteWaypointData(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      sequence: json['sequence'] as int,
      condition: RouteConditionData.fromJson(
        json['condition'] as Map<String, dynamic>,
      ),
    );
  }
}

class RouteAlternativeData {
  final String routeId;
  final String title;
  final double distanceNm;
  final double etaMinutes;
  final double exposureScore;
  final double? maxWaveHeightM;
  final double? maxWindSpeedMs;
  final double? maxWindGustMs;
  final double? averageCurrentMs;
  final String routeStatus;
  final String routeMessage;
  final List<String> rationale;
  final List<RouteWaypointData> waypoints;

  const RouteAlternativeData({
    required this.routeId,
    required this.title,
    required this.distanceNm,
    required this.etaMinutes,
    required this.exposureScore,
    required this.maxWaveHeightM,
    required this.maxWindSpeedMs,
    required this.maxWindGustMs,
    required this.averageCurrentMs,
    required this.routeStatus,
    required this.routeMessage,
    required this.rationale,
    required this.waypoints,
  });

  static double? _d(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  factory RouteAlternativeData.fromJson(Map<String, dynamic> json) {
    final points = json['waypoints'] as List<dynamic>? ?? const [];

    return RouteAlternativeData(
      routeId: json['route_id'] as String,
      title: json['title'] as String,
      distanceNm: (json['distance_nm'] as num).toDouble(),
      etaMinutes: (json['eta_minutes'] as num).toDouble(),
      exposureScore: (json['exposure_score'] as num).toDouble(),
      maxWaveHeightM: _d(json['max_wave_height_m']),
      maxWindSpeedMs: _d(json['max_wind_speed_ms']),
      maxWindGustMs: _d(json['max_wind_gust_ms']),
      averageCurrentMs: _d(json['average_current_ms']),
      routeStatus: json['route_status'] as String,
      routeMessage: json['route_message'] as String,
      rationale: (json['rationale'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      waypoints: points
          .whereType<Map<String, dynamic>>()
          .map(RouteWaypointData.fromJson)
          .toList(),
    );
  }
}

class RoutePlanData {
  final String startSurface;
  final String endSurface;
  final RouteAlternativeData fastest;
  final RouteAlternativeData lowerExposure;
  final String dataSource;
  final String dataFreshness;
  final String modelNote;
  final String demoBoundaryNote;
  final String navigationNotice;

  const RoutePlanData({
    required this.startSurface,
    required this.endSurface,
    required this.fastest,
    required this.lowerExposure,
    required this.dataSource,
    required this.dataFreshness,
    required this.modelNote,
    required this.demoBoundaryNote,
    required this.navigationNotice,
  });

  factory RoutePlanData.fromJson(Map<String, dynamic> json) {
    return RoutePlanData(
      startSurface: json['start_surface'] as String,
      endSurface: json['end_surface'] as String,
      fastest: RouteAlternativeData.fromJson(
        json['fastest'] as Map<String, dynamic>,
      ),
      lowerExposure: RouteAlternativeData.fromJson(
        json['lower_exposure'] as Map<String, dynamic>,
      ),
      dataSource: json['data_source'] as String,
      dataFreshness: json['data_freshness'] as String,
      modelNote: json['model_note'] as String,
      demoBoundaryNote: json['demo_boundary_note'] as String,
      navigationNotice: json['navigation_notice'] as String,
    );
  }
}
