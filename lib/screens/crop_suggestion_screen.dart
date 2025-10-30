import 'package:flutter/material.dart';
import '../theme.dart';

class CropSuggestionScreen extends StatefulWidget {
  const CropSuggestionScreen({super.key});

  @override
  State<CropSuggestionScreen> createState() => _CropSuggestionScreenState();
}

class _CropSuggestionScreenState extends State<CropSuggestionScreen> {
  int _selectedFilter = 0; // 0: Best Match, 1: Profitability, 2: Water Usage

  final List<String> _filters = ['Best Match', 'Profitability', 'Water Usage'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3E3D3A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Your Crop Recommendations',
          style: TextStyle(
            color: Color(0xFF3E3D3A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Summary Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Farm Location',
                        style: TextStyle(
                          color: Color(0xFF5F5E5C),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Green Valley, CA',
                        style: TextStyle(
                          color: Color(0xFF2D2C2A),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Soil Type',
                        style: TextStyle(
                          color: Color(0xFF5F5E5C),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Loamy',
                        style: TextStyle(
                          color: Color(0xFF2D2C2A),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Analysis Date',
                        style: TextStyle(
                          color: Color(0xFF5F5E5C),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '15 Oct 2024',
                        style: TextStyle(
                          color: Color(0xFF2D2C2A),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Filter Chips
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedFilter == index;
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(
                        _filters[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = index;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFF4CAF50),
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? const Color(0xFF4CAF50)
                                  : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Crop List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  CropCard(
                    name: 'Tomato',
                    suitability: 'Excellent Suitability',
                    matchPercentage: '95% Match',
                    suitabilityColor: Color(0xFF2E7D32),
                    imagePath: 'assets/unnamed.png', // Placeholder
                    conditions: [
                      '☀️ Full Sun',
                      '💧 Low Water',
                      '💰 High Profit',
                    ],
                    isCurrent: true,
                  ),
                  SizedBox(height: 16),
                  CropCard(
                    name: 'Corn',
                    suitability: 'Good Suitability',
                    matchPercentage: '88% Match',
                    suitabilityColor: Color(0xFFEF6C00),
                    imagePath: 'assets/unnamed.png', // Placeholder
                    conditions: [
                      '☀️ Full Sun',
                      '💧 Medium Water',
                      '💰 Medium Profit',
                    ],
                    isCurrent: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.refresh),
        tooltip: 'New Report',
      ),
    );
  }
}

class CropCard extends StatelessWidget {
  const CropCard({
    super.key,
    required this.name,
    required this.suitability,
    required this.matchPercentage,
    required this.suitabilityColor,
    required this.imagePath,
    required this.conditions,
    required this.isCurrent,
  });

  final String name;
  final String suitability;
  final String matchPercentage;
  final Color suitabilityColor;
  final String imagePath;
  final List<String> conditions;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Suitability Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: suitabilityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                suitability,
                style: TextStyle(
                  color: suitabilityColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Crop Name and Image Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2C2A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        matchPercentage,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5F5E5C),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Conditions Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  conditions.map((condition) {
                    return Column(
                      children: [
                        Text(
                          condition.split(' ')[0], // Icon
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          condition.substring(2), // Text
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5F5E5C),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),

            // Buttons Row - removed for Tomato and Corn
            if (name != 'Tomato' && name != 'Corn')
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA7D49B),
                        foregroundColor: const Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('View Details'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                  ),
                  if (isCurrent) ...[
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF3E3D3A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Color(0xFF3E3D3A)),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Edit'),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}
