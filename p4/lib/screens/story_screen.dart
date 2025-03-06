import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p4/screens/telling_screen.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  List _items = [];
  bool isLoading = true;
  Future<void> readItemsJSON() async {
    final String response = await rootBundle.loadString(
      "assets/json/data.json",
    );
    final data = await jsonDecode(response);
    setState(() {
      _items = data['Data'];
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    readItemsJSON();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(size: 24, color: Color(0xffFEC740)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Semua Cerita',
          style: TextStyle(
            fontFamily: "Chubby",
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xffFEC740),
          ),
        ),
      ),
      backgroundColor: Color(0xffE4FEF5),
      body: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child:
            !isLoading
                ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 220,
                  ),
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: 8,
                    top: 8,
                  ),
                  itemCount: _items.length,

                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    TellingScreen(story: _items[index]),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                _items[index]['image'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  color: Color(0xffFFDB0F).withAlpha(150),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                    ),
                                    child: Text(
                                      _items[index]['title'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
                : Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 234, 205, 38),
                    backgroundColor: Color(0xffFFDB0F),
                  ),
                ),
      ),
    );
  }
}
