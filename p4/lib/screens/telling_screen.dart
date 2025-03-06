import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class TellingScreen extends StatefulWidget {
  final Map story;
  const TellingScreen({super.key, required this.story});

  @override
  State<TellingScreen> createState() => _TellingScreenState();
}

enum TtsState { playing, stopped, paused, continued }

class _TellingScreenState extends State<TellingScreen> {
  late final PlayerController _playerController;
  String? _audioPath;
  final FlutterTts _flutterTts = FlutterTts();

  TtsState ttsState = TtsState.stopped;

  bool get isPlaying => ttsState == TtsState.playing;
  bool get isStopped => ttsState == TtsState.stopped;
  bool get isPaused => ttsState == TtsState.paused;
  bool get isContinued => ttsState == TtsState.continued;

  Future<void> _loadAudio() async {
    try {
      if (widget.story['audio'] != "GT" && widget.story['audio'] != null) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/audio.mp3';
        final response = await http.get(Uri.parse(widget.story['audio']));
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        await _playerController.preparePlayer(
          path: filePath,
          shouldExtractWaveform: true,
        );

        setState(() {
          _audioPath = filePath;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Gagal memuat audio",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Color(0xffFEC740).withAlpha(220),
      );
    }
  }

  // Future<void> _generateTTS() async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final fileName = Platform.isIOS ? 'tts_audio.caf' : 'tts_audio.wav';
  //     final filePath = '${directory.path}/$fileName';

  //     await _flutterTts.awaitSynthCompletion(true);
  //     await _flutterTts.setLanguage('id-ID');
  //     await _flutterTts.setSpeechRate(0.5);
  //     await _flutterTts.setPitch(1.0);
  //     await _flutterTts.setVolume(1.0);

  //     await _flutterTts.synthesizeToFile(
  //       widget.story['story_text'],
  //       filePath,
  //       false,
  //     );

  //     await _playerController.preparePlayer(
  //       path: filePath,
  //       shouldExtractWaveform: true,
  //     );

  //     setState(() {
  //       _audioPath = filePath;
  //       _isAudioLoaded = true;
  //     });
  //   } catch (e) {
  //     print(e);
  //     Fluttertoast.showToast(
  //       msg: "Gagal memuat audio {$e}",
  //       toastLength: Toast.LENGTH_SHORT,
  //       backgroundColor: Color(0xffFEC740).withAlpha(220),
  //     );
  //   }
  // }

  Future<void> _playTTS() async {
    if (ttsState == TtsState.playing) {
      await _flutterTts.pause();
      setState(() {
        ttsState = TtsState.paused;
      });
    } else if (ttsState == TtsState.paused ||
        ttsState == TtsState.stopped ||
        ttsState == TtsState.continued) {
      await _flutterTts.speak(widget.story['story_text']);
      setState(() {
        ttsState = TtsState.playing;
      });
    }

    print(ttsState);

    Fluttertoast.showToast(
      msg: "Audio Google Text to Speech digunakan",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Color(0xffFEC740).withAlpha(220),
    );
  }

  Future<void> _playStory() async {
    try {
      if (widget.story['audio'] != 'GT' && widget.story['audio'] != null) {
        if (_audioPath != null) {
          if (_playerController.playerState.isPlaying) {
            await _playerController.pausePlayer();
            Fluttertoast.showToast(
              msg: "Sedang pause cerita",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Color(0xffFEC740).withAlpha(220),
            );
          } else {
            if (_playerController.playerState.isStopped) {
              await _playerController.preparePlayer(path: _audioPath!);
            }

            await _playerController.startPlayer();
            Fluttertoast.showToast(
              msg: "Sedang memulai cerita",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Color(0xffFEC740).withAlpha(220),
            );
          }
          setState(() {});
        } else {
          Fluttertoast.showToast(
            msg: "Audio tidak tersedia",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Color(0xffFEC740).withAlpha(220),
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Audio tidak tersedia",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Color(0xffFEC740).withAlpha(220),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Gagal memulai cerita",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Color(0xffFEC740).withAlpha(220),
      );
    }
  }

  @override
  void dispose() {
    _playerController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _playerController = PlayerController();

    _playerController.onCompletion.listen((event) async {
      await _playerController.stopPlayer();
      setState(() {});
    });

    _loadAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        iconTheme: IconThemeData(size: 24, color: Color(0xffFEC740)),
        title: Text(
          widget.story['title'],
          style: TextStyle(
            fontFamily: "Chubby",
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xffFEC740),
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8),
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.story['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 75,
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: Color(0xff7EC5B4).withAlpha(220),
                  ),
                  child: Row(
                    children: [
                      (widget.story['audio'] != "GT")
                          ? IconButton(
                            onPressed: () {
                              _playStory();
                            },
                            icon: Icon(
                              _playerController.playerState.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Color(0xffffffff),
                              size: 24,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Color(0xffFFD90B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.all(12),
                            ),
                          )
                          : IconButton(
                            onPressed: () {
                              _playTTS();
                            },
                            icon: Icon(
                              (ttsState == TtsState.stopped ||
                                      ttsState == TtsState.paused)
                                  ? Icons.play_arrow
                                  : Icons.pause,
                              color: Color(0xffffffff),
                              size: 24,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Color(0xffFFD90B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 16),
                          child:
                              (widget.story['audio'] != "GT")
                                  ? AudioFileWaveforms(
                                    playerController: _playerController,
                                    size: Size(double.infinity, 40),
                                    backgroundColor: Color(0xffFEC740),
                                    waveformType: WaveformType.long,
                                    playerWaveStyle: const PlayerWaveStyle(
                                      fixedWaveColor: Colors.white,
                                      liveWaveColor: Colors.white,
                                      waveThickness: 2,
                                    ),
                                  )
                                  : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'File audio tidak tersedia',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '✓ Text to Speech digunakan',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Roboto",
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
              top: 16,
            ),
            child: Text(widget.story['story_text']),
          ),
        ],
      ),
    );
  }
}
