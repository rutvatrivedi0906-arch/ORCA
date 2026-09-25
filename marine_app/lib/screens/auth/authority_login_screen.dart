import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AuthorityLoginScreen extends StatelessWidget {
  const AuthorityLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
              ),

              const SizedBox(height: 30),

              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFC75A32), Color(0xFFF59B52)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.health_and_safety_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Coastal Authority\n& Rescue',
                style: TextStyle(
                  color: AppTheme.navy,
                  fontSize: 31,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Authorized access for coastal safety, rescue '
                'and incident-response personnel.',
                style: TextStyle(
                  color: Color(0xFF617783),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 34),

              const _AuthorityField(
                label: 'Official Email',
                icon: Icons.badge_outlined,
              ),

              const SizedBox(height: 14),

              const _AuthorityField(
                label: 'Password',
                icon: Icons.lock_outline_rounded,
                password: true,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.shield_outlined),
                  label: const Text(
                    'Secure Sign In',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFC75A32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Authority accounts are provisioned by ORCA administrators. '
                'Public registration is disabled.',
                style: TextStyle(
                  color: Color(0xFF748892),
                  fontSize: 12.5,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthorityField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool password;

  const _AuthorityField({
    required this.label,
    required this.icon,
    this.password = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: password,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
