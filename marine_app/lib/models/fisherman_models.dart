class FishermanProfileData {
  final String userId;
  final String fullName;
  final String? phoneNumber;
  final bool phoneVerified;
  final String? fisherId;
  final String preferredLanguage;
  final String? homeLandingCentre;
  final String? emergencyContactName;
  final String? emergencyContactPhone;

  const FishermanProfileData({
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.phoneVerified,
    required this.fisherId,
    required this.preferredLanguage,
    required this.homeLandingCentre,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
  });

  factory FishermanProfileData.fromJson(Map<String, dynamic> json) {
    return FishermanProfileData(
      userId: json['user_id'].toString(),
      fullName: json['full_name'] as String,
      phoneNumber: json['phone_number'] as String?,
      phoneVerified: json['phone_verified'] as bool,
      fisherId: json['fisher_id'] as String?,
      preferredLanguage: json['preferred_language'] as String,
      homeLandingCentre: json['home_landing_centre'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
    );
  }
}

class VesselData {
  final String id;
  final String ownerId;
  final String name;
  final String? registrationNumber;
  final String? vesselType;
  final double? lengthM;
  final double? beamM;
  final double? cruisingSpeedKnots;
  final int personsOnboardDefault;

  const VesselData({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.registrationNumber,
    required this.vesselType,
    required this.lengthM,
    required this.beamM,
    required this.cruisingSpeedKnots,
    required this.personsOnboardDefault,
  });

  factory VesselData.fromJson(Map<String, dynamic> json) {
    double? asDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    return VesselData(
      id: json['id'].toString(),
      ownerId: json['owner_id'].toString(),
      name: json['name'] as String,
      registrationNumber: json['registration_number'] as String?,
      vesselType: json['vessel_type'] as String?,
      lengthM: asDouble(json['length_m']),
      beamM: asDouble(json['beam_m']),
      cruisingSpeedKnots: asDouble(json['cruising_speed_knots']),
      personsOnboardDefault: json['persons_onboard_default'] as int,
    );
  }
}
