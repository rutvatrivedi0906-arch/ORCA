class MarineEvidenceData {
  final String source;
  final String sourceUrl;
  final String? modelTime;
  final String fetchedAt;
  final String freshnessLabel;
  final String? note;

  const MarineEvidenceData({
    required this.source,
    required this.sourceUrl,
    required this.modelTime,
    required this.fetchedAt,
    required this.freshnessLabel,
    required this.note,
  });

  factory MarineEvidenceData.fromJson(Map<String, dynamic> json) {
    return MarineEvidenceData(
      source: json['source'] as String,
      sourceUrl: json['source_url'] as String,
      modelTime: json['model_time'] as String?,
      fetchedAt: json['fetched_at'] as String,
      freshnessLabel: json['freshness_label'] as String,
      note: json['note'] as String?,
    );
  }
}

class MarineConditionsData {
  final double requestedLatitude;
  final double requestedLongitude;
  final double? gridLatitude;
  final double? gridLongitude;

  final double? waveHeightM;
  final double? waveDirectionDeg;
  final double? wavePeriodS;
  final double? swellHeightM;
  final double? seaSurfaceTemperatureC;
  final double? oceanCurrentVelocityMs;
  final double? oceanCurrentDirectionDeg;
  final double? seaLevelHeightMslM;
  final double? windSpeedMs;
  final double? windDirectionDeg;
  final double? windGustMs;

  final String screeningStatus;
  final String screeningReason;
  final bool screeningIsPrototype;
  final String officialIndiaReference;
  final String navigationNotice;
  final List<MarineEvidenceData> evidence;

  const MarineConditionsData({
    required this.requestedLatitude,
    required this.requestedLongitude,
    required this.gridLatitude,
    required this.gridLongitude,
    required this.waveHeightM,
    required this.waveDirectionDeg,
    required this.wavePeriodS,
    required this.swellHeightM,
    required this.seaSurfaceTemperatureC,
    required this.oceanCurrentVelocityMs,
    required this.oceanCurrentDirectionDeg,
    required this.seaLevelHeightMslM,
    required this.windSpeedMs,
    required this.windDirectionDeg,
    required this.windGustMs,
    required this.screeningStatus,
    required this.screeningReason,
    required this.screeningIsPrototype,
    required this.officialIndiaReference,
    required this.navigationNotice,
    required this.evidence,
  });

  static double? _double(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  factory MarineConditionsData.fromJson(Map<String, dynamic> json) {
    final rawEvidence = json['evidence'] as List<dynamic>? ?? const [];

    return MarineConditionsData(
      requestedLatitude: _double(json['requested_latitude'])!,
      requestedLongitude: _double(json['requested_longitude'])!,
      gridLatitude: _double(json['grid_latitude']),
      gridLongitude: _double(json['grid_longitude']),
      waveHeightM: _double(json['wave_height_m']),
      waveDirectionDeg: _double(json['wave_direction_deg']),
      wavePeriodS: _double(json['wave_period_s']),
      swellHeightM: _double(json['swell_height_m']),
      seaSurfaceTemperatureC: _double(json['sea_surface_temperature_c']),
      oceanCurrentVelocityMs: _double(json['ocean_current_velocity_ms']),
      oceanCurrentDirectionDeg: _double(json['ocean_current_direction_deg']),
      seaLevelHeightMslM: _double(json['sea_level_height_msl_m']),
      windSpeedMs: _double(json['wind_speed_ms']),
      windDirectionDeg: _double(json['wind_direction_deg']),
      windGustMs: _double(json['wind_gust_ms']),
      screeningStatus: json['screening_status'] as String,
      screeningReason: json['screening_reason'] as String,
      screeningIsPrototype: json['screening_is_prototype'] as bool? ?? true,
      officialIndiaReference: json['official_india_reference'] as String,
      navigationNotice: json['navigation_notice'] as String,
      evidence: rawEvidence
          .whereType<Map<String, dynamic>>()
          .map(MarineEvidenceData.fromJson)
          .toList(),
    );
  }
}
