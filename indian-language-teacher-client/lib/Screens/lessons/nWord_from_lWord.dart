// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:indian_language_teacher/theme/theme.dart';
import 'package:indian_language_teacher/widgets/duobutton.dart';
import 'package:indian_language_teacher/widgets/text_option_radio.dart';

class NWordFromLWord extends StatefulWidget {
  const NWordFromLWord(
      {Key? key, required this.lessonData, required this.onSelectedUpdate})
      : super(key: key);
  final Map<String, dynamic> lessonData;
  final Function(int selectedIndex) onSelectedUpdate;
  @override
  State<NWordFromLWord> createState() => _NWordFromLWordState();
}

class _NWordFromLWordState extends State<NWordFromLWord> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DuoButton(
                    foreGroundColor: CustomTheme.borderColor,
                    child: Text(
                      widget.lessonData["data"].toString().trim(),
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: TextOptionRadio(
            options: [
              ...widget.lessonData['options'].map((e) => e["data"]).toList()
            ],
            onSelectionChanged: (p0) => widget.onSelectedUpdate(p0),
          ),
        )
      ],
    );
  }
}
