import 'package:flutter/material.dart';
import 'package:p2/screens/home_screen.dart';

class MeasureConversionScreen extends StatefulWidget {
  const MeasureConversionScreen({super.key});

  @override
  State<MeasureConversionScreen> createState() =>
      _MeasureConversionScreenState();
}

class _MeasureConversionScreenState extends State<MeasureConversionScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedConversion = 'km ke m';
  double? _result;

  void _convertMeasure() {
    double input = double.tryParse(_controller.text) ?? 0;
    double output = 0;

    switch (_selectedConversion) {
      case 'km ke m':
        output = input * 1000;
        break;
      case 'm ke cm':
        output = input * 100;
        break;
      case 'mil ke km':
        output = input * 1.60934;
        break;
      case 'ft ke inch':
        output = input * 12;
        break;
      default:
        output = 0;
        break;
    }

    setState(() {
      _result = output;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  Image.asset("assets/icons/measuring-tape.png", width: 90),
                  const SizedBox(height: 24),
                  Text(
                    'Konversi Jarak',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  top: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pilih konversi :'),
                        SizedBox(
                          width: 190,
                          child: Expanded(
                            child: DropdownButton(
                              value: _selectedConversion,
                              items:
                                  [
                                    'km ke m',
                                    'm ke cm',
                                    'mil ke km',
                                    'ft ke inch',
                                  ].map((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedConversion = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Masukkan angka :'),
                        SizedBox(
                          width: 190,
                          child: Expanded(
                            child: TextField(
                              controller: _controller,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Hasil :'),
                        SizedBox(
                          width: 190,
                          child:
                              (_result != null)
                                  ? Text(
                                    '$_result',
                                    style: TextStyle(fontSize: 16),
                                  )
                                  : Text('0', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.grey[200],
                          ),
                          child: Text(
                            'Kembali',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _convertMeasure();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          child: Text(
                            'Hitung',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey[100],
    );
  }
}
