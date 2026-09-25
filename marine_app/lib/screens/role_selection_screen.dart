import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../data/orca_l10n.dart';
import 'auth/admin_login_screen.dart';
import 'auth/authority_login_screen.dart';
import 'auth/fisherman_phone_auth_screen.dart';
import 'auth/researcher_login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  final String selectedLanguage;

  const RoleSelectionScreen({super.key, required this.selectedLanguage});

  String get lang => OrcaL10n.codeFromSelection(selectedLanguage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(height: 18),
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.navy, AppTheme.oceanBlue],
                  ),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: const Icon(
                  Icons.hub_rounded,
                  color: Colors.white,
                  size: 31,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                OrcaL10n.t(lang, 'choose_role'),
                style: const TextStyle(
                  color: AppTheme.navy,
                  fontSize: 30,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                OrcaL10n.t(lang, 'choose_role_sub'),
                style: const TextStyle(
                  color: Color(0xFF687D87),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              _roleCard(
                context,
                icon: Icons.sailing_rounded,
                title: OrcaL10n.t(lang, 'fisherman'),
                description: OrcaL10n.t(lang, 'fisherman_desc'),
                accent: AppTheme.oceanBlue,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FishermanPhoneAuthScreen(
                        selectedLanguage: selectedLanguage,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              _roleCard(
                context,
                icon: Icons.science_rounded,
                title: OrcaL10n.t(lang, 'researcher'),
                description: OrcaL10n.t(lang, 'researcher_desc'),
                accent: const Color(0xFF237A67),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ResearcherLoginScreen(
                        selectedLanguage: selectedLanguage,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              _roleCard(
                context,
                icon: Icons.health_and_safety_rounded,
                title: OrcaL10n.t(lang, 'authority'),
                description: OrcaL10n.t(lang, 'authority_desc'),
                accent: const Color(0xFFC75A32),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AuthorityLoginScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              _roleCard(
                context,
                icon: Icons.admin_panel_settings_rounded,
                title: OrcaL10n.t(lang, 'admin'),
                description: OrcaL10n.t(lang, 'admin_desc'),
                accent: const Color(0xFF59468D),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE0E9ED)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.navy.withValues(alpha: 0.035),
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
              child: Icon(icon, color: accent, size: 27),
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
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF6B7F88),
                      fontSize: 12.7,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(top: 15),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFF91A2AA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
