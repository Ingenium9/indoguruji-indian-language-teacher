import 'package:flutter/material.dart';
import 'package:indian_language_teacher/network/network.dart';
import 'package:indian_language_teacher/widgets/sound_player.dart';

class IntroChar extends StatefulWidget {
  const IntroChar({super.key, required this.lessonData, this.onLessonComplete});
  final Map<String, dynamic> lessonData;
  final Function? onLessonComplete;
  @override
  State<IntroChar> createState() => _IntroCharState();
}

class _IntroCharState extends State<IntroChar> {
  @override
  Widget build(BuildContext context) {
    final audioUrl = Networker.baseUrlStaticData +
        widget.lessonData["options"].first["data"];
    debugPrint(audioUrl.toString());
    final data = widget.lessonData["data"];
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
                        "Listen to the sound of character",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromRGBO(217, 217, 217, 1),
                      ),
                      padding: const EdgeInsets.all(30),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        child: PlaySound(
                          audioUrl: audioUrl,
                          id: 1,
                          isPlaying: (p0) {},
                          isSelectable: true,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  bool checkLesson() {
    return true;
  }
}
