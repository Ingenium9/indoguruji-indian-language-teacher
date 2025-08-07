import 'package:flutter/material.dart';

class DuoButton extends StatefulWidget {
  const DuoButton(
      {super.key,
      required this.child,
      this.onPressed,
      required this.foreGroundColor,
      this.backGroundColor,
      this.isPressed});
  final Function? onPressed;
  final Color? backGroundColor;
  final bool? isPressed;
  final Widget child;
  final Color foreGroundColor;
  @override
  State<DuoButton> createState() => _DuoButtonState();
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

class _DuoButtonState extends State<DuoButton> {
  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    final isPressed = widget.isPressed;
    final double bottomMargin;
    final double topMargin;
    if (widget.onPressed == null) {
      if (isPressed != null && isPressed == true) {
        bottomMargin = 0;
        topMargin = 10;
      } else {
        bottomMargin = 10;
        topMargin = 0;
      }
    } else {
      bottomMargin = tapped ? 0 : 10;
      topMargin = tapped ? 10 : 0;
    }
    return GestureDetector(
      onTapDown: (TapDownDetails tdD) {
        setState(() {
          tapped = true;
        });
      },
      onTapUp: (details) => setState(() {
        tapped = false;
      }),
      onTapCancel: () => setState(() {
        tapped = false;
      }),
      onTap: () {
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: widget.backGroundColor ??
                    darken(widget.foreGroundColor, 0.1),
                borderRadius: BorderRadius.circular(25)),
            child: Center(
                child: Container(
              margin: const EdgeInsets.all(20),
              child: Visibility(
                  visible: false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: widget.child),
            )),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            margin: EdgeInsets.only(bottom: bottomMargin, top: topMargin),
            decoration: BoxDecoration(
                color: widget.foreGroundColor,
                borderRadius: BorderRadius.circular(25)),
            child: Center(
              child: Container(
                  margin: const EdgeInsets.all(20), child: widget.child),
            ),
          ),
        ],
      ),
    );
  }
}
