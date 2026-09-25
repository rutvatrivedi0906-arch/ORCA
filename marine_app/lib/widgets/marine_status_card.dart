import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class MarineStatusCard extends StatelessWidget {
  const MarineStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF073B4C), Color(0xFF087EA4)],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: AppTheme.success),
                    SizedBox(width: 7),
                    Text(
                      'MARINE STATUS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(Icons.sync_rounded, size: 18, color: Colors.white70),
            ],
          ),

          const SizedBox(height: 22),

          const Text(
            'Conditions look stable',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'No critical marine warnings in your current mission area.',
            style: TextStyle(color: Colors.white70, height: 1.4),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              _statusItem('Wave', '1.1 m', Icons.waves_rounded),
              _statusItem('Wind', '12 km/h', Icons.air_rounded),
              _statusItem('Risk', 'Low', Icons.shield_outlined),
            ],
          ),

          const SizedBox(height: 18),

          const Row(
            children: [
              Icon(Icons.schedule_rounded, color: Colors.white60, size: 16),
              SizedBox(width: 6),
              Text(
                'Demo data • updated 24 min ago',
                style: TextStyle(color: Colors.white60, fontSize: 11.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusItem(String label, String value, IconData icon) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 7),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
