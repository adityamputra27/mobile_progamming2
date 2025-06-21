import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedAdzanIndex;
  PlayerController? _playerController;
  String? _audioFilePath;
  bool isPlaying = false;

  final List<Map<String, String>> adzanList = [
    {
      "negara": "Indonesia",
      "muadzin": "Syekh Ahmad",
      "arab": "اللّهُ أَكْبَرُ",
      "latin": "Allahu Akbar",
      "audio": "assets/audio/adzan_indo.mp3",
      "logo":
          "https://upload.wikimedia.org/wikipedia/commons/0/0b/Flag_of_Indonesia.png",
    },
    {
      "negara": "Mesir",
      "muadzin": "Mahmoud Khalil",
      "arab": "اللّهُ أَكْبَرُ",
      "latin": "Allahu Akbar",
      "audio": "assets/audio/adzan_mesir.mp3",
      "logo":
          "https://upload.wikimedia.org/wikipedia/commons/f/fe/Flag_of_Egypt.svg",
    },
    {
      "negara": "Turki",
      "muadzin": "Fatih Koc",
      "arab": "الله أكبر",
      "latin": "Allahu Akbar",
      "audio": "assets/audio/adzan_turki.mp3",
      "logo":
          "https://upload.wikimedia.org/wikipedia/commons/b/b4/Flag_of_Turkey.svg",
    },
  ];

  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _initAds();
  }

  void _initAds() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // test id
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    )..load();
  }

  @override
  void dispose() {
    _playerController?.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<String> _copyAssetToLocal(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/${assetPath.split('/').last}');
    await tempFile.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
    return tempFile.path;
  }

  Future<void> _playAdzan(int idx) async {
    // Jika ada audio lain yang sedang play, stop dulu
    await _playerController?.stopPlayer();
    _playerController?.dispose();

    setState(() {
      isPlaying = false;
      selectedAdzanIndex = idx;
    });

    // Copy asset ke temp, biar bisa di-play
    final localPath = await _copyAssetToLocal(adzanList[idx]['audio']!);
    _playerController = PlayerController();

    // Extract waveform dulu (sekali saja di awal)
    await _playerController!.preparePlayer(
      path: localPath,
      shouldExtractWaveform: true,
    );

    setState(() {
      _audioFilePath = localPath;
      isPlaying = true;
    });

    await _playerController!.startPlayer();

    // listen selesai
    _playerController!.onCompletion.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  Future<void> _togglePlayer() async {
    if (isPlaying) {
      await _playerController?.pausePlayer();
    } else {
      await _playerController?.startPlayer();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedAdzan =
        selectedAdzanIndex != null ? adzanList[selectedAdzanIndex!] : null;

    return Scaffold(
      backgroundColor: const Color(0xFF185B4D),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header & Teks Adzan
                if (selectedAdzan != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 24,
                    ),
                    color: const Color(0xFF185B4D),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo Negara
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                selectedAdzan["logo"]!,
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              selectedAdzan["negara"] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Muadzin: ${selectedAdzan["muadzin"]}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          selectedAdzan["arab"] ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Amiri',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          selectedAdzan["latin"] ?? '',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Visualizer asli audio_waveforms
                if (selectedAdzanIndex != null &&
                    _playerController != null &&
                    _audioFilePath != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AudioFileWaveforms(
                        playerController: _playerController!,
                        size: Size(MediaQuery.of(context).size.width - 48, 54),
                        waveformType: WaveformType.fitWidth,
                        playerWaveStyle: PlayerWaveStyle(
                          fixedWaveColor: Colors.greenAccent,
                          liveWaveColor: Colors.white,
                          showSeekLine: false,
                          spacing: 4,
                          waveThickness: 2,
                        ),
                      ),
                    ),
                  ),

                // Tombol Play bulat
                if (selectedAdzanIndex != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: _togglePlayer,
                          child: Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 38,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // List Adzan
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: adzanList.length,
                      itemBuilder: (context, idx) {
                        final item = adzanList[idx];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 22,
                            backgroundImage: NetworkImage(item["logo"]!),
                          ),
                          title: Text(item["negara"] ?? ''),
                          subtitle: Text(
                            'Muadzin: ${item["muadzin"]}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing:
                              selectedAdzanIndex == idx
                                  ? Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.green.shade700,
                                    size: 32,
                                  )
                                  : null,
                          onTap: () => _playAdzan(idx),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 64),
              ],
            ),
            // Floating Banner Ads
            if (_bannerAd != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 8,
                child: Center(
                  child: Container(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4),
                      ],
                    ),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
