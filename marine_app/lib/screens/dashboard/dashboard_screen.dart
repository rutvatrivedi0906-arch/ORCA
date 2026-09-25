import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/user_role.dart';
import '../../widgets/feature_card.dart';
import '../../widgets/marine_status_card.dart';

class DashboardScreen extends StatelessWidget {
  final UserRole role;

  const DashboardScreen({super.key, required this.role});

  void comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          '$feature will be connected in the next development phase.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case UserRole.fisherman:
        return _buildFishermanDashboard(context);

      case UserRole.researcher:
        return _buildResearcherDashboard(context);

      case UserRole.authority:
        return _buildAuthorityDashboard(context);

      case UserRole.admin:
        return _buildAdminDashboard(context);
    }
  }

  Widget _buildFishermanDashboard(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
          children: [
            _topBar(
              title: 'Good morning',
              subtitle: 'Ready for your next marine mission?',
            ),

            const SizedBox(height: 22),

            const MarineStatusCard(),

            const SizedBox(height: 26),

            _sectionTitle('Ask ORCA', 'Your marine intelligence assistant'),

            const SizedBox(height: 12),

            InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => comingSoon(context, 'ORCA Assistant'),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.navy,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.mic_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ask anything about the sea',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Weather, route, safety, tides or marine conditions.',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12.5,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            _sectionTitle('Mission tools', 'Plan and operate your trip'),

            const SizedBox(height: 12),

            _quickGrid(context, [
              _QuickAction(
                'Plan Trip',
                Icons.route_rounded,
                AppTheme.oceanBlue,
              ),
              _QuickAction(
                'Sea Conditions',
                Icons.water_rounded,
                AppTheme.cyan,
              ),
              _QuickAction(
                'Alerts',
                Icons.warning_amber_rounded,
                AppTheme.warning,
              ),
              _QuickAction(
                'Offline Mission',
                Icons.offline_pin_rounded,
                const Color(0xFF6C63FF),
              ),
            ]),

            const SizedBox(height: 28),

            _sectionTitle('Safety', 'Operational protection and boundaries'),

            const SizedBox(height: 12),

            FeatureCard(
              title: 'Boundary Guardian',
              subtitle: 'Monitor restricted zones and maritime boundaries.',
              icon: Icons.public_rounded,
              onTap: () => comingSoon(context, 'Boundary Guardian'),
            ),

            const SizedBox(height: 12),

            FeatureCard(
              title: 'Mission Simulation',
              subtitle:
                  'Preview changing conditions across your trip timeline.',
              icon: Icons.timeline_rounded,
              onTap: () => comingSoon(context, 'Mission Simulation'),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: FloatingActionButton.extended(
            backgroundColor: AppTheme.danger,
            foregroundColor: Colors.white,
            elevation: 2,
            onPressed: () => comingSoon(context, 'Emergency SOS'),
            icon: const Icon(Icons.sos_rounded, size: 28),
            label: const Text(
              'EMERGENCY SOS',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResearcherDashboard(BuildContext context) {
    return _standardDashboard(
      context,
      heading: 'Marine Research',
      subtitle: 'Explore environmental conditions and historical patterns.',
      features: [
        FeatureCard(
          title: 'Ask ORCA Research',
          subtitle: 'Explore marine datasets using natural language.',
          icon: Icons.auto_awesome_rounded,
          onTap: () => comingSoon(context, 'Research Assistant'),
        ),
        FeatureCard(
          title: 'Data Explorer',
          subtitle: 'Analyze SST, chlorophyll, currents and waves.',
          icon: Icons.layers_rounded,
          onTap: () => comingSoon(context, 'Data Explorer'),
        ),
        FeatureCard(
          title: 'Productivity Investigator',
          subtitle: 'Investigate environmental changes over time.',
          icon: Icons.analytics_rounded,
          onTap: () => comingSoon(context, 'Productivity Investigator'),
        ),
        FeatureCard(
          title: 'Anomaly Detection',
          subtitle: 'Detect unusual marine environmental conditions.',
          icon: Icons.show_chart_rounded,
          onTap: () => comingSoon(context, 'Anomaly Detection'),
        ),
        FeatureCard(
          title: 'Reports',
          subtitle: 'Generate evidence-backed marine analysis.',
          icon: Icons.description_rounded,
          onTap: () => comingSoon(context, 'Reports'),
        ),
      ],
    );
  }

  Widget _buildAuthorityDashboard(BuildContext context) {
    return _standardDashboard(
      context,
      heading: 'Marine Command Centre',
      subtitle: 'Monitor hazards and respond to emergencies.',
      features: [
        FeatureCard(
          title: 'Active SOS',
          subtitle: 'View incoming fisherman emergency incidents.',
          icon: Icons.sos_rounded,
          color: AppTheme.danger,
          onTap: () => comingSoon(context, 'SOS Command Centre'),
        ),
        FeatureCard(
          title: 'Hazard Map',
          subtitle: 'Monitor waves, weather and hazardous zones.',
          icon: Icons.map_rounded,
          onTap: () => comingSoon(context, 'Hazard Map'),
        ),
        FeatureCard(
          title: 'Marine Alerts',
          subtitle: 'Review active advisories and safety warnings.',
          icon: Icons.warning_rounded,
          color: AppTheme.warning,
          onTap: () => comingSoon(context, 'Marine Alerts'),
        ),
        FeatureCard(
          title: 'Geofences',
          subtitle: 'Manage restricted and operational areas.',
          icon: Icons.fence_rounded,
          onTap: () => comingSoon(context, 'Geofences'),
        ),
        FeatureCard(
          title: 'Incident History',
          subtitle: 'Review previous emergency incidents.',
          icon: Icons.history_rounded,
          onTap: () => comingSoon(context, 'Incident History'),
        ),
      ],
    );
  }

  Widget _buildAdminDashboard(BuildContext context) {
    return _standardDashboard(
      context,
      heading: 'ORCA Administration',
      subtitle: 'System monitoring and platform management.',
      features: [
        FeatureCard(
          title: 'Dataset Health',
          subtitle: 'Monitor dataset freshness and ingestion.',
          icon: Icons.storage_rounded,
          onTap: () => comingSoon(context, 'Dataset Health'),
        ),
        FeatureCard(
          title: 'Model Registry',
          subtitle: 'Review deployed model versions and metrics.',
          icon: Icons.psychology_rounded,
          onTap: () => comingSoon(context, 'Model Registry'),
        ),
        FeatureCard(
          title: 'Agent Monitoring',
          subtitle: 'Inspect agent tasks and execution status.',
          icon: Icons.hub_rounded,
          onTap: () => comingSoon(context, 'Agent Monitoring'),
        ),
        FeatureCard(
          title: 'System Health',
          subtitle: 'Monitor backend and database services.',
          icon: Icons.monitor_heart_rounded,
          onTap: () => comingSoon(context, 'System Health'),
        ),
      ],
    );
  }

  Widget _standardDashboard(
    BuildContext context, {
    required String heading,
    required String subtitle,
    required List<Widget> features,
  }) {
    return Scaffold(
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: features.length + 1,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: _topBar(title: heading, subtitle: subtitle),
              );
            }

            return features[index - 1];
          },
        ),
      ),
    );
  }

  Widget _topBar({required String title, required String subtitle}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.navy,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
        ),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFE3EBEF)),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppTheme.navy,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.navy,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.black45, fontSize: 12.5),
        ),
      ],
    );
  }

  Widget _quickGrid(BuildContext context, List<_QuickAction> actions) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];

        return InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => comingSoon(context, action.title),
          child: Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE4EDF1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: action.color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(action.icon, color: action.color),
                ),
                const Spacer(),
                Text(
                  action.title,
                  style: const TextStyle(
                    color: AppTheme.navy,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuickAction {
  final String title;
  final IconData icon;
  final Color color;

  const _QuickAction(this.title, this.icon, this.color);
}
