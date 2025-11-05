import 'package:flutter/material.dart';
import '../theme.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppTheme.primaryBrown),
            onPressed: () => Navigator.pushNamed(context, '/home'),
            tooltip: 'Explore App',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.defaultPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'AgroGen',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primaryBrown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.eco, color: AppTheme.naturalGreen, size: 32),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Your Smart Farming Partner',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),

              // Banner Image Placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.naturalGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
                child: const Center(
                  child: Icon(
                    Icons.landscape,
                    size: 80,
                    color: AppTheme.naturalGreen,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Buttons
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: AppTheme.primaryBrown),
                  foregroundColor: AppTheme.primaryBrown,
                ),
                child: const Text('Register'),
              ),
              const SizedBox(height: 40),

              // Footer
              Text(
                'Your data is securely stored and used only to enhance your farming experience. We respect your privacy.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
