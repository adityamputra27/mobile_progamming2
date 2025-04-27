import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:p5/bmkg.dart';

class GempaTerbaru extends StatefulWidget {
  const GempaTerbaru({super.key});

  @override
  State<GempaTerbaru> createState() => _GempaTerbaruState();
}

class _GempaTerbaruState extends State<GempaTerbaru> {
  late GoogleMapController mapController;

  bool isLoading = true;
  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Map gempaTerbaru = {};
  Future<void> readData() async {
    var response = await http.get(Uri.parse(BMKGDataGempa.autoGempaURL));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var infogempadata = jsonResponse['Infogempa'];

      setState(() {
        gempaTerbaru = infogempadata;
        isLoading = false;
      });
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Container(
              height: 500,
              padding: const EdgeInsets.only(bottom: 16),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    double.parse(
                      gempaTerbaru['gempa']['Coordinates'].split(',')[0],
                    ),
                    double.parse(
                      gempaTerbaru['gempa']['Coordinates'].split(',')[1],
                    ),
                  ),
                  zoom: 8.0,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(gempaTerbaru['gempa']['Shakemap']),
                    position: LatLng(
                      double.parse(
                        gempaTerbaru['gempa']['Coordinates'].split(',')[0],
                      ),
                      double.parse(
                        gempaTerbaru['gempa']['Coordinates'].split(',')[1],
                      ),
                    ),
                  ),
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width / 2.75,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/illustration.png',
                          width: 100,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Skala MMI II',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Informasi Gempa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${gempaTerbaru['gempa']['Tanggal']}, ${gempaTerbaru['gempa']['Jam']}, ${gempaTerbaru['gempa']['Magnitude']} Magnitudo, Kedalaman ${gempaTerbaru['gempa']['Kedalaman']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dirasakan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${gempaTerbaru['gempa']['Dirasakan']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Potensi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${gempaTerbaru['gempa']['Potensi']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
        : Center(child: CircularProgressIndicator());
  }
}
