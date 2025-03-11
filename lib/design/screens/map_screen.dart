import 'package:afa/design/components/side_bar_menu.dart';
import 'package:afa/logic/providers/routes_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  bool _showDistance = false;
  late AnimationController _animationController;
  
  LatLng _currentLocation = const LatLng(38.0358053, -4.0247146); 
  LatLng _driverLocation = const LatLng(38.0386, -3.7746); 
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
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

    _mapController?.animateCamera(CameraUpdate.newLatLng(_currentLocation));
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _moveDriver() {
    setState(() {
      _driverLocation = LatLng(
        _driverLocation.latitude + 0.001,
        _driverLocation.longitude + 0.001,
      );
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(_driverLocation));
  }

  void _calculateDistance() {
    Provider.of<RoutesProvider>(context, listen: false)
        .calculateRoute(_currentLocation, _driverLocation);
    setState(() {
      _showDistance = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showDistance = false;
        });
      }
    });
  }
  
  
  @override
  void dispose() {
    _animationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RoutesProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          // AppBar con gradiente y botón a la izquierda
          Container(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF063970), Color(0xFF66B3FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isMenuOpen ? Icons.close : Icons.menu,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: _toggleMenu,
                ),
                const SizedBox(width: 10),
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
              ],
            ),
          ),

          // Menú de opciones con botones estilizados
          Padding(
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

          // Mapa
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
                  tiltGesturesEnabled: true,
                  compassEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
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

                // Texto de distancia y tiempo estimado
                
                if (routeProvider.isLoading)
                  const Positioned(
                    bottom: 70,
                    left: 20,
                    right: 20,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (routeProvider.hasError)
                  Positioned(
                    bottom: 70,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Error al calcular la ruta",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else if (routeProvider.distance > 0)
                  if(_showDistance)
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
                          "Distancia: ${routeProvider.distance.toStringAsFixed(2)} km | Tiempo estimado: ${routeProvider.estimatedTime.toStringAsFixed(0)} min",
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                
                // Sidebar Menu cuando está activo
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [Color(0xFF063970), Color(0xFF66B3FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}
