import 'package:flutter/material.dart';
import 'package:indian_language_teacher/extensions.dart';
import 'package:indian_language_teacher/theme/theme.dart';
import 'package:indian_language_teacher/widgets/duobutton.dart';
import 'package:collection/collection.dart';

class SequenceButtonManager extends StatefulWidget {
  const SequenceButtonManager(
      {super.key,
      required this.words,
      required this.onUpdate,
      required this.selectedItems});
  final Function(List<int> selectedIndexs) onUpdate;
  final List<int> selectedItems;
  final List<Map<String, dynamic>> words;

  @override
  State<SequenceButtonManager> createState() => _SequenceButtonManagerState();
}

class _SequenceButtonManagerState extends State<SequenceButtonManager> {
  @override
  Widget build(BuildContext context) {
    final selectedItems = widget.selectedItems;
    return SingleChildScrollView(
      child: Column(
        children: widget.words
            .chunked(2)
            .mapIndexed((chunkIndex, e) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...e
                        .mapIndexed((buttonIndex, e) => Expanded(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 500),
                                    opacity: selectedItems
                                            .contains(widget.words.indexOf(e))
                                        ? 0.5
                                        : 1,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: DuoButton(
                                          isPressed: selectedItems.contains(
                                              widget.words.indexOf(e)),
                                          onPressed: !selectedItems.contains(
                                                  widget.words.indexOf(e))
                                              ? () {
                                                  setState(() {
                                                    if (!selectedItems.contains(
                                                        widget.words
                                                            .indexOf(e))) {
                                                      selectedItems.add(widget
                                                          .words
                                                          .indexOf(e));
                                                    }
                                                    debugPrint(selectedItems
                                                        .toString());
                                                    widget.onUpdate(
                                                        selectedItems);
                                                  });
                                                }
                                              : null,
                                          foreGroundColor:
                                              CustomTheme.borderColor,
                                          child: Text(
                                            e['word'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          )),
                                    ),
                                  ),
                                  AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      opacity: selectedItems
                                              .contains(widget.words.indexOf(e))
                                          ? 1
                                          : 0,
                                      child: Text((selectedItems.indexOf(
                                                  widget.words.indexOf(e)) +
                                              1)
                                          .toString())),
                                ],
                              ),
                            ))
                        .toList()
                  ],
                ))
            .toList(),
      ),
    );
  }
}
