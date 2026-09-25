import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import 'fisherman_otp_screen.dart';

class FishermanPhoneAuthScreen extends StatefulWidget {
  final String selectedLanguage;

  const FishermanPhoneAuthScreen({super.key, required this.selectedLanguage});

  @override
  State<FishermanPhoneAuthScreen> createState() =>
      _FishermanPhoneAuthScreenState();
}

class _FishermanPhoneAuthScreenState extends State<FishermanPhoneAuthScreen> {
  final phoneController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final phone = phoneController.text.trim();

    if (phone.length < 10) {
      _message('Enter a valid mobile number.');
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await AuthService.requestFishermanOtp(phone);

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FishermanOtpScreen(
            phoneNumber: phone,
            selectedLanguage: widget.selectedLanguage,
            initialDevOtp: result.devOtp,
            expiresInSeconds: result.expiresInSeconds,
          ),
        ),
      );
    } on ApiException catch (error) {
      if (mounted) _message(error.message);
    } catch (_) {
      if (mounted) {
        _message(
          'Could not connect to ORCA. Check the backend and ADB reverse.',
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(height: 34),
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.oceanBlue, AppTheme.cyan],
                  ),
                  borderRadius: BorderRadius.circular(23),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.oceanBlue.withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.phishing_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Fisherman Access',
                style: TextStyle(
                  color: AppTheme.navy,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Use your mobile number to securely enter ORCA. '
                'No email or complex password is required.',
                style: TextStyle(
                  color: Color(0xFF617783),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: phoneController,
                enabled: !isLoading,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _sendOtp(),
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: '98765 43210',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16, right: 10),
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        '+91',
                        style: TextStyle(
                          color: AppTheme.navy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0xFFDCE7EC)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: AppTheme.oceanBlue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  onPressed: isLoading ? null : _sendOtp,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 23,
                          height: 23,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Send OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F6F6),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.language_rounded, color: AppTheme.cyan),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Selected language: ${widget.selectedLanguage}\n'
                        'ORCA will keep this preference during onboarding.',
                        style: const TextStyle(
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
