import 'package:flutter/material.dart';
import 'package:indian_language_teacher/network/network.dart';
import 'package:indian_language_teacher/widgets/duobutton.dart';
import 'package:just_audio/just_audio.dart';

class IntroWord extends StatefulWidget {
  const IntroWord({super.key, required this.lessonData});
  final Map<String, dynamic> lessonData;
  @override
  State<IntroWord> createState() => _IntroWordState();
}

class _IntroWordState extends State<IntroWord> {
  final player = AudioPlayer();

  _playEnglishAudio() async {
    try {
      await player.setUrl(Networker.baseUrlStaticData +
          widget.lessonData["extras"]['optionAudio']);
      player.play();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _playIndianWord() async {
    try {
      await player.setUrl(Networker.baseUrlStaticData +
          widget.lessonData["extras"]['dataAudio']);
      player.play();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final englishWord = widget.lessonData["options"][0]['data'].toString();
    final indianWord = widget.lessonData["data"];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DuoButton(
            foreGroundColor: Colors.amber,
            onPressed: () {
              _playEnglishAudio();
            },
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.volume_up,
                      size: 40,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    englishWord,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
          DuoButton(
            onPressed: () {
              _playIndianWord();
            },
            foreGroundColor: Colors.blueAccent,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(
                        Icons.volume_up,
                        size: 40,
                      )),
                ),
                Expanded(
                  child: Text(
                    indianWord,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
