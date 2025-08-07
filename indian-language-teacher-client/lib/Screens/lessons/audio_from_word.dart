import 'package:flutter/material.dart';
import 'package:indian_language_teacher/network/network.dart';
import 'package:indian_language_teacher/theme/theme.dart';
import 'package:indian_language_teacher/widgets/duobutton.dart';
import 'package:indian_language_teacher/widgets/sound_player_radio.dart';

class AudioFromWord extends StatefulWidget {
  const AudioFromWord(
      {super.key, required this.lessonData, required this.onSelectedUpdated});
  final Map<String, dynamic> lessonData;
  final Function(int selectedIndex) onSelectedUpdated;
  @override
  State<AudioFromWord> createState() => _AudioFromWordState();
}

class _AudioFromWordState extends State<AudioFromWord> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              height: 100,
              child: DuoButton(
                foreGroundColor: CustomTheme.borderColor,
                child: Text(
                  widget.lessonData["data"].toString().trim(),
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SoundPlayerRadio(
            audioUrl: [
              ...widget.lessonData["options"]
                  .map((e) => Networker.baseUrlStaticData + e["data"])
                  .toList()
            ],
            onSelectionChanged: (p0) => widget.onSelectedUpdated(p0),
          ),
        )
      ],
    );
  }
}
