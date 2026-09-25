import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/orca_languages.dart';
import '../../models/user_role.dart';
import '../../services/auth_service.dart';
import '../../services/session_service.dart';
import '../dashboard/dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  final String selectedLanguage;

  const RegisterScreen({super.key, required this.selectedLanguage});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  String get _languageCode {
    final matches = orcaLanguages.where(
      (language) => language.name == widget.selectedLanguage,
    );
    return matches.isEmpty ? 'en' : matches.first.code;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.length < 2) {
      _message('Enter your full name.');
      return;
    }

    if (!email.contains('@')) {
      _message('Enter a valid email address.');
      return;
    }

    if (password.length < 8) {
      _message('Password must contain at least 8 characters.');
      return;
    }

    if (password != confirmPasswordController.text) {
      _message('Passwords do not match.');
      return;
    }

    setState(() => isLoading = true);

    try {
      await AuthService.registerResearcher(
        fullName: name,
        email: email,
        password: password,
        preferredLanguage: _languageCode,
      );

      final result = await AuthService.loginWithPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (result.user.role != 'RESEARCHER') {
        _message('ORCA returned an invalid account role.');
        return;
      }

      await SessionService.saveSession(
        accessToken: result.accessToken,
        user: result.user,
      );

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(role: UserRole.researcher),
        ),
        (route) => false,
      );
    } on ApiException catch (error) {
      if (mounted) _message(error.message);
    } catch (_) {
      if (mounted) {
        _message('Could not create the Researcher account.');
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
    const accent = Color(0xFF237A67);

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
              const SizedBox(height: 28),
              const Text(
                'Create Researcher\nAccount',
                style: TextStyle(
                  color: AppTheme.navy,
                  fontSize: 32,
                  height: 1.08,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Public registration is available only for '
                'Marine Researcher accounts.',
                style: TextStyle(
                  color: Color(0xFF617783),
                  fontSize: 14.5,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: nameController,
                enabled: !isLoading,
                decoration: _field(
                  label: 'Full Name',
                  icon: Icons.person_outline_rounded,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: emailController,
                enabled: !isLoading,
                keyboardType: TextInputType.emailAddress,
                decoration: _field(
                  label: 'Email Address',
                  icon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: passwordController,
                enabled: !isLoading,
                obscureText: obscurePassword,
                decoration:
                    _field(
                      label: 'Create Password',
                      icon: Icons.lock_outline_rounded,
                    ).copyWith(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: confirmPasswordController,
                enabled: !isLoading,
                obscureText: obscureConfirmPassword,
                decoration:
                    _field(
                      label: 'Confirm Password',
                      icon: Icons.lock_reset_rounded,
                    ).copyWith(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF6F3),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'Preferred language: ${widget.selectedLanguage}\n'
                  'ORCA will save this preference with the account.',
                  style: const TextStyle(
                    color: Color(0xFF486861),
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  onPressed: isLoading ? null : _register,
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
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
                          'Create Account & Enter ORCA',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _field({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFDCE7EC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF237A67), width: 1.5),
      ),
    );
  }
}
