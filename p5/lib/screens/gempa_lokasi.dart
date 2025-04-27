import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GempaLokasi extends StatefulWidget {
  final Map gempaData;
  const GempaLokasi({super.key, required this.gempaData});

  @override
  State<GempaLokasi> createState() => _GempaLokasiState();
}

class _GempaLokasiState extends State<GempaLokasi> {
  bool isLoading = true;

  late GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  LatLng? currentPosition;
  late LatLng earthquakeCenter;
  double distanceInKm = 0.0;

  @override
  void initState() {
    super.initState();
    earthquakeCenter = LatLng(
      double.parse(widget.gempaData['Coordinates'].split(',')[0]),
      double.parse(widget.gempaData['Coordinates'].split(',')[1]),
    );
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    setState(() {
      currentPosition = LatLng(-6.830756092280379, 107.13521181713685);
      distanceInKm = _calculateDistance(
        currentPosition!.latitude,
        currentPosition!.longitude,
        earthquakeCenter.latitude,
        earthquakeCenter.longitude,
      );
      isLoading = false;
    });
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: earthquakeCenter,
                        zoom: 5,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('currentPosition'),
                          position: currentPosition!,
                          infoWindow: InfoWindow(
                            title:
                                'Posisi Anda ${distanceInKm.toStringAsFixed(1)} km dari pusat gempa',
                          ),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue,
                          ),
                        ),
                        Marker(
                          markerId: MarkerId('earthquakeCenter'),
                          position: earthquakeCenter,
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed,
                          ),
                          infoWindow: InfoWindow(title: 'Pusat Gempa'),
                        ),
                      },
                      circles: {
                        Circle(
                          circleId: CircleId('radius'),
                          center: earthquakeCenter,
                          radius: 500000,
                          strokeWidth: 2,
                          strokeColor: Colors.red,
                          fillColor: Colors.red.withOpacity(0.1),
                        ),
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Jarak Anda dari pusat gempa: ${distanceInKm.toStringAsFixed(2)} km',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
