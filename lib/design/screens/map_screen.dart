import 'package:afa/design/components/side_bar_menu.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:math';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  bool _showDistance = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  LatLng _currentLocation = const LatLng(38.0386, -3.7746); // Andújar, Jaén por defecto
  LatLng _driverLocation = const LatLng(38.0406, -3.7800); // Ubicación simulada del conductor
  GoogleMapController? _mapController;
  double _distance = 0.0;
  double _estimatedTime = 0.0; // En minutos

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();

    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(_currentLocation));
    }
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _moveDriver() {
    // Simulación de movimiento del conductor
    setState(() {
      _driverLocation = LatLng(
        _driverLocation.latitude + 0.001, // Se mueve un poco
        _driverLocation.longitude + 0.001,
      );
    });

    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(_driverLocation));
    }
  }

  void _calculateDistance() {
    double distance = _haversineDistance(_currentLocation, _driverLocation);
    double estimatedTime = (distance / 0.5) * 60; // Velocidad media de 30 km/h

    setState(() {
      _distance = distance;
      _estimatedTime = estimatedTime;
      _showDistance = true;
    });

    // Ocultar el texto después de 5 segundos
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _showDistance = false;
      });
    });
  }

  double _haversineDistance(LatLng start, LatLng end) {
    const double R = 6371; // Radio de la Tierra en km
    double dLat = _degToRad(end.latitude - start.latitude);
    double dLon = _degToRad(end.longitude - start.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(start.latitude)) * cos(_degToRad(end.latitude)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distancia en km
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          // AppBar personalizada
          AppBar(
            backgroundColor: Colors.blue,
            elevation: 0,
            title: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Mapa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isMenuOpen ? Icons.close : Icons.menu,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: _toggleMenu,
                ),
              ],
            ),
          ),

          // Menú de opciones
          FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMenuButton("Centrar", Icons.my_location, _determinePosition),
                  _buildMenuButton("Conductor", Icons.directions_car, _moveDriver),
                  _buildMenuButton("Distancia", Icons.location_on, _calculateDistance),
                ],
              ),
            ),
          ),

          // Mapa expandido debajo de la AppBar y los botones
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(target: _currentLocation, zoom: 14),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: {
                    Marker(
                      markerId: const MarkerId("current"),
                      position: _currentLocation,
                      infoWindow: const InfoWindow(title: "Tu ubicación"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                    ),
                    Marker(
                      markerId: const MarkerId("driver"),
                      position: _driverLocation,
                      infoWindow: const InfoWindow(title: "Conductor"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                    ),
                  },
                ),

                // Texto de distancia y tiempo estimado (se oculta después de 5 segundos)
                if (_showDistance)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Distancia: ${_distance.toStringAsFixed(2)} km | Tiempo estimado: ${_estimatedTime.toStringAsFixed(0)} min",
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                // Sidebar Menu (cuando está activo)
                if (_isMenuOpen)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _toggleMenu,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                if (_isMenuOpen)
                  const Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: SidebarMenu(
                      selectedIndex: 2, 
                      userName: "Juan Pérez",
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
