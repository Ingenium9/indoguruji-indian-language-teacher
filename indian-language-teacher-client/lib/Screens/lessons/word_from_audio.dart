import 'package:flutter/material.dart';
import 'package:indian_language_teacher/network/network.dart';
import 'package:indian_language_teacher/theme/theme.dart';
import 'package:indian_language_teacher/widgets/duobutton.dart';
import 'package:indian_language_teacher/widgets/text_option_radio.dart';
import 'package:just_audio/just_audio.dart';

class WordFromAudio extends StatefulWidget {
  const WordFromAudio(
      {super.key, required this.lessonData, required this.onSelectedUpdated});
  final Map<String, dynamic> lessonData;
  final Function(int selectedIndex) onSelectedUpdated;
  @override
  State<WordFromAudio> createState() => _WordFromAudioState();
}

class _WordFromAudioState extends State<WordFromAudio> {
  final player = AudioPlayer();

  _playAudio() async {
    await player
        .setUrl(Networker.baseUrlStaticData + widget.lessonData["data"]);
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> options = List<String>.from(
        widget.lessonData["options"].map((e) => e["data"].toString()).toList());
    debugPrint(options.toString());
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: DuoButton(
                  onPressed: () => _playAudio(),
                  foreGroundColor: CustomTheme.borderColor,
                  child: const Icon(Icons.volume_up)),
            ),
          ),
        ),
        Expanded(
          child: TextOptionRadio(
              options: options,
              onSelectionChanged: (p0) => widget.onSelectedUpdated(p0)),
        )
      ],
    );
  }
}
