import 'dart:async';

import 'package:flutter/material.dart';

import 'landing_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LandingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF061B2C), Color(0xFF073B4C), Color(0xFF087EA4)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
                child: const Icon(
                  Icons.waves_rounded,
                  color: Colors.white,
                  size: 64,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'ORCA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 6,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Marine Intelligence Platform',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  letterSpacing: 0.4,
                ),
              ),

              const Spacer(),

              const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Intelligence that travels with you.',
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
