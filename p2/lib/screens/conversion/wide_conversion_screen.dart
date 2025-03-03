import 'package:flutter/material.dart';
import 'package:p2/screens/home_screen.dart';

class WideConversionScreen extends StatefulWidget {
  const WideConversionScreen({super.key});

  @override
  State<WideConversionScreen> createState() => _WideConversionScreenState();
}

class _WideConversionScreenState extends State<WideConversionScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedConversion = 'Meter ke cm';
  double? _result;

  void _converWide() {
    double input = double.tryParse(_controller.text) ?? 0;
    double output = 0;

    switch (_selectedConversion) {
      case 'Meter ke cm':
        output = input * 10000;
        break;
      case 'Meter ke mm':
        output = input * 10000000;
        break;
      case 'Centimeter ke m²':
        output = input / 10000;
        break;
      case 'Millimeter ke m²':
        output = input / 1000000;
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
                  Image.asset("assets/icons/wide.png", width: 90),
                  const SizedBox(height: 24),
                  Text(
                    'Konversi Luas',
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
                                    'Meter ke cm',
                                    'Meter ke mm',
                                    'Centimeter ke m²',
                                    'Millimeter ke m²',
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
                            _converWide();
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
