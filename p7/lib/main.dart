import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const DzikirApp());
}

class DzikirApp extends StatelessWidget {
  const DzikirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dzikir Pagi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF185B4D),
      ),
      home: const DzikirScreen(),
    );
  }
}

class DzikirScreen extends StatefulWidget {
  const DzikirScreen({super.key});

  @override
  State<DzikirScreen> createState() => _DzikirScreenState();
}

class _DzikirScreenState extends State<DzikirScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data dzikir langsung di code, bisa load dari JSON file/asset kalau mau
  final List<Map<String, dynamic>> dzikirList = [
    {
      "judul": "Ayat Kursi",
      "arab":
          "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ، لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ، لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ، مَنْ ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ، يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ، وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ، وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ، وَلَا يَئُودُهُ حِفْظُهُمَا، وَهُوَ الْعَلِيُّ الْعَظِيمُ",
      "latin":
          "Allahu laa ilaaha illaa huwal hayyul qayyuum, laa ta’khudzuhu sinatuw wa laa nawm, lahu maa fissamaawaati wa maa fil ardli, man dzalladzii yasyfa’u ‘indahu illaa bi idznih, ya’lamu maa baina aidiihim wa maa khalfahum, wa laa yuhiithuuna bisyai’in min ‘ilmi hi illaa bimaa syaa’, wasi’a kursiyyuhus samaawaati wal ardla, wa laa ya’uuduhu hifzuhumaa wa huwal ‘aliyyul azhiim.",
      "arti":
          "Allah, tidak ada Tuhan melainkan Dia Yang Maha Hidup, terus-menerus mengurus (makhluk-Nya)...",
      "audio": "", // bisa diisi path mp3
      "jumlah": 1,
    },
    {
      "judul": "Sayyidul Istighfar",
      "arab":
          "اللَّهُمَّ أَنْتَ رَبِّي لا إِلَهَ إِلا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي، فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلا أَنْتَ.",
      "latin":
          "Allahumma anta rabbii laa ilaaha illaa anta, khalaqtanii wa anaa ‘abduka, wa anaa ‘alaa ‘ahdika wa wa’dika mas tata’tu, a’uudzu bika min syarri maa shana’tu, abuu’u laka bini’matika ‘alayya, wa abuu’u bidzanbii, faghfir lii fa innahu laa yaghfirudz dzunuuba illaa anta.",
      "arti":
          "Ya Allah, Engkau adalah Rabbku, tidak ada Tuhan selain Engkau. Engkau telah menciptakanku dan aku adalah hamba-Mu...",
      "audio": "",
      "jumlah": 1,
    },
    {
      "judul": "Dzikir Tasbih Pagi",
      "arab": "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
      "latin": "Subhanallahi wabihamdih.",
      "arti": "Maha suci Allah dan segala puji bagi-Nya.",
      "audio": "",
      "jumlah": 100,
    },
  ];

  // State untuk toggle & counter per dzikir (per halaman)
  List<bool> showArab = [];
  List<bool> showLatin = [];
  List<double> fontSizes = [];
  List<int> counters = [];

  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Init state list per dzikir
    showArab = List.filled(dzikirList.length, true);
    showLatin = List.filled(dzikirList.length, true);
    fontSizes = List.filled(dzikirList.length, 26.0);
    counters = List.generate(
      dzikirList.length,
      (i) => dzikirList[i]['jumlah'] > 1 ? 0 : 1,
    );
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  void _toggleAudio(int idx) async {
    final audio = dzikirList[idx]['audio'] ?? '';
    if (audio == null || audio.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Audio belum tersedia.")));
      return;
    }
    await _audioPlayer?.stop();
    await _audioPlayer?.play(AssetSource(audio.replaceAll('assets/', '')));
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Teks berhasil disalin')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dzikir Pagi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF185B4D),
        centerTitle: true,
        elevation: 0,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: dzikirList.length,
        onPageChanged: (i) => setState(() => _currentPage = i),
        itemBuilder: (context, idx) {
          final dzikir = dzikirList[idx];
          final showCounter = dzikir['jumlah'] > 1;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Judul
                    Text(
                      dzikir['judul'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),

                    // Player audio
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => _toggleAudio(idx),
                          icon: const Icon(
                            Icons.volume_up,
                            size: 32,
                            color: Colors.green,
                          ),
                          tooltip: 'Putar audio',
                        ),
                        const SizedBox(width: 8),
                        // Font size controls
                        IconButton(
                          onPressed: () {
                            setState(() {
                              fontSizes[idx] = (fontSizes[idx] + 2).clamp(
                                16.0,
                                50.0,
                              );
                            });
                          },
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.black87,
                          ),
                          tooltip: 'Perbesar',
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              fontSizes[idx] = (fontSizes[idx] - 2).clamp(
                                16.0,
                                50.0,
                              );
                            });
                          },
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.black87,
                          ),
                          tooltip: 'Perkecil',
                        ),
                        const SizedBox(width: 8),
                        // Toggle Arab/Latin
                        Row(
                          children: [
                            const Text('Arab', style: TextStyle(fontSize: 12)),
                            Switch(
                              value: showArab[idx],
                              onChanged:
                                  (val) => setState(() => showArab[idx] = val),
                              activeColor: Colors.green,
                            ),
                            const Text('Latin', style: TextStyle(fontSize: 12)),
                            Switch(
                              value: showLatin[idx],
                              onChanged:
                                  (val) => setState(() => showLatin[idx] = val),
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Teks arab & latin
                    if (showArab[idx]) ...[
                      SelectableText(
                        dzikir['arab'],
                        style: TextStyle(
                          fontSize: fontSizes[idx],
                          fontFamily: 'Amiri',
                          color: Colors.black,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (showLatin[idx]) ...[
                      SelectableText(
                        dzikir['latin'],
                        style: TextStyle(
                          fontSize: fontSizes[idx] - 2,
                          color: Colors.grey[800],
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Arti
                    Text(
                      dzikir['arti'],
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Copy button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed:
                              () => _copyText(
                                "${dzikir['arab']}\n${dzikir['latin']}\n${dzikir['arti']}",
                              ),
                          icon: const Icon(Icons.copy, color: Colors.green),
                          tooltip: 'Copy semua teks',
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed:
                                  _currentPage > 0
                                      ? () {
                                        _pageController.previousPage(
                                          duration: Duration(milliseconds: 400),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                      : null,
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed:
                                  _currentPage < dzikirList.length - 1
                                      ? () {
                                        _pageController.nextPage(
                                          duration: Duration(milliseconds: 400),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                      : null,
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Counter dzikir
                    if (showCounter) ...[
                      const SizedBox(height: 18),
                      const Text(
                        'Counter Dzikir:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                counters[idx] = 0;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('Reset'),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${counters[idx]} / ${dzikir['jumlah']}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed:
                                counters[idx] < dzikir['jumlah']
                                    ? () {
                                      setState(() {
                                        counters[idx]++;
                                      });
                                    }
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(12),
                            ),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
