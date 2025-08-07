import 'package:flutter/material.dart';
import 'package:indian_language_teacher/extensions.dart';
import 'package:indian_language_teacher/widgets/sound_player.dart';

class SoundPlayerRadio extends StatefulWidget {
  const SoundPlayerRadio(
      {super.key, required this.audioUrl, required this.onSelectionChanged});

  final List<String> audioUrl;
  final Function(int) onSelectionChanged;
  @override
  State<SoundPlayerRadio> createState() => _SoundPlayerRadioState();
}

class _SoundPlayerRadioState extends State<SoundPlayerRadio> {
  bool _isPlaying = false;
  int selected = -1;
  _updatePlaying(bool val) {
    setState(() {
      _isPlaying = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Selected item is $selected");
    return Column(children: [
      ...widget.audioUrl
          .map((e) => Expanded(
                child: SizedBox(
                  height: 100,
                  child: PlaySound(
                    audioUrl: e,
                    id: widget.audioUrl.indexOf(e),
                    isPlaying: (p) {
                      _updatePlaying(p);
                    },
                    isSelectable: !_isPlaying,
                    onSelected: (val) {
                      widget.onSelectionChanged(val);
                      setState(() {
                        selected = val;
                      });
                    },
                    selected: selected == widget.audioUrl.indexOf(e),
                  ),
                ),
              ))
          .toList()
          .chunked(2)
          .map((e) => Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: e,
                ),
              ))
          .toList()
    ]);
  }
}
