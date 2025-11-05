import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme.dart';
import '../app_state.dart';
import '../services/location_service.dart';
import 'map_selection_screen.dart';

class FarmConfigurationScreen extends StatefulWidget {
  const FarmConfigurationScreen({super.key});

  @override
  State<FarmConfigurationScreen> createState() =>
      _FarmConfigurationScreenState();
}

class _FarmConfigurationScreenState extends State<FarmConfigurationScreen> {
  bool _useCurrentLocation = true;
  bool _isLoadingLocation = false;
  final _farmNameController = TextEditingController(text: 'Farm 1');
  final _latitudeController = TextEditingController(text: '28.6139');
  final _longitudeController = TextEditingController(text: '77.2090');
  final _areaController = TextEditingController(text: '50');
  final _nitrogenController = TextEditingController(text: '0.0');
  final _phosphorusController = TextEditingController(text: '0.0');
  final _potassiumController = TextEditingController(text: '0.0');
  final _temperatureController = TextEditingController(text: '25.0');
  final _humidityController = TextEditingController(text: '60.0');
  final _phController = TextEditingController(text: '7.0');
  final _soilMoistureController = TextEditingController(text: '30.0');
  final _soilTypeController = TextEditingController(text: 'Loamy');
  final _notesController = TextEditingController();
  String _unit = 'Acres';

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _loadCurrentFarmData();
  }

  void _loadCurrentFarmData() {
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.farmConfig != null) {
      _farmNameController.text = appState.farmConfig!['name'] ?? '';
      _latitudeController.text =
          appState.farmConfig!['latitude']?.toString() ?? '';
      _longitudeController.text =
          appState.farmConfig!['longitude']?.toString() ?? '';
      _areaController.text = appState.farmConfig!['area']?.toString() ?? '';
      _nitrogenController.text =
          appState.farmConfig!['nitrogen']?.toString() ?? '';
      _phosphorusController.text =
          appState.farmConfig!['phosphorus']?.toString() ?? '';
      _potassiumController.text =
          appState.farmConfig!['potassium']?.toString() ?? '';
      _temperatureController.text =
          appState.farmConfig!['temperature']?.toString() ?? '';
      _humidityController.text =
          appState.farmConfig!['humidity']?.toString() ?? '';
      _phController.text = appState.farmConfig!['ph']?.toString() ?? '';
      _soilMoistureController.text =
          appState.farmConfig!['soil_moisture']?.toString() ?? '';
      _soilTypeController.text = appState.farmConfig!['soil_type'] ?? '';
      _notesController.text = appState.farmConfig!['notes'] ?? '';
      _unit = appState.farmConfig!['unit'] ?? 'Acres';
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        setState(() {
          _latitudeController.text = position.latitude.toStringAsFixed(6);
          _longitudeController.text = position.longitude.toStringAsFixed(6);
          _updateMapMarker();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to get current location. Please check location permissions and GPS.',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _selectLocationOnMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MapSelectionScreen(
              initialLatitude:
                  double.tryParse(_latitudeController.text) ?? 28.6139,
              initialLongitude:
                  double.tryParse(_longitudeController.text) ?? 77.2090,
            ),
      ),
    );

    if (result != null) {
      setState(() {
        _latitudeController.text = result['latitude'].toString();
        _longitudeController.text = result['longitude'].toString();
        _updateMapMarker();
      });
    }
  }

  void _updateMapMarker() {
    final lat = double.tryParse(_latitudeController.text) ?? 28.6139;
    final lng = double.tryParse(_longitudeController.text) ?? 77.2090;
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('farm_location'),
          position: LatLng(lat, lng),
          infoWindow: const InfoWindow(title: 'Farm Location'),
        ),
      };
    });
  }

  Future<void> _saveFarmDetails() async {
    final appState = Provider.of<AppState>(context, listen: false);

    final farmConfig = {
      'name': _farmNameController.text,
      'latitude': double.tryParse(_latitudeController.text),
      'longitude': double.tryParse(_longitudeController.text),
      'area': double.tryParse(_areaController.text),
      'unit': _unit,
      'nitrogen': double.tryParse(_nitrogenController.text),
      'phosphorus': double.tryParse(_phosphorusController.text),
      'potassium': double.tryParse(_potassiumController.text),
      'temperature': double.tryParse(_temperatureController.text),
      'humidity': double.tryParse(_humidityController.text),
      'ph': double.tryParse(_phController.text),
      'soil_moisture': double.tryParse(_soilMoistureController.text),
      'soil_type': _soilTypeController.text,
      'notes': _notesController.text,
    };

    try {
      await appState.updateFarmConfig(farmConfig);
      // Automatically fetch new crop suggestions after saving farm config
      await appState.fetchCropSuggestionsWithParams();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Farm details saved successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving farm details: $e')));
    }
  }

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
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        double.tryParse(_latitudeController.text) ?? 28.6139,
                        double.tryParse(_longitudeController.text) ?? 77.2090,
                      ),
                      zoom: 10,
                    ),
                    markers: _markers,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                      _updateMapMarker();
                    },
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Location Toggle
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _isLoadingLocation ? null : _getCurrentLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _useCurrentLocation
                                ? AppTheme.primaryBrown
                                : Colors.grey[300],
                        foregroundColor:
                            _useCurrentLocation ? Colors.white : Colors.black,
                      ),
                      child:
                          _isLoadingLocation
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Text('Use Current Location'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectLocationOnMap,
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

              // Soil Parameters
              const Text(
                'Soil Parameters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // NPK Values
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nitrogenController,
                      decoration: const InputDecoration(
                        labelText: 'Nitrogen (N)',
                        prefixIcon: Icon(Icons.science),
                        suffixText: 'ppm',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _phosphorusController,
                      decoration: const InputDecoration(
                        labelText: 'Phosphorus (P)',
                        prefixIcon: Icon(Icons.science),
                        suffixText: 'ppm',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _potassiumController,
                      decoration: const InputDecoration(
                        labelText: 'Potassium (K)',
                        prefixIcon: Icon(Icons.science),
                        suffixText: 'ppm',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Environmental Parameters
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _temperatureController,
                      decoration: const InputDecoration(
                        labelText: 'Temperature',
                        prefixIcon: Icon(Icons.thermostat),
                        suffixText: '°C',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _humidityController,
                      decoration: const InputDecoration(
                        labelText: 'Humidity',
                        prefixIcon: Icon(Icons.water_drop),
                        suffixText: '%',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // pH and Soil Moisture
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _phController,
                      decoration: const InputDecoration(
                        labelText: 'pH Level',
                        prefixIcon: Icon(Icons.phonelink_setup),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _soilMoistureController,
                      decoration: const InputDecoration(
                        labelText: 'Soil Moisture',
                        prefixIcon: Icon(Icons.opacity),
                        suffixText: '%',
                      ),
                      keyboardType: TextInputType.number,
                    ),
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
                onPressed: _saveFarmDetails,
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
