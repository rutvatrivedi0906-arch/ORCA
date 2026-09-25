import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'language_screen.dart';
import 'onboarding_guide_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _getStarted() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (_, animation, _) => const LanguageScreen(),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
      ),
    );
  }

  void _openGuide() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const OnboardingGuideScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FA),
      body: FadeTransition(
        opacity: _fade,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _hero()),
            SliverToBoxAdapter(child: _roles()),
            SliverToBoxAdapter(child: _whyOrca()),
            SliverToBoxAdapter(child: _pipeline()),
            SliverToBoxAdapter(child: _trust()),
            SliverToBoxAdapter(child: _impact()),
            SliverToBoxAdapter(child: _research()),
            SliverToBoxAdapter(child: _finalCta()),
          ],
        ),
      ),
    );
  }

  Widget _hero() {
    return Container(
      constraints: const BoxConstraints(minHeight: 760),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF03131F),
            Color(0xFF062E44),
            Color(0xFF087EA4),
            Color(0xFF0E9D91),
          ],
          stops: [0, 0.35, 0.72, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -80,
            child: _glow(310, Colors.cyan.withValues(alpha: 0.10)),
          ),
          Positioned(
            bottom: 40,
            left: -120,
            child: _glow(360, Colors.white.withValues(alpha: 0.06)),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 42),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.waves_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'AGENTIC MARINE INTELLIGENCE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    'ORCA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 58,
                      height: 0.95,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Marine intelligence\nthat travels with you.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      height: 1.16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'One platform for fishermen, marine researchers, coastal authorities and administrators — turning ocean, weather and geospatial data into explainable decisions.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.76),
                      fontSize: 15.5,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Wrap(
                    spacing: 9,
                    runSpacing: 9,
                    children: [
                      _HeroBadge(
                        icon: Icons.cloud_off_rounded,
                        text: 'Offline-first',
                      ),
                      _HeroBadge(
                        icon: Icons.auto_awesome_rounded,
                        text: 'Agentic',
                      ),
                      _HeroBadge(
                        icon: Icons.fact_check_outlined,
                        text: 'Evidence-backed',
                      ),
                      _HeroBadge(
                        icon: Icons.translate_rounded,
                        text: 'Multilingual',
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: FilledButton(
                      onPressed: _getStarted,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.navy,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward_rounded),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed: _openGuide,
                      icon: const Icon(Icons.play_circle_outline_rounded),
                      label: const Text('How ORCA Works'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.28),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  Row(
                    children: [
                      Expanded(
                        child: _metric('4', 'role-specific\nworkspaces'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _metric(
                          '1',
                          'shared marine\nintelligence layer',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _metric(
                          '24/7',
                          'decision support\nwhen data is valid',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roles() {
    return _section(
      eyebrow: 'BUILT AROUND REAL USERS',
      title: 'One platform. Four operational views.',
      subtitle: 'Each user gets a workflow designed for their actual task instead of a generic dashboard.',
      child: const Column(
        children: [
          _RoleCard(
            icon: Icons.phishing_rounded,
            title: 'Fisherman',
            text: 'Simple sea conditions, safer trip planning, offline Mission Packs, Boundary Guardian and SOS support.',
            accent: Color(0xFF087EA4),
          ),
          SizedBox(height: 12),
          _RoleCard(
            icon: Icons.science_rounded,
            title: 'Marine Researcher',
            text: 'Scientific data layers, anomaly analysis, spatial-temporal comparison, productivity investigation and evidence-backed reporting.',
            accent: Color(0xFF237A67),
          ),
          SizedBox(height: 12),
          _RoleCard(
            icon: Icons.health_and_safety_rounded,
            title: 'Coastal Authority / Rescue',
            text: 'SOS command map, hazard awareness, incident lifecycle, advisories and geofence management.',
            accent: Color(0xFFC75A32),
          ),
          SizedBox(height: 12),
          _RoleCard(
            icon: Icons.admin_panel_settings_rounded,
            title: 'Administrator',
            text: 'Dataset freshness, model versions, agent execution, role management and platform health.',
            accent: Color(0xFF6754A4),
          ),
        ],
      ),
    );
  }

  Widget _whyOrca() {
    return _section(
      dark: true,
      eyebrow: 'WHY ORCA',
      title: 'From fragmented marine data to one explainable decision layer.',
      subtitle: 'ORCA coordinates satellite, ocean, weather and geospatial information through specialized agents, models and deterministic GIS tools.',
      child: const Column(
        children: [
          _DarkFeature(
            icon: Icons.hub_rounded,
            title: 'Agentic coordination',
            text: 'A planner selects the right marine tools, datasets and domain models for the task instead of forcing every problem through one model.',
          ),
          SizedBox(height: 14),
          _DarkFeature(
            icon: Icons.map_outlined,
            title: 'Geospatial reasoning',
            text: 'Routes, boundaries, restricted zones, hazards and spatial relationships are handled with GIS logic rather than language-model guesswork.',
          ),
          SizedBox(height: 14),
          _DarkFeature(
            icon: Icons.fact_check_outlined,
            title: 'Explainable outcomes',
            text: 'Recommendations can carry evidence, freshness, validity and confidence so users understand why ORCA reached a conclusion.',
          ),
          SizedBox(height: 14),
          _DarkFeature(
            icon: Icons.translate_rounded,
            title: 'Language-first usability',
            text: 'Role guides can be read and spoken in regional languages so marine intelligence is easier to understand.',
          ),
        ],
      ),
    );
  }

  Widget _pipeline() {
    return _section(
      eyebrow: 'DATA → REASONING → ACTION',
      title: 'A marine intelligence pipeline, not just a chatbot.',
      subtitle: 'ORCA separates scientific calculation from natural-language explanation.',
      child: const Column(
        children: [
          _PipelineCard(
            number: '01',
            title: 'Marine data',
            text: 'SST, chlorophyll-a, waves and swell, wind, currents, tides, bathymetry, PFZ history, weather alerts and geospatial boundaries.',
          ),
          SizedBox(height: 12),
          _PipelineCard(
            number: '02',
            title: 'Domain intelligence',
            text: 'PFZ models, risk logic, anomaly detection, route optimization, geofencing and mission simulation.',
          ),
          SizedBox(height: 12),
          _PipelineCard(
            number: '03',
            title: 'Agent collaboration',
            text: 'Specialized agents discover data, plan tool use, combine evidence and prepare role-specific outcomes.',
          ),
          SizedBox(height: 12),
          _PipelineCard(
            number: '04',
            title: 'Human decision support',
            text: 'Maps, charts, routes, alerts, advisories, reports and multilingual explanations designed for the user in front of ORCA.',
          ),
        ],
      ),
    );
  }

  Widget _trust() {
    return _section(
      eyebrow: 'OFFLINE-FIRST + TRUST',
      title: 'Designed for the moment connectivity disappears.',
      subtitle: 'ORCA should not assume reliable offshore connectivity, and it should never hide uncertainty.',
      child: const Column(
        children: [
          _LightFeature(
            icon: Icons.download_for_offline_rounded,
            title: 'Sea Mission Pack',
            text: 'Carry route geometry, offline map, hazards, geofences, forecast layers and evidence needed for a planned mission.',
          ),
          SizedBox(height: 12),
          _LightFeature(
            icon: Icons.schedule_rounded,
            title: 'Freshness and validity',
            text: 'Users can see when data was updated and whether a forecast is still valid for the decision being made.',
          ),
          SizedBox(height: 12),
          _LightFeature(
            icon: Icons.block_rounded,
            title: 'Abstain when evidence is weak',
            text: 'When safety data is too stale or unavailable, ORCA should say so instead of manufacturing a confident answer.',
          ),
          SizedBox(height: 12),
          _LightFeature(
            icon: Icons.sos_rounded,
            title: 'Honest SOS status',
            text: 'ORCA distinguishes sent, acknowledged and not-transmitted states instead of claiming help is on the way without confirmation.',
          ),
        ],
      ),
    );
  }

  Widget _impact() {
    return _section(
      dark: true,
      eyebrow: 'BENEFITS & IMPACT',
      title: 'Different users. Shared situational awareness.',
      subtitle: 'The value is better continuity, clearer evidence and faster access to the information each role needs.',
      child: const Column(
        children: [
          _DarkFeature(
            icon: Icons.sailing_rounded,
            title: 'Safer operational decisions',
            text: 'Fishermen can combine sea conditions, route risk, boundaries and alerts before and during a mission.',
          ),
          SizedBox(height: 12),
          _DarkFeature(
            icon: Icons.biotech_rounded,
            title: 'Stronger marine analysis',
            text: 'Researchers can connect multiple ocean variables, compare periods and produce traceable evidence rather than working from isolated layers.',
          ),
          SizedBox(height: 12),
          _DarkFeature(
            icon: Icons.emergency_share_rounded,
            title: 'Better emergency context',
            text: 'Authorities receive incident coordinates together with vessel and mission context, improving shared situational awareness.',
          ),
          SizedBox(height: 12),
          _DarkFeature(
            icon: Icons.sync_rounded,
            title: 'Operational continuity',
            text: 'Offline mission intelligence reduces the gap between shore-side planning and at-sea use when connectivity is limited.',
          ),
        ],
      ),
    );
  }

  Widget _research() {
    return _section(
      eyebrow: 'RESEARCH DEPTH',
      title: 'Professional tools for marine investigation.',
      subtitle: 'The researcher experience is deliberately deeper and more technical than the fisherman workflow.',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0B2D36),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF237A67).withValues(alpha: 0.18),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: const Column(
          children: [
            _ResearchItem(
              number: '1',
              title: 'Data Explorer',
              text: 'SST, chlorophyll-a, waves/swell, wind, currents, tides, bathymetry and PFZ history.',
            ),
            SizedBox(height: 14),
            _ResearchItem(
              number: '2',
              title: 'Spatial + temporal analysis',
              text: 'Compare areas, dates, seasonal baselines and anomalies across marine variables.',
            ),
            SizedBox(height: 14),
            _ResearchItem(
              number: '3',
              title: 'Productivity Investigator',
              text: 'Study environmental relationships while avoiding unsupported biological causation without catch or CPUE data.',
            ),
            SizedBox(height: 14),
            _ResearchItem(
              number: '4',
              title: 'Evidence + reporting',
              text: 'Use provenance, freshness, confidence, maps and charts to create traceable research outputs.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _finalCta() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 50),
      color: const Color(0xFFF3F8FA),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF061B2C), Color(0xFF087EA4)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppTheme.oceanBlue.withValues(alpha: 0.18),
              blurRadius: 30,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(Icons.waves_rounded, color: Colors.white, size: 38),
            const SizedBox(height: 16),
            const Text(
              'Ready to enter ORCA?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Choose your language, select your role and continue into the workflow designed for you.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: _getStarted,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String eyebrow,
    required String title,
    required String subtitle,
    required Widget child,
    bool dark = false,
  }) {
    final background = dark ? const Color(0xFF071D2C) : const Color(0xFFF3F8FA);
    final titleColor = dark ? Colors.white : AppTheme.navy;
    final bodyColor = dark
        ? Colors.white.withValues(alpha: 0.66)
        : const Color(0xFF617783);

    return Container(
      color: background,
      padding: const EdgeInsets.fromLTRB(22, 54, 22, 58),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: TextStyle(
              color: dark ? const Color(0xFF57D7C9) : AppTheme.oceanBlue,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 29,
              height: 1.13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: TextStyle(color: bodyColor, fontSize: 14.5, height: 1.55),
          ),
          const SizedBox(height: 28),
          child,
        ],
      ),
    );
  }

  Widget _metric(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.62),
              fontSize: 9.5,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeroBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color accent;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDDE8EC)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(icon, color: accent, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF667C87),
                    fontSize: 12.7,
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
}

class _DarkFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _DarkFeature({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF57D7C9), size: 27),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.64),
                    fontSize: 12.6,
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
}

class _LightFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _LightFeature({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFDCE8EC)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.oceanBlue, AppTheme.cyan],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 25),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF667C87),
                    fontSize: 12.6,
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
}

class _PipelineCard extends StatelessWidget {
  final String number;
  final String title;
  final String text;

  const _PipelineCard({
    required this.number,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFDCE8EC)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              color: AppTheme.cyan,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF667C87),
                    fontSize: 12.6,
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
}

class _ResearchItem extends StatelessWidget {
  final String number;
  final String title;
  final String text;

  const _ResearchItem({
    required this.number,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF57D7C9).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Color(0xFF57D7C9),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.62),
                  fontSize: 12.2,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
