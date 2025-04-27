import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p5/bmkg.dart';
import 'package:p5/screens/gempa_lokasi.dart';

class GempaTerkini extends StatefulWidget {
  const GempaTerkini({super.key});

  @override
  State<GempaTerkini> createState() => GempaTerbaruState();
}

class GempaTerbaruState extends State<GempaTerkini> {
  bool isLoading = true;
  List gempaTerkini = [];

  Future<void> readData() async {
    var response = await http.get(Uri.parse(BMKGDataGempa.gempaTerkiniURL));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var infogempadata = jsonResponse['Infogempa']['gempa'];

      setState(() {
        gempaTerkini = infogempadata;
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
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: gempaTerkini.length,
          itemBuilder: (context, index) {
            var data = gempaTerkini[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GempaLokasi(gempaData: data),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color:
                      index % 2 == 0
                          ? Color.fromARGB(255, 239, 243, 252)
                          : Colors.white,
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width / 3,
                          child: Text(
                            'Tanggal',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(' :  '),
                        Expanded(
                          child: Text(
                            "${data['Tanggal']}, ${data['Jam']}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width / 3,
                          child: Text('Magnitude'),
                        ),
                        Text(' :  '),
                        Expanded(
                          child: Text(
                            "${data['Magnitude']}, Kedalaman: ${data['Kedalaman']}",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width / 3,
                          child: Text('Wilayah'),
                        ),
                        Text(' :  '),
                        Expanded(child: Text("${data['Wilayah']}")),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width / 3,
                          child: Text('Potensi'),
                        ),
                        Text(' :  '),
                        Expanded(child: Text("${data['Potensi']}")),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      margin: const EdgeInsets.only(top: 8),
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }
}
