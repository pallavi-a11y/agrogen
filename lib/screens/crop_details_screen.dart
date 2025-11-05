import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../app_state.dart';

class CropDetailsScreen extends StatefulWidget {
  const CropDetailsScreen({super.key});

  @override
  State<CropDetailsScreen> createState() => _CropDetailsScreenState();
}

class _CropDetailsScreenState extends State<CropDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch current crops when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().fetchCurrentCrops();
    });
  }

  void _showEditCropsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Crops'),
          content: const Text('This feature is coming soon!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAddCropDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController areaController = TextEditingController();
    final TextEditingController plantedDateController = TextEditingController();
    final TextEditingController expectedHarvestController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Crop'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Crop Name',
                    hintText: 'e.g., Tomato',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: areaController,
                  decoration: const InputDecoration(
                    labelText: 'Area (acres)',
                    hintText: 'e.g., 2.5',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: plantedDateController,
                  decoration: const InputDecoration(
                    labelText: 'Planted Date',
                    hintText: 'e.g., 2024-01-15',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: expectedHarvestController,
                  decoration: const InputDecoration(
                    labelText: 'Expected Harvest',
                    hintText: 'e.g., 2024-04-15',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final cropData = {
                  'name': nameController.text,
                  'area': double.tryParse(areaController.text) ?? 0.0,
                  'plantedDate': plantedDateController.text,
                  'expectedHarvest': expectedHarvestController.text,
                  'image': 'assets/images/default_crop.png', // Default image
                  'status': 'Growing',
                  'health': 'Good',
                };

                final success = await context.read<AppState>().addCrop(
                  cropData,
                );
                Navigator.of(context).pop();

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Crop added successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to add crop. Please try again.'),
                    ),
                  );
                }
              },
              child: const Text('Add Crop'),
            ),
          ],
        );
      },
    );
  }

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
                      _showEditCropsDialog(context);
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
              child: Consumer<AppState>(
                builder: (context, appState, child) {
                  final crops = appState.currentCrops;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: crops.length,
                    itemBuilder: (context, index) {
                      final crop = crops[index];
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCropDialog(context);
        },
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add),
        tooltip: 'Add New Crop',
      ),
    );
  }
}
