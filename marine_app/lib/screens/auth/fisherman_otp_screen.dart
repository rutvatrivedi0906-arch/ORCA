import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../models/user_role.dart';
import '../dashboard/dashboard_screen.dart';
import '../../services/auth_service.dart';
import '../../services/session_service.dart';
import 'fisherman_registration_screen.dart';

class FishermanOtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String selectedLanguage;
  final String? initialDevOtp;
  final int expiresInSeconds;

  const FishermanOtpScreen({
    super.key,
    required this.phoneNumber,
    required this.selectedLanguage,
    required this.initialDevOtp,
    required this.expiresInSeconds,
  });

  @override
  State<FishermanOtpScreen> createState() => _FishermanOtpScreenState();
}

class _FishermanOtpScreenState extends State<FishermanOtpScreen> {
  final otpController = TextEditingController();

  bool isLoading = false;
  bool isResending = false;
  late int secondsRemaining;
  Timer? timer;
  String? devOtp;

  @override
  void initState() {
    super.initState();
    secondsRemaining = widget.expiresInSeconds;
    devOtp = widget.initialDevOtp;
    _startTimer();
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (secondsRemaining <= 1) {
        timer.cancel();
        setState(() => secondsRemaining = 0);
      } else {
        setState(() => secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      _message('Enter the 6-digit OTP.');
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await AuthService.verifyFishermanOtp(
        phoneNumber: widget.phoneNumber,
        otp: otp,
      );

      if (!mounted) return;

      if (result.isNewUser) {
        final token = result.onboardingToken;

        if (token == null || token.isEmpty) {
          _message('ORCA did not return a valid onboarding token.');
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FishermanRegistrationScreen(
              phoneNumber: widget.phoneNumber,
              selectedLanguage: widget.selectedLanguage,
              onboardingToken: token,
            ),
          ),
        );
        return;
      }

      final accessToken = result.accessToken;
      final user = result.user;

      if (accessToken == null || user == null) {
        _message('ORCA returned an incomplete login response.');
        return;
      }

      if (user.role != 'FISHERMAN') {
        _message('This account is not authorized for the Fisherman workspace.');
        return;
      }

      await SessionService.saveSession(accessToken: accessToken, user: user);

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(role: UserRole.fisherman),
        ),
        (route) => false,
      );
    } on ApiException catch (error) {
      if (mounted) _message(error.message);
    } catch (_) {
      if (mounted) {
        _message('Could not verify the OTP. Check the backend connection.');
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    if (isResending) return;

    setState(() => isResending = true);

    try {
      final result = await AuthService.requestFishermanOtp(widget.phoneNumber);

      if (!mounted) return;

      setState(() {
        devOtp = result.devOtp;
        secondsRemaining = result.expiresInSeconds;
        otpController.clear();
      });

      _startTimer();
      _message('A new OTP was generated.');
    } on ApiException catch (error) {
      if (mounted) _message(error.message);
    } catch (_) {
      if (mounted) {
        _message('Could not request a new OTP.');
      }
    } finally {
      if (mounted) setState(() => isResending = false);
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  String _timerText() {
    final minutes = secondsRemaining ~/ 60;
    final seconds = secondsRemaining % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
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
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.oceanBlue, AppTheme.cyan],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.sms_outlined,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'Verify your number',
                style: TextStyle(
                  color: AppTheme.navy,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Enter the 6-digit code for '
                '${widget.phoneNumber}.',
                style: const TextStyle(
                  color: Color(0xFF617783),
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
              if (devOtp != null) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3D8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Development OTP: $devOtp',
                    style: const TextStyle(
                      color: Color(0xFF7B5A00),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 26),
              TextField(
                controller: otpController,
                enabled: !isLoading,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: 6,
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  color: AppTheme.navy,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 10,
                ),
                onSubmitted: (_) => _verify(),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '••••••',
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
                  onPressed: isLoading ? null : _verify,
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
                            color: Colors.white,
                            strokeWidth: 2.4,
                          ),
                        )
                      : const Text(
                          'Verify & Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: secondsRemaining > 0
                    ? Text(
                        'Code expires in ${_timerText()}',
                        style: const TextStyle(color: Color(0xFF70858F)),
                      )
                    : TextButton(
                        onPressed: isResending ? null : _resendOtp,
                        child: Text(
                          isResending ? 'Requesting...' : 'Request a new OTP',
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
