import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../theme.dart';

class MapSelectionScreen extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;

  const MapSelectionScreen({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
  });

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  late GoogleMapController _mapController;
  LatLng? _selectedPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _selectedPosition = LatLng(widget.initialLatitude, widget.initialLongitude);
    _updateMarker();
  }

  void _updateMarker() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: _selectedPosition!,
          infoWindow: const InfoWindow(title: 'Selected Location'),
          draggable: true,
          onDragEnd: (LatLng newPosition) {
            setState(() {
              _selectedPosition = newPosition;
            });
          },
        ),
      };
    });
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedPosition = position;
      _updateMarker();
    });
  }

  void _confirmSelection() {
    Navigator.pop(context, {
      'latitude': _selectedPosition!.latitude,
      'longitude': _selectedPosition!.longitude,
    });
  }

  void _zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            onPressed: _confirmSelection,
            icon: const Icon(Icons.check),
            tooltip: 'Confirm Location',
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedPosition!,
              zoom: 15,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            onTap: _onMapTapped,
            zoomControlsEnabled: false, // Disable built-in zoom controls
            mapToolbarEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          // Custom zoom controls on the left
          Positioned(
            left: 16,
            bottom: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  mini: true,
                  onPressed: _zoomIn,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.add, color: Colors.black),
                  tooltip: 'Zoom In',
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: _zoomOut,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.remove, color: Colors.black),
                  tooltip: 'Zoom Out',
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              onPressed: _confirmSelection,
              backgroundColor: const Color(
                0xFF8B4513,
              ), // primaryBrown equivalent
              child: const Icon(Icons.check),
              tooltip: 'Confirm Location',
            ),
          ),
        ],
      ),
    );
  }
}
