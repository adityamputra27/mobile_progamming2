import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p3/screens/detail_news_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List _newsItems = [];

  Future<void> readNewsJSON() async {
    final String respose = await rootBundle.loadString('assets/json/news.json');
    final data = await jsonDecode(respose);

    setState(() {
      _newsItems = data;
    });
  }

  @override
  void initState() {
    super.initState();
    readNewsJSON();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.topCenter,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: Image.asset('assets/images/breaking_news_thumbnail.jpg'),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text(
                'Breaking News',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            _newsItems.isNotEmpty
                ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: _newsItems.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    DetailNewsScreen(news: _newsItems[index]),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '• ${_newsItems[index]['title_news']}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                )
                : Container(),
          ],
        ),
      ),
    );
  }
}
