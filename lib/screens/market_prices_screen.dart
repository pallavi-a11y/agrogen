import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/api_service.dart';
import 'crop_market_prices_screen.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<String> _cropSuggestions = [];
  bool _isLoadingSuggestions = true;

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
    _fetchCropSuggestions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCropSuggestions() async {
    try {
      final prices = await _apiService.fetchMarketPrices();
      final crops =
          prices
              .map(
                (price) =>
                    (price['commodity'] ?? price['crop'] ?? price['name'] ?? '')
                        .toString()
                        .toLowerCase(),
              )
              .where((crop) => crop.isNotEmpty)
              .toSet()
              .toList();
      setState(() {
        _cropSuggestions = crops;
        _isLoadingSuggestions = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingSuggestions = false;
      });
    }
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CropMarketPricesScreen(cropName: query),
        ),
      );
      _searchController.clear();
    }
  }

  void _selectCrop(String cropName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropMarketPricesScreen(cropName: cropName),
      ),
    );
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
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
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

              // Search Bar with Autocomplete
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return _cropSuggestions.where((String option) {
                    return option.contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  _onSearchSubmitted(selection);
                },
                fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted,
                ) {
                  return TextField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    onSubmitted: (String value) {
                      _onSearchSubmitted(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search for crops...',
                      prefixIcon: const Icon(Icons.search),
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
                        borderSide: const BorderSide(
                          color: AppTheme.primaryBrown,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  );
                },
                optionsViewBuilder: (
                  BuildContext context,
                  AutocompleteOnSelected<String> onSelected,
                  Iterable<String> options,
                ) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: Container(
                        width:
                            MediaQuery.of(context).size.width -
                            2 * AppTheme.defaultPadding,
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return ListTile(
                              title: Text(option),
                              onTap: () {
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
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
                  return GestureDetector(
                    onTap: () => _selectCrop(crop['name']!),
                    child: Card(
                      elevation: 2,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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

              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Tap on a crop or search to view detailed market prices.',
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
