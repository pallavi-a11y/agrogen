import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/api_service.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _marketPrices = [];
  List<Map<String, dynamic>> _filteredPrices = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCrop = '';

  // Common crops for quick access
  final List<Map<String, String>> _commonCrops = [
    {'name': 'Potato', 'icon': '🥔'},
    {'name': 'Tomato', 'icon': '🍅'},
    {'name': 'Rice', 'icon': '🌾'},
    {'name': 'Wheat', 'icon': '🌾'},
    {'name': 'Chilli', 'icon': '🌶️'},
    {'name': 'Sugarcane', 'icon': '🎋'},
    {'name': 'French Beans', 'icon': '🫘'},
    {'name': 'Onion', 'icon': '🧅'},
    {'name': 'Peas', 'icon': '🫛'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchMarketPrices();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchMarketPrices() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final prices = await _apiService.fetchMarketPrices();
      setState(() {
        _marketPrices = prices;
        _filteredPrices = prices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load market prices. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPrices = _marketPrices;
        _selectedCrop = '';
      } else {
        _filteredPrices =
            _marketPrices.where((price) {
              final cropName =
                  (price['commodity'] ?? price['crop'] ?? price['name'] ?? '')
                      .toString()
                      .toLowerCase();
              return cropName.contains(query);
            }).toList();
        _selectedCrop = query;
      }
    });
  }

  void _selectCrop(String cropName) {
    _searchController.text = cropName;
    setState(() {
      _selectedCrop = cropName;
      _filteredPrices =
          _marketPrices.where((price) {
            final cropNameData =
                (price['commodity'] ?? price['crop'] ?? price['name'] ?? '')
                    .toString()
                    .toLowerCase();
            return cropNameData.contains(cropName.toLowerCase());
          }).toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _selectedCrop = '';
      _filteredPrices = _marketPrices;
    });
  }

  IconData _getTrendIcon(String trend) {
    switch (trend.toLowerCase()) {
      case 'up':
      case 'increasing':
        return Icons.trending_up;
      case 'down':
      case 'decreasing':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend.toLowerCase()) {
      case 'up':
      case 'increasing':
        return Colors.green;
      case 'down':
      case 'decreasing':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchMarketPrices,
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
              const SizedBox(height: 20),

              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for crops...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon:
                      _selectedCrop.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearch,
                          )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.primaryBrown.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.primaryBrown.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryBrown),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Common Crops Grid
              Text(
                'Popular Crops',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBrown,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: _commonCrops.length,
                itemBuilder: (context, index) {
                  final crop = _commonCrops[index];
                  final isSelected =
                      _selectedCrop.toLowerCase() ==
                      crop['name']!.toLowerCase();

                  return GestureDetector(
                    onTap: () => _selectCrop(crop['name']!),
                    child: Card(
                      elevation: isSelected ? 4 : 2,
                      color:
                          isSelected
                              ? AppTheme.primary.withOpacity(0.1)
                              : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? AppTheme.primary
                                  : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            crop['icon']!,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            crop['name']!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.primaryBrown,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // Results Section
              if (_selectedCrop.isNotEmpty)
                Text(
                  'Results for "${_selectedCrop}"',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBrown,
                  ),
                )
              else
                Text(
                  'All Market Prices',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBrown,
                  ),
                ),

              const SizedBox(height: 16),

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
                          onPressed: _fetchMarketPrices,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_filteredPrices.isEmpty && _selectedCrop.isNotEmpty)
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
                          'No prices found for "${_selectedCrop}"',
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
              else if (_filteredPrices.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.store,
                          size: 48,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No market prices available at the moment.',
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
