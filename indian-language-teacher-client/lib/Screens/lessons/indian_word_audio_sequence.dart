import 'package:flutter/material.dart';
import 'package:indian_language_teacher/network/network.dart';
import 'package:indian_language_teacher/theme/theme.dart';
import 'package:indian_language_teacher/widgets/duobutton.dart';
import 'package:indian_language_teacher/widgets/sequence_button_manager.dart';
import 'package:just_audio/just_audio.dart';

class IndianWordAudioSequence extends StatefulWidget {
  const IndianWordAudioSequence(
      {super.key,
      required this.lessonData,
      required this.onSelectedUpdated,
      required this.selectedItems});
  final Map<String, dynamic> lessonData;
  final List<int> selectedItems;
  final Function(List<int> selectedItems, int selectedIndex) onSelectedUpdated;
  @override
  State<IndianWordAudioSequence> createState() =>
      _IndianWordAudioSequenceState();
}

class _IndianWordAudioSequenceState extends State<IndianWordAudioSequence> {
  final player = AudioPlayer();
  late List<Map<String, dynamic>> words;

  _playEnglishAudio() async {
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
    words = List.from(widget.lessonData["extraData"]["words"]);
    words.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DuoButton(
                  foreGroundColor: CustomTheme.borderColor,
                  onPressed: () {
                    _playEnglishAudio();
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [Icon(Icons.volume_up)]),
                ),
              ],
            ),
          ),
        ),
        Expanded(
            child: SequenceButtonManager(
          words: words,
          selectedItems: widget.selectedItems,
          onUpdate: (selectedIndexs) {
            bool isCorrect = false;
            if (selectedIndexs.length == words.length) {
              for (var index in selectedIndexs) {
                if (words[index]['index'] == selectedIndexs.indexOf(index)) {
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
        ))
      ]),
    );
  }
}
