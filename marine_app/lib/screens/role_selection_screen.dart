import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'auth/fisherman_phone_auth_screen.dart';
import 'auth/researcher_login_screen.dart';
import 'auth/authority_login_screen.dart';
import 'auth/admin_login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  final String selectedLanguage;

  const RoleSelectionScreen({super.key, required this.selectedLanguage});

  void _selectRole(BuildContext context, String role) {
    late final Widget destination;

    switch (role) {
      case 'FISHERMAN':
        destination = FishermanPhoneAuthScreen(
          selectedLanguage: selectedLanguage,
        );
        break;

      case 'RESEARCHER':
        destination = ResearcherLoginScreen(selectedLanguage: selectedLanguage);
        break;

      case 'AUTHORITY':
        destination = const AuthorityLoginScreen();
        break;

      case 'ADMIN':
        destination = const AdminLoginScreen();
        break;

      default:
        destination = FishermanPhoneAuthScreen(
          selectedLanguage: selectedLanguage,
        );
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (context, animation, secondaryAnimation) {
          return destination;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slideAnimation =
              Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slideAnimation, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FA),
      body: Stack(
        children: [
          const _RoleBackground(),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.oceanBlue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.language_rounded,
                              size: 16,
                              color: AppTheme.oceanBlue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              selectedLanguage,
                              style: const TextStyle(
                                color: AppTheme.oceanBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'How will you\nuse ORCA?',
                          style: TextStyle(
                            color: AppTheme.navy,
                            fontSize: 34,
                            height: 1.08,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Choose your workspace to continue. '
                          'Your account permissions will still be '
                          'securely verified after sign-in.',
                          style: TextStyle(
                            color: Color(0xFF617783),
                            fontSize: 15,
                            height: 1.48,
                          ),
                        ),

                        const SizedBox(height: 26),

                        _RoleCard(
                          icon: Icons.phishing_rounded,
                          title: 'Fisherman',
                          subtitle: 'Plan safer sea missions with simple mobile access.',
                          authentication: 'Mobile number + OTP',
                          accentColor: const Color(0xFF087EA4),
                          gradientColors: const [
                            Color(0xFF087EA4),
                            Color(0xFF15B8A6),
                          ],
                          onTap: () {
                            _selectRole(context, 'FISHERMAN');
                          },
                        ),

                        const SizedBox(height: 14),

                        _RoleCard(
                          icon: Icons.science_rounded,
                          title: 'Marine Researcher',
                          subtitle: 'Explore marine data, anomalies and environmental intelligence.',
                          authentication: 'Research account',
                          accentColor: const Color(0xFF237A67),
                          gradientColors: const [
                            Color(0xFF156F63),
                            Color(0xFF35A58D),
                          ],
                          onTap: () {
                            _selectRole(context, 'RESEARCHER');
                          },
                        ),

                        const SizedBox(height: 14),

                        _RoleCard(
                          icon: Icons.health_and_safety_rounded,
                          title: 'Coastal Authority / Rescue',
                          subtitle: 'Monitor SOS incidents, hazards and marine advisories.',
                          authentication: 'Authorized secure access',
                          accentColor: const Color(0xFFD26C38),
                          gradientColors: const [
                            Color(0xFFC75A32),
                            Color(0xFFF59B52),
                          ],
                          onTap: () {
                            _selectRole(context, 'AUTHORITY');
                          },
                        ),

                        const SizedBox(height: 14),

                        _RoleCard(
                          icon: Icons.admin_panel_settings_rounded,
                          title: 'Administrator',
                          subtitle: 'Manage ORCA services, users, models and platform health.',
                          authentication: 'Restricted internal access',
                          accentColor: const Color(0xFF6754A4),
                          gradientColors: const [
                            Color(0xFF59468D),
                            Color(0xFF8876C8),
                          ],
                          onTap: () {
                            _selectRole(context, 'ADMIN');
                          },
                        ),

                        const SizedBox(height: 26),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFDCE7EC)),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                color: AppTheme.cyan,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Selecting a role does not grant '
                                  'permissions. ORCA verifies your '
                                  'account role securely before opening '
                                  'the corresponding workspace.',
                                  style: TextStyle(
                                    color: Color(0xFF536A77),
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

class _RoleCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String authentication;
  final Color accentColor;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.authentication,
    required this.accentColor,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.985 : 1,
      duration: const Duration(milliseconds: 120),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _pressed = true;
          });
        },
        onTapCancel: () {
          setState(() {
            _pressed = false;
          });
        },
        onTapUp: (_) {
          setState(() {
            _pressed = false;
          });

          widget.onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFDCE7EC)),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(widget.icon, color: Colors.white, size: 31),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: AppTheme.navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF667C87),
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 9),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.authentication,
                        style: TextStyle(
                          color: widget.accentColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.arrow_forward_ios_rounded,
                color: widget.accentColor,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleBackground extends StatelessWidget {
  const _RoleBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -130,
            right: -110,
            child: Container(
              width: 310,
              height: 310,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.cyan.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -140,
            left: -120,
            child: Container(
              width: 330,
              height: 330,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.oceanBlue.withValues(alpha: 0.05),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
