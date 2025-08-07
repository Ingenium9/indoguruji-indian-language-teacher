import 'package:flutter/material.dart';
import 'package:indian_language_teacher/extensions.dart';
import 'package:indian_language_teacher/widgets/text_option.dart';

class TextOptionRadio extends StatefulWidget {
  const TextOptionRadio(
      {super.key, required this.options, required this.onSelectionChanged});

  final List<String> options;
  final Function(int) onSelectionChanged;
  @override
  State<TextOptionRadio> createState() => _TextOptionRadioState();
}

class _TextOptionRadioState extends State<TextOptionRadio> {
  int selected = -1;

  _onSelected(int val) {
    widget.onSelectionChanged(val);
    setState(() {
      selected = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...widget.options
          .map((e) => Expanded(
                child: SizedBox(
                  height: 100,
                  child: TextOption(
                    data: e,
                    onSelected: _onSelected,
                    selected: selected == widget.options.indexOf(e),
                    id: widget.options.indexOf(e),
                  ),
                ),
              ))
          .toList()
          .chunked(2)
          .map((e) => Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: e,
                ),
              ))
          .toList()
    ]);
  }
}
