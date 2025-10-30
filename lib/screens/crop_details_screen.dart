import 'package:flutter/material.dart';
import '../theme.dart';

class CropDetailsScreen extends StatefulWidget {
  const CropDetailsScreen({super.key});

  @override
  State<CropDetailsScreen> createState() => _CropDetailsScreenState();
}

class _CropDetailsScreenState extends State<CropDetailsScreen> {
  final List<Map<String, dynamic>> _currentCrops = [
    {
      'name': 'Tomato',
      'plantedDate': '15 Oct 2024',
      'area': '2.5 acres',
      'status': 'Growing',
      'expectedHarvest': 'Dec 2024',
      'health': 'Good',
      'image': 'assets/unnamed.png',
    },
    {
      'name': 'Corn',
      'plantedDate': '10 Sep 2024',
      'area': '5.0 acres',
      'status': 'Growing',
      'expectedHarvest': 'Jan 2025',
      'health': 'Excellent',
      'image': 'assets/unnamed.png',
    },
  ];

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
          'Crop Details',
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
            // Edit Crops Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manage Your Crops',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2C2A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Add, edit, or remove crops currently grown on your farm.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF5F5E5C)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to edit crops screen
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Crops'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA7D49B),
                      foregroundColor: const Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),

            // Current Crops Header
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Currently Grown Crops',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2C2A),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Current Crops List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _currentCrops.length,
                itemBuilder: (context, index) {
                  final crop = _currentCrops[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Crop Image
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(crop['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Crop Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                crop['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D2C2A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Color(0xFF5F5E5C),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Planted: ${crop['plantedDate']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF5F5E5C),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.square_foot,
                                    size: 16,
                                    color: Color(0xFF5F5E5C),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Area: ${crop['area']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF5F5E5C),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Color(0xFF5F5E5C),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Harvest: ${crop['expectedHarvest']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF5F5E5C),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Status and Health
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    crop['health'] == 'Excellent'
                                        ? const Color(
                                          0xFF2E7D32,
                                        ).withOpacity(0.1)
                                        : const Color(
                                          0xFF4CAF50,
                                        ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                crop['health'],
                                style: TextStyle(
                                  color:
                                      crop['health'] == 'Excellent'
                                          ? const Color(0xFF2E7D32)
                                          : const Color(0xFF4CAF50),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              crop['status'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5F5E5C),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new crop
        },
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add),
        tooltip: 'Add New Crop',
      ),
    );
  }
}
