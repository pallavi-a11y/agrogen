import 'package:flutter/material.dart';
import '../theme.dart';

class FarmConfigurationScreen extends StatefulWidget {
  const FarmConfigurationScreen({super.key});

  @override
  State<FarmConfigurationScreen> createState() =>
      _FarmConfigurationScreenState();
}

class _FarmConfigurationScreenState extends State<FarmConfigurationScreen> {
  bool _useCurrentLocation = true;
  final _farmNameController = TextEditingController(text: 'Green Valley Acres');
  final _latitudeController = TextEditingController(text: '37.7749');
  final _longitudeController = TextEditingController(text: '-122.4194');
  final _areaController = TextEditingController(text: '50');
  final _soilTypeController = TextEditingController(text: 'Loamy');
  final _notesController = TextEditingController();
  String _unit = 'Acres';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightCream,
      appBar: AppBar(
        title: const Text('Edit Farm Details'),
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

              // Map Preview
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
                child: const Center(
                  child: Icon(Icons.map, size: 80, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),

              // Location Toggle
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          () => setState(() => _useCurrentLocation = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _useCurrentLocation
                                ? AppTheme.primaryBrown
                                : Colors.grey[300],
                        foregroundColor:
                            _useCurrentLocation ? Colors.white : Colors.black,
                      ),
                      child: const Text('Use Current Location'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          () => setState(() => _useCurrentLocation = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            !_useCurrentLocation
                                ? AppTheme.primaryBrown
                                : Colors.grey[300],
                        foregroundColor:
                            !_useCurrentLocation ? Colors.white : Colors.black,
                      ),
                      child: const Text('Select on Map'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Farm Name
              TextField(
                controller: _farmNameController,
                decoration: const InputDecoration(
                  labelText: 'Farm Name',
                  prefixIcon: Icon(Icons.home),
                ),
              ),
              const SizedBox(height: 20),

              // Coordinates
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _latitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Latitude',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _longitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Longitude',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Land Area
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _areaController,
                      decoration: const InputDecoration(
                        labelText: 'Total Land Area',
                        prefixIcon: Icon(Icons.square_foot),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: _unit,
                    items:
                        ['Acres', 'Hectares'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() => _unit = newValue!);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Soil Type
              TextField(
                controller: _soilTypeController,
                decoration: const InputDecoration(
                  labelText: 'Soil Type',
                  prefixIcon: Icon(Icons.grass),
                ),
              ),
              const SizedBox(height: 20),

              // Notes
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 40),

              // Save Button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Save Farm Details'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
