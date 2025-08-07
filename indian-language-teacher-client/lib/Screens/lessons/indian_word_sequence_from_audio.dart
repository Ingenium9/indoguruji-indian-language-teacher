import 'package:flutter/material.dart';
import 'package:indian_language_teacher/network/network.dart';
import 'package:indian_language_teacher/theme/theme.dart';
import 'package:indian_language_teacher/widgets/duobutton.dart';
import 'package:indian_language_teacher/widgets/sequence_button_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:collection/collection.dart';

class IndianWordSequenceFromAudio extends StatefulWidget {
  const IndianWordSequenceFromAudio(
      {super.key,
      required this.lessonData,
      required this.selectedItems,
      required this.onSelectedUpdated});
  final Map<String, dynamic> lessonData;
  final List<int> selectedItems;
  final Function(List<int> selectedItems, int selectedIndex) onSelectedUpdated;
  @override
  State<IndianWordSequenceFromAudio> createState() =>
      _IndianWordSequenceFromAudioState();
}

class _IndianWordSequenceFromAudioState
    extends State<IndianWordSequenceFromAudio> {
  final player = AudioPlayer();
  late List<Map<String, dynamic>> words;
  _playIndianSentence() async {
    try {
      await player
          .setUrl(Networker.baseUrlStaticData + widget.lessonData["data"]);
      player.play();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    words = widget.lessonData["extraData"]["sentence"]
        .toString()
        .split(" ")
        .mapIndexed((index, e) => {"index": index, "word": e})
        .toList();
    words.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DuoButton(
                  foreGroundColor: CustomTheme.borderColor,
                  onPressed: () {
                    _playIndianSentence();
                  },
                  child: const Icon(Icons.volume_up),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SequenceButtonManager(
              onUpdate: (selectedIndexs) {
                bool isCorrect = false;
                if (selectedIndexs.length == words.length) {
                  for (var index in selectedIndexs) {
                    if (words[index]['index'] ==
                        selectedIndexs.indexOf(index)) {
                      isCorrect = true;
                    } else {
                      isCorrect = false;
                    }
                  }
                }
                if (isCorrect) {
                  widget.onSelectedUpdated(selectedIndexs, 1);
                } else {
                  widget.onSelectedUpdated(selectedIndexs, -1);
                }
              },
              selectedItems: widget.selectedItems,
              words: words),
        )
      ],
    );
  }
}
