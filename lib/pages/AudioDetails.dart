import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

import '../services/AudioApi.dart';

class AudioDetailsPage extends StatefulWidget {
  final Sura surah;

  AudioDetailsPage({Key? key, required this.surah}) : super(key: key);

  @override
  _AudioDetailsPageState createState() => _AudioDetailsPageState();
}

class _AudioDetailsPageState extends State<AudioDetailsPage> {
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  bool isShuffleOn = false;
  double currentSliderValue = 0.0;
  Duration currentPlaybackPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  int currentAyaIndex = 0;

  @override
  void initState() {
    super.initState();
    player.onDurationChanged.listen((duration) {
      setState(() {
        totalDuration = duration;
      });
    });
    player.onPositionChanged.listen((position) {
      setState(() {
        currentPlaybackPosition = position;
        currentSliderValue = position.inSeconds.toDouble();
      });
    });
    player.onPlayerComplete.listen((_) {
      skipToNextAya();
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> playAya(int surahNo, int ayaNo) async {
    final url = 'https://api.alquran.cloud/v1/ayah/$surahNo:$ayaNo/editions/ar.alafasy';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] != null && data['data'][0]['audio'] != null) {
        final audioUrl = data['data'][0]['audio'];
        await player.play(UrlSource(audioUrl));
        setState(() {
          isPlaying = true;
        });
      } else {
        print('Invalid response structure: $data');
        throw Exception('Invalid response structure');
      }
    } else {
      print('Failed to load ayah audio: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load ayah audio');
    }
  }

  void playWholeSurah() async {
    if (currentAyaIndex < widget.surah.ayahs.length) {
      final aya = widget.surah.ayahs[currentAyaIndex];
      await playAya(widget.surah.number!, aya.number!);
    }
  }

  void pauseSurah() async {
    await player.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void stopPlaying() async {
    await player.stop();
    setState(() {
      isPlaying = false;
      currentPlaybackPosition = Duration.zero;
      currentSliderValue = 0.0;
      currentAyaIndex = 0;
    });
  }

  void toggleShuffle() {
    setState(() {
      isShuffleOn = !isShuffleOn;
    });
  }

  void skipToNextAya() async {
    await player.stop();
    if (currentAyaIndex < widget.surah.ayahs.length - 1) {
      currentAyaIndex++;
      playWholeSurah();
    }
  }

  void skipToPreviousAya() async {
    await player.stop();
    if (currentAyaIndex > 0) {
      currentAyaIndex--;
      playWholeSurah();
    }
  }

  void skipToTime(double timeInSeconds) {
    player.seek(Duration(seconds: timeInSeconds.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    final surah = widget.surah;
    return Scaffold(
      appBar: AppBar(
        title: Text(surah.name ?? 'Surah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Image.network(
                  "https://img.freepik.com/free-photo/holy-quran-hand-with-arabic-calligraphy-meaning-al-quran_181624-49586.jpg?t=st=1720029528~exp=1720033128~hmac=f11ac0e15e2b749395b0bbf7c8df29c5e04664a9dbcde55fdb6ef5b25fbf0d3b&w=740",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                width: 370,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(surah.englishName ?? ''),
                    const SizedBox(
                      height: 25,
                    ),
                    Slider(
                      max: totalDuration.inSeconds.toDouble(),
                      min: 0,
                      activeColor: Colors.teal,
                      secondaryActiveColor: Colors.red,
                      value: currentSliderValue,
                      onChanged: (val) {
                        setState(() {
                          currentSliderValue = val;
                        });
                        skipToTime(val);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatDuration(currentPlaybackPosition)),
                        Text(formatDuration(totalDuration)),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.shuffle),

                          onPressed: toggleShuffle,
                          color: isShuffleOn ? Colors.red : Colors.black,
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_previous),
                          onPressed: skipToPreviousAya,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isPlaying) {
                              pauseSurah();
                            } else {
                              playWholeSurah();
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow_outlined,
                              size: 30,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_next),
                          onPressed: skipToNextAya,
                        ),
                        IconButton(
                          icon: Icon(Icons.repeat),
                          onPressed: () {
                            Future<void> playAya(int surahNo, int ayaNo) async {
                              final url = 'https://api.alquran.cloud/v1/ayah/$surahNo:$ayaNo/editions/ar.alafasy';
                              print('Requesting URL: $url'); // Log the requested URL

                              final response = await http.get(Uri.parse(url));

                              if (response.statusCode == 200) {
                                final data = json.decode(response.body);
                                print('Response data: $data'); // Log the response data

                                if (data['data'] != null && data['data'][0]['audio'] != null) {
                                  final audioUrl = data['data'][0]['audio'];
                                  await player.play(UrlSource(audioUrl));
                                  setState(() {
                                    isPlaying = true;
                                  });
                                } else {
                                  print('Invalid response structure: $data'); // Log invalid structure
                                  throw Exception('Invalid response structure');
                                }
                              } else {
                                print('Failed to load ayah audio: ${response.statusCode}'); // Log error code
                                print('Response body: ${response.body}'); // Log response body
                                throw Exception('Failed to load ayah audio');
                              }
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
