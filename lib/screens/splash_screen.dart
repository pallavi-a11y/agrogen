import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Animation for progress bar
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/auth_choice');
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Background image with brown overlay
          image: const DecorationImage(
            image: AssetImage('assets/unnamed.png'),
            fit: BoxFit.cover,
            opacity: 0.4,
          ),
          // Brown overlay
          color: const Color.fromARGB(255, 100, 56, 14),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with glow effect
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.beige,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.leafyGreen.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.eco,
                  size: 60,
                  color: AppTheme.leafyGreen,
                ),
              ),
              const SizedBox(height: 30),
              // App name
              Text(
                'AgroGen',
                style: GoogleFonts.publicSans(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.beige,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Tagline
              Text(
                'Smart Farming. Simplified.',
                style: GoogleFonts.publicSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFFF3E1CA),
                ),
              ),
              const SizedBox(height: 50),
              // Animated progress bar
              SizedBox(
                width: 250,
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: AppTheme.beige.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.leafyGreen,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    );
                  },
                ),
              ),
              const SizedBox(height: 60),
              // Footer
              Text(
                'v1.0.0 © 2025 AgroGen',
                style: GoogleFonts.publicSans(
                  fontSize: 14,
                  color: AppTheme.sandyBrown.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
