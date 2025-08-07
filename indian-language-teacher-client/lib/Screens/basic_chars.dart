import 'package:flutter/material.dart';
import 'package:indian_language_teacher/Screens/home_screen.dart';

class UnitButtonViewer extends StatefulWidget {
  const UnitButtonViewer(
      {super.key, required this.unitButtons, required this.title});
  final String title;
  final List<UnitButton> unitButtons;
  @override
  State<UnitButtonViewer> createState() => _UnitButtonViewerState();
}

class _UnitButtonViewerState extends State<UnitButtonViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
          child: Stack(
        fit: StackFit.expand,
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0,
                    0.05,
                    0.95,
                    1
                  ],
                  colors: [
                    Colors.transparent,
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ]).createShader(
                  Rect.fromLTRB(0, 0, bounds.width, bounds.height));
            },
            blendMode: BlendMode.dstIn,
            child: Image.asset(
              "assets/home_background.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.1),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ...widget.unitButtons.map((e) => Row(
                      children: [
                        Spacer(
                            flex: getOsicillatingValues(
                                widget.unitButtons.indexOf(e))),
                        Expanded(flex: 2, child: e),
                        Spacer(
                          flex: (4 -
                                  getOsicillatingValues(
                                      widget.unitButtons.indexOf(e)))
                              .toInt(),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ],
      )),
    );
  }
}
