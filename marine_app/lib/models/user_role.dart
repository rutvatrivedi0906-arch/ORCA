import 'package:flutter/material.dart';

enum UserRole { fisherman, researcher, authority, admin }

extension UserRoleExtension on UserRole {
  String get title {
    switch (this) {
      case UserRole.fisherman:
        return 'Fisherman';
      case UserRole.researcher:
        return 'Marine Researcher';
      case UserRole.authority:
        return 'Coastal Authority';
      case UserRole.admin:
        return 'Administrator';
    }
  }

  String get description {
    switch (this) {
      case UserRole.fisherman:
        return 'Marine safety, trip planning, offline intelligence and emergency support.';
      case UserRole.researcher:
        return 'Explore marine datasets, anomalies and environmental trends.';
      case UserRole.authority:
        return 'Monitor marine hazards, alerts and emergency incidents.';
      case UserRole.admin:
        return 'Monitor ORCA services, datasets and system health.';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.fisherman:
        return Icons.sailing_rounded;
      case UserRole.researcher:
        return Icons.science_rounded;
      case UserRole.authority:
        return Icons.shield_rounded;
      case UserRole.admin:
        return Icons.admin_panel_settings_rounded;
    }
  }
}
