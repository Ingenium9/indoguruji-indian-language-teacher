import 'package:flutter/material.dart';
import 'package:indian_language_teacher/theme/theme.dart';

class TextOption extends StatefulWidget {
  const TextOption(
      {super.key,
      required this.data,
      this.selected = false,
      required this.onSelected,
      this.id = 0});
  final String data;
  final bool selected;
  final int id;
  final Function(int) onSelected;
  @override
  State<TextOption> createState() => _TextOptionState();
}

class _TextOptionState extends State<TextOption> {
  bool tapped = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.onSelected(widget.id);
        },
        onTapDown: (details) => setState(() {
              tapped = true;
            }),
        onTapCancel: () => setState(() {
              tapped = false;
            }),
        onTapUp: (details) => setState(() {
              tapped = false;
            }),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                margin: EdgeInsets.only(top: CustomTheme.marginBottom3DEffect),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: CustomTheme.borderColor,
                ),
              ),
              AnimatedContainer(
                  duration: CustomTheme.buttonTapAnimationDuration,
                  margin: EdgeInsets.only(
                      bottom: tapped || widget.selected
                          ? 0
                          : CustomTheme.marginBottom3DEffect,
                      top: tapped || widget.selected
                          ? CustomTheme.marginBottom3DEffect
                          : 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).canvasColor,
                      border: Border.all(
                        color: widget.selected ? Colors.white : Colors.blue,
                      )),
                  child: Center(
                    child: Text(
                      widget.data.trim(),
                      style: const TextStyle(fontSize: 32),
                    ),
                  )),
            ],
          ),
        ));
  }
}
