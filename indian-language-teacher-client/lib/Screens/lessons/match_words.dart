import 'package:flutter/material.dart';
import 'package:indian_language_teacher/theme/theme.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:indian_language_teacher/widgets/duobutton.dart';

class MatchWords extends StatefulWidget {
  const MatchWords(
      {super.key, required this.lessonData, required this.onSelectionUpdated});
  final Map<String, dynamic> lessonData;
  final Function(int selectedIndex) onSelectionUpdated;
  @override
  State<MatchWords> createState() => _MatchWordsState();
}

class _MatchWordsState extends State<MatchWords> {
  int firstColumnSelected = -1;
  int secondColumnSelected = -1;
  late List<dynamic> matchWords;
  List<List<bool>> matched =
      List.generate(2, (_) => List.generate(4, (_) => false));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    matchWords = List.from(widget.lessonData["data"]);
    matchWords.shuffle();
  }

  _checkCompleted() {
    final bool completed =
        !(matched[0].contains(false) || matched[1].contains(false));
    if (completed) {
      widget.onSelectionUpdated(1);
    } else {
      widget.onSelectionUpdated(0);
    }
  }

  _onSelectionFirstColumn(int selectedIndex) {
    setState(() {
      firstColumnSelected = selectedIndex;
    });
    if (secondColumnSelected != -1) {
      final firstColumn = widget.lessonData["data"] as List<dynamic>;
      final secondColumn = matchWords;
      final bool isCorrect = firstColumn[selectedIndex]["match"] ==
          secondColumn[secondColumnSelected]["match"];
      debugPrint(
          "selectedIndex: $selectedIndex\nsecoundColumnSelected: $secondColumnSelected");
      if (isCorrect) {
        setState(() {
          debugPrint(matched[0].toString());
          matched[0][selectedIndex] = true;
          matched[1][secondColumnSelected] = true;
          firstColumnSelected = -1;
          secondColumnSelected = -1;
        });
      } else {
        debugPrint("Wrong selection");
      }
    }
    _checkCompleted();
  }

  _onSelectionSecondColumn(int selectedIndex) {
    setState(() {
      secondColumnSelected = selectedIndex;
    });
    if (firstColumnSelected != -1) {
      final firstColumn = widget.lessonData["data"] as List<dynamic>;
      final secondColumn = matchWords;
      final bool isCorrect = firstColumn[firstColumnSelected]["match"] ==
          secondColumn[selectedIndex]["match"];
      if (isCorrect) {
        setState(() {
          matched[0][firstColumnSelected] = true;
          matched[1][selectedIndex] = true;
          firstColumnSelected = -1;
          secondColumnSelected = -1;
        });
      }
    }
    _checkCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...(widget.lessonData["data"] as List<dynamic>)
                    .mapIndexed((i, e) => TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 100),
                          tween: Tween<double>(
                              begin: 0,
                              end: firstColumnSelected == i || matched[0][i]
                                  ? 1
                                  : 0),
                          builder: (context, value, child) => DuoButton(
                              isPressed: matched[0][i],
                              onPressed: !matched[0][i]
                                  ? () {
                                      _onSelectionFirstColumn(i);
                                    }
                                  : null,
                              foreGroundColor: Color.lerp(
                                      Color.lerp(CustomTheme.borderColor,
                                          Colors.amber, value),
                                      Colors.green,
                                      matched[0][i] ? value : 0) ??
                                  Colors.green,
                              child: Text(
                                e["data"],
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )),
                        ))
                    .toList()
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...(matchWords)
                    .mapIndexed((i, e) => TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 100),
                          tween: Tween<double>(
                              begin: 0,
                              end: secondColumnSelected == i || matched[1][i]
                                  ? 1
                                  : 0),
                          builder: (context, value, child) => DuoButton(
                              onPressed: !matched[1][i]
                                  ? () {
                                      _onSelectionSecondColumn(i);
                                    }
                                  : null,
                              isPressed: matched[1][i],
                              foreGroundColor: Color.lerp(
                                      Color.lerp(CustomTheme.borderColor,
                                              Colors.amber, value) ??
                                          CustomTheme.borderColor,
                                      Colors.green,
                                      matched[1][i] ? value : 0) ??
                                  CustomTheme.borderColor,
                              child: Text(
                                e["match"],
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )),
                        ))
                    .toList()
              ],
            ),
          ),
        )
      ],
    );
  }
}
