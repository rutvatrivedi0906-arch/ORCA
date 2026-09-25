import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class OnboardingGuideScreen extends StatefulWidget {
  const OnboardingGuideScreen({super.key});

  @override
  State<OnboardingGuideScreen> createState() => _OnboardingGuideScreenState();
}

class _OnboardingGuideScreenState extends State<OnboardingGuideScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<_GuidePageData> _pages = const [
    _GuidePageData(
      icon: Icons.language_rounded,
      title: 'Choose your language',
      description:
          'Use ORCA in the language you understand best. '
          'Regional-language and voice guidance make the '
          'app easier to use.',
    ),
    _GuidePageData(
      icon: Icons.route_rounded,
      title: 'Plan before you sail',
      description:
          'Check sea conditions, hazards, boundaries and '
          'safer routes before starting your journey.',
    ),
    _GuidePageData(
      icon: Icons.download_for_offline_rounded,
      title: 'Take ORCA offline',
      description:
          'Download your Sea Mission Pack with routes, '
          'alerts, geofences and forecast information '
          'before leaving connectivity.',
    ),
    _GuidePageData(
      icon: Icons.sos_rounded,
      title: 'Stay connected to safety',
      description:
          'ORCA helps track warnings, boundary risks and '
          'SOS status so you always know what the system '
          'has actually transmitted.',
    ),
  ];

  void _next() {
    if (_currentPage == _pages.length - 1) {
      Navigator.pop(context);
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('How ORCA Works'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final item = _pages[index];

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF087EA4), Color(0xFF15B8A6)],
                          ),
                          borderRadius: BorderRadius.circular(42),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.oceanBlue.withValues(alpha: 0.18),
                              blurRadius: 35,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Icon(item.icon, size: 68, color: Colors.white),
                      ),

                      const SizedBox(height: 40),

                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.navy,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        item.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF607582),
                          fontSize: 16,
                          height: 1.55,
                        ),
                      ),

                      const SizedBox(height: 25),

                      OutlinedButton.icon(
                        onPressed: () {
                          // Voice guidance will be
                          // connected in a later phase.
                        },
                        icon: const Icon(Icons.volume_up_rounded),
                        label: const Text('Listen'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) {
              final selected = index == _currentPage;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: selected ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: selected
                      ? AppTheme.oceanBlue
                      : const Color(0xFFC6D6DE),
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: _next,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  _currentPage == _pages.length - 1 ? 'Got it' : 'Next',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidePageData {
  final IconData icon;
  final String title;
  final String description;

  const _GuidePageData({
    required this.icon,
    required this.title,
    required this.description,
  });
}
