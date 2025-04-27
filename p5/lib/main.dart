import 'package:flutter/material.dart';
import 'package:p5/screens/gempa_dirasakan.dart';
import 'package:p5/screens/gempa_terbaru.dart';
import 'package:p5/screens/gempa_terkini.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedScreenIndex = 0;
  List screens = [GempaTerbaru(), GempaTerkini(), GempaDirasakan()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Data Gempa BMKG",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        actions: <Widget>[
          PopupMenuButton(
            iconColor: Colors.white,
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    child: Text('Gempa Terbaru'),
                    onTap: () {
                      setState(() {
                        selectedScreenIndex = 0;
                      });
                    },
                  ),
                  PopupMenuItem(
                    child: Text('Gempa 5+ Magnitudo'),
                    onTap: () {
                      setState(() {
                        selectedScreenIndex = 1;
                      });
                    },
                  ),
                  PopupMenuItem(
                    child: Text('Gempa Dirasakan'),
                    onTap: () {
                      setState(() {
                        selectedScreenIndex = 2;
                      });
                    },
                  ),
                ],
          ),
        ],
      ),
      body: screens[selectedScreenIndex],
    );
  }
}
