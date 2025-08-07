import 'package:flutter/material.dart';
import 'package:indian_language_teacher/theme/theme.dart';
import 'package:indian_language_teacher/widgets/duobutton.dart';
import 'package:indian_language_teacher/widgets/sequence_button_manager.dart';
import 'package:collection/collection.dart';

class IndianWordSequence extends StatefulWidget {
  const IndianWordSequence(
      {super.key,
      required this.lessonData,
      required this.onSelectedUpdate,
      required this.selectedItems});
  final Map<String, dynamic> lessonData;
  final List<int> selectedItems;
  final Function(List<int> selectedItems, int selectedIndex) onSelectedUpdate;
  @override
  State<IndianWordSequence> createState() => _IndianWordSequenceState();
}

class _IndianWordSequenceState extends State<IndianWordSequence> {
  late List<Map<String, dynamic>> words;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    words = widget.lessonData["extraData"]["sentence"]
        .toString()
        .split(" ")
        .mapIndexed((key, value) => {"index": key, "word": value})
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
                  isPressed: true,
                  child: Text(
                    widget.lessonData["data"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                )
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
                  debugPrint(index.toString());
                  debugPrint(words[index]['index'].toString());
                  debugPrint(selectedIndexs.indexOf(index).toString());
                  if (words[index]['index'] == selectedIndexs.indexOf(index)) {
                    isCorrect = true;
                  } else {
                    isCorrect = false;
                  }
                }
              }
              if (isCorrect) {
                widget.onSelectedUpdate(selectedIndexs, 1);
              } else {
                widget.onSelectedUpdate(selectedIndexs, -1);
              }
            },
            selectedItems: widget.selectedItems,
            words: words,
          ),
        )
      ],
    );
  }
}
