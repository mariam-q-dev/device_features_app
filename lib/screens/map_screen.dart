import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // موقع افتراضي (القاهرة)
  static const LatLng _initialPosition = LatLng(30.0444, 31.2357);
  late GoogleMapController _mapController;

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('default_location'),
      position: _initialPosition,
      infoWindow: InfoWindow(title: 'Cairo', snippet: 'Default Location'),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Integration'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _initialPosition,
          zoom: 12.0,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        onTap: (LatLng position) {
          setState(() {
            _markers.clear();
            _markers.add(
              Marker(
                markerId: MarkerId(position.toString()),
                position: position,
                infoWindow: InfoWindow(
                  title: 'Selected Location',
                  snippet: '${position.latitude}, ${position.longitude}',
                ),
              ),
            );
          });
        },
      ),
    );
  }
}