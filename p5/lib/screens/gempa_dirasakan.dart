import 'package:flutter/material.dart';

class GempaDirasakan extends StatefulWidget {
  const GempaDirasakan({super.key});

  @override
  State<GempaDirasakan> createState() => GempaDirasakanState();
}

class GempaDirasakanState extends State<GempaDirasakan> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(backgroundColor: Colors.blue),
            child: Text(
              'Data Gempa Dirasakan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
