import 'package:flutter/material.dart';
import 'package:p4/screens/story_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE4FEF5),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: Column(
                    children: [
                      Text(
                        'Buku Cerpen',
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'Theren',
                          color: Color(0xffFEC740),
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 20.0,
                              color: Colors.white,
                            ),
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 5.0,
                              color: Color(0xffF58F00),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Kisah Dongeng & Cerita Hewan',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Chubby',
                          color: Color(0xFFFFFFFF),
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 20.0,
                              color: Colors.white,
                            ),
                            Shadow(
                              offset: Offset(0.75, 0.75),
                              blurRadius: 5.0,
                              color: Color.fromARGB(255, 97, 97, 97),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 64),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StoryScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.book, color: Colors.white),
                        label: Text(
                          'Start Telling',
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff80C3B5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 64),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.share, color: Colors.white),
                        label: Text(
                          'Share App',
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffF5921E),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 64),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.feedback, color: Colors.white),
                        label: Text(
                          'Leave a Review',
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffFFDB0F),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(0),
                child: Image.asset('assets/images/home.jpg', fit: BoxFit.cover),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
