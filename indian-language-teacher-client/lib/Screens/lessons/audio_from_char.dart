import 'package:flutter/material.dart';
import 'package:indian_language_teacher/network/network.dart';
import 'package:indian_language_teacher/widgets/sound_player_radio.dart';

class AudioFromChar extends StatefulWidget {
  const AudioFromChar({
    Key? key,
    required this.lessonData,
    required this.onSelectedUpdated,
  }) : super(key: key);
  final Map<String, dynamic> lessonData;
  final Function(int selectedIndex) onSelectedUpdated;
  @override
  State<AudioFromChar> createState() => _AudioFromCharState();
}

class _AudioFromCharState extends State<AudioFromChar> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final data = widget.lessonData["data"];
    List<dynamic> options = widget.lessonData["options"];
    options.sort((a, b) {
      return int.parse(a["number"].toString())
          .compareTo(int.parse(b["number"].toString()));
    });
    List<String> audioUrls = options.map((e) {
      return Networker.baseUrlStaticData + (e["data"] as String);
    }).toList();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Select the correct sound",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromRGBO(217, 217, 217, 1),
                      ),
                      padding: const EdgeInsets.all(25),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Text(data.toString().trim(),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 32)),
                        ),
                      ),
                    )
                  ]),
            ),
            Expanded(
                flex: 2,
                child: SoundPlayerRadio(
                  audioUrl: audioUrls,
                  onSelectionChanged: (index) {
                    setState(() {
                      selected = index;
                    });
                    widget.onSelectedUpdated(index);
                  },
                )),
          ],
        ),
      ),
    );
  }

  bool checkLesson() {
    return selected == widget.lessonData["correctOption"];
  }
}
