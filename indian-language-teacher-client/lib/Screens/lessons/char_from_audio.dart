import 'package:flutter/material.dart';
import 'package:indian_language_teacher/network/network.dart';
import 'package:indian_language_teacher/widgets/sound_player.dart';
import 'package:indian_language_teacher/widgets/text_option_radio.dart';

class CharFromAudio extends StatefulWidget {
  const CharFromAudio({
    Key? key,
    required this.lessonData,
    required this.onSelectedUpdated,
  }) : super(key: key);
  final Map<String, dynamic> lessonData;
  final Function(int selectedIndex) onSelectedUpdated;
  @override
  State<CharFromAudio> createState() => _CharFromAudioState();
}

class _CharFromAudioState extends State<CharFromAudio> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    final data = Networker.baseUrlStaticData + widget.lessonData["data"];
    List<dynamic> options = widget.lessonData["options"];
    options.sort((a, b) {
      return int.parse(a["number"].toString())
          .compareTo(int.parse(b["number"].toString()));
    });
    List<String> optionChars = options.map((e) {
      return e["data"] as String;
    }).toList();
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Expanded(
          flex: 2,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  child: const Text(
                    "Select the correct character",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: 90,
                  width: 100,
                  child: PlaySound(
                      audioUrl: data,
                      isPlaying: (val) {},
                      id: 5,
                      isSelectable: true),
                )
              ]),
        ),
        Expanded(
            flex: 2,
            child: TextOptionRadio(
              options: optionChars,
              onSelectionChanged: (val) {
                setState(() {
                  selected = val;
                });
                widget.onSelectedUpdated(val);
              },
            )),
      ],
    )));
  }
}
