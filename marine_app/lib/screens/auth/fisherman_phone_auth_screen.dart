import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class FishermanPhoneAuthScreen extends StatelessWidget {
  final String selectedLanguage;

  const FishermanPhoneAuthScreen({super.key, required this.selectedLanguage});

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
                    colors: [AppTheme.oceanBlue, AppTheme.cyan],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.phishing_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Welcome,\nFisherman',
                style: TextStyle(
                  fontSize: 34,
                  height: 1.08,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.navy,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Use your mobile number to securely access ORCA. '
                'No email or complex password required.',
                style: TextStyle(
                  color: Color(0xFF617783),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 34),

              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  prefixText: '+91  ',
                  prefixIcon: const Icon(Icons.phone_android_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  onPressed: () {
                    // Backend OTP connection comes next.
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Send OTP',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Center(
                child: Text(
                  'Language: $selectedLanguage',
                  style: const TextStyle(color: Color(0xFF70858F)),
                ),
              ),

              const SizedBox(height: 28),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F6F6),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline_rounded, color: AppTheme.cyan),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'First login uses OTP. Returning users will '
                        'later be able to use ORCA PIN or biometric unlock.',
                        style: TextStyle(
                          color: AppTheme.navy,
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
    );
  }
}
