import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';

class CropMarketPricesScreen extends StatefulWidget {
  final String cropName;

  const CropMarketPricesScreen({super.key, required this.cropName});

  @override
  State<CropMarketPricesScreen> createState() => _CropMarketPricesScreenState();
}

class _CropMarketPricesScreenState extends State<CropMarketPricesScreen> {
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();
  List<Map<String, dynamic>> _marketPrices = [];
  List<Map<String, dynamic>> _filteredPrices = [];
  bool _isLoading = true;
  String? _error;
  double? _userLatitude;
  double? _userLongitude;

  @override
  void initState() {
    super.initState();
    _fetchCropMarketPrices();
  }

  Future<void> _fetchCropMarketPrices() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Get user location
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        _userLatitude = position.latitude;
        _userLongitude = position.longitude;
      }

      // Fetch all market prices
      final prices = await _apiService.fetchMarketPrices();

      // Filter by selected crop
      final filtered =
          prices.where((price) {
            final cropName =
                (price['commodity'] ?? price['crop'] ?? price['name'] ?? '')
                    .toString()
                    .toLowerCase();
            return cropName.contains(widget.cropName.toLowerCase());
          }).toList();

      // TODO: Implement proximity filtering based on user location
      // Currently, showing all prices for the crop as location data is not available in API response
      // To filter by proximity, backend needs to provide market coordinates or a filtered endpoint

      setState(() {
        _marketPrices = filtered;
        _filteredPrices = filtered;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load market prices. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightCream,
      appBar: AppBar(
        title: Text('${widget.cropName} Market Prices'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchCropMarketPrices,
          ),
        ],
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
                'Market Prices for ${widget.cropName}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.primaryBrown,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Prices from markets near your location.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 20),

              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_error != null)
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchCropMarketPrices,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_filteredPrices.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No prices found for "${widget.cropName}" near your location.',
                          style: TextStyle(color: AppTheme.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try searching for a different crop or check back later.',
                          style: TextStyle(color: AppTheme.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  children:
                      _filteredPrices.map((price) {
                        final commodity =
                            price['commodity'] ??
                            price['crop'] ??
                            price['name'] ??
                            'Unknown';
                        final market = price['market'] ?? 'Unknown Market';
                        final variety = price['variety'] ?? '';
                        final grade = price['grade'] ?? '';
                        final minPrice =
                            price['min_price'] ?? price['minPrice'] ?? 0.0;
                        final maxPrice =
                            price['max_price'] ?? price['maxPrice'] ?? 0.0;
                        final modalPrice =
                            price['modal_price'] ?? price['modalPrice'] ?? 0.0;
                        final unit = price['unit'] ?? 'kg';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        commodity,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryBrown,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primary.withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        market,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (variety.isNotEmpty || grade.isNotEmpty)
                                  Row(
                                    children: [
                                      if (variety.isNotEmpty)
                                        Text(
                                          'Variety: $variety',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      if (variety.isNotEmpty &&
                                          grade.isNotEmpty)
                                        const SizedBox(width: 12),
                                      if (grade.isNotEmpty)
                                        Text(
                                          'Grade: $grade',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                    ],
                                  ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Min Price',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.textSecondary,
                                            ),
                                          ),
                                          Text(
                                            '₹${minPrice.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Max Price',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.textSecondary,
                                            ),
                                          ),
                                          Text(
                                            '₹${maxPrice.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Modal Price',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.textSecondary,
                                            ),
                                          ),
                                          Text(
                                            '₹${modalPrice.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppTheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'per $unit',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),

              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Prices are updated regularly from trusted sources.',
                  style: TextStyle(color: AppTheme.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
