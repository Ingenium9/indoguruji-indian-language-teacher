import 'package:flutter/material.dart';
import 'package:indian_language_teacher/theme/theme.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rive/rive.dart';

class PlaySound extends StatefulWidget {
  const PlaySound(
      {super.key,
      required this.audioUrl,
      required this.isPlaying,
      required this.id,
      required this.isSelectable,
      this.selected = false,
      this.onSelected});
  final String audioUrl;
  final int id;
  final bool isSelectable;
  final bool selected;
  final void Function(bool) isPlaying;
  final void Function(int)? onSelected;
  @override
  State<PlaySound> createState() => _PlaySoundState();
}

class _PlaySoundState extends State<PlaySound> {
  /// Controller for playback
  late RiveAnimationController _controller;
  final player = AudioPlayer(); // Create a player
  bool tapped = false;
  @override
  void initState() {
    super.initState();
    _controller = OneShotAnimation(
      "Example",
      autoplay: false,
    );
  }

  _playAudioFromUrl(String url) async {
    try {
      await player.setUrl(url);
      await player.play();
      await player.stop();
    } catch (e) {
      debugPrint(e.toString());
    }
    widget.isPlaying(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        if (!widget.isSelectable) return;
        widget.isPlaying(true);
        if (!_controller.isActive && !player.playing) {
          _playAudioFromUrl(widget.audioUrl);
          _controller.isActive = true;
        }
        if (widget.onSelected != null) {
          widget.onSelected!(widget.id);
        }
      }),
      onTapDown: (details) => setState(() {
        tapped = true;
      }),
      onTapUp: (details) => setState(() {
        tapped = false;
      }),
      onTapCancel: () => setState(() {
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
                  borderRadius: BorderRadius.circular(10),
                  color: CustomTheme.borderColor),
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).canvasColor,
                  border: Border.all(
                    color: widget.selected
                        ? Colors.white
                        : CustomTheme.borderColor,
                    width: 2,
                  )),
              child: SizedBox(
                width: 50,
                height: 50,
                child: RiveAnimation.asset(
                  "assets/animations/soud_icon.riv",
                  controllers: [_controller],
                  onInit: (art) {
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
