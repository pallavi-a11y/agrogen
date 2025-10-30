import 'package:flutter/material.dart';
import '../theme.dart';

class MarketPricesScreen extends StatelessWidget {
  const MarketPricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightCream,
      appBar: AppBar(
        title: const Text('Market Prices'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.defaultPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Current Market Prices',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.primaryBrown,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Stay updated with the latest crop prices in your region.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 30),

              // Placeholder for market prices
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Tomato'),
                        subtitle: const Text('₹40/kg'),
                        trailing: const Icon(
                          Icons.trending_up,
                          color: Colors.green,
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Corn'),
                        subtitle: const Text('₹25/kg'),
                        trailing: const Icon(
                          Icons.trending_flat,
                          color: Colors.grey,
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Wheat'),
                        subtitle: const Text('₹30/kg'),
                        trailing: const Icon(
                          Icons.trending_down,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'More features coming soon!',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
