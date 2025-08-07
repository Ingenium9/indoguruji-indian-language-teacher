import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:indian_language_teacher/Screens/basic_chars.dart';
import 'package:indian_language_teacher/Screens/unit_loader.dart';
import 'package:indian_language_teacher/data/consts.dart';
import 'package:indian_language_teacher/network/network.dart';
import 'package:indian_language_teacher/theme/theme.dart';
import 'package:indian_language_teacher/widgets/duobutton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

getOsicillatingValues(int index) {
  int i = index % 4;
  if (i == 0) {
    return 1;
  } else if (i == 1 || i == 3) {
    return 2;
  } else {
    return 3;
  }
}

Future<Map<String, dynamic>> getAllData(Function onLangChange) async {
  try {
    String lang = await Networker.getSavedLanguage();
    List<UnitButton> basicChars =
        await Networker.getBasicCharUnits(lang, onLangChange);
    int streakCount = await Networker.getStreakCount();

    return {
      "lang": lang,
      "basicCharUnits": basicChars,
      "streakCount": streakCount
    };
  } catch (e) {
    return Future.error(e);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Networker.updateStreakCount();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(future: getAllData(() {
      setState(() {});
    }), builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasData) {
        if (snapshot.data != null) {
          final String selectedLanguage = snapshot.data!['lang'];
          if (snapshot.hasData && snapshot.data != null) {
            return Scaffold(
              appBar: HomeAppBar(
                selectedLanguage: selectedLanguage,
                onLangChanged: (String newLang) {
                  setState(() {});
                },
                streakCount: snapshot.data!['streakCount'],
              ),
              body: Stack(
                alignment: Alignment.center,
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
                  SafeArea(
                      child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: DuoButton(
                          foreGroundColor: CustomTheme.borderColor,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UnitButtonViewer(
                                      title: "Basic Chars",
                                      unitButtons:
                                          (snapshot.data!["basicCharUnits"]
                                                  as List<UnitButton>)
                                              .where((element) =>
                                                  element.type == "basics")
                                              .toList()),
                                ));
                          },
                          child: const Text("Basic Characters",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 32)),
                        ),
                      )),
                      const SizedBox(
                        height: 50,
                      ),
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: DuoButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UnitButtonViewer(
                                      title: "Word",
                                      unitButtons:
                                          (snapshot.data!["basicCharUnits"]
                                                  as List<UnitButton>)
                                              .where((element) =>
                                                  element.type == "word")
                                              .toList()),
                                ));
                          },
                          foreGroundColor: const Color(0xFFD7EB58),
                          child: const Text("Words",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 32)),
                        ),
                      )),
                      const SizedBox(
                        height: 50,
                      ),
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: DuoButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UnitButtonViewer(
                                      title: "Sentences",
                                      unitButtons:
                                          (snapshot.data!["basicCharUnits"]
                                                  as List<UnitButton>)
                                              .where((element) =>
                                                  element.type == "sentence")
                                              .toList()),
                                ));
                          },
                          foreGroundColor: const Color(0xFFDEBCF8),
                          child: const Text("Sentences",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 32)),
                        ),
                      )),
                    ],
                  )),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            if (snapshot.error is DioError) {
              debugPrint((snapshot.error as DioError).message);
            } else {
              debugPrint(snapshot.error.toString());
            }
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: const Text("Retry")),
                    if (snapshot.error is DioError)
                      Text((snapshot.error as DioError)
                          .response!
                          .realUri
                          .toString()),
                  ],
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text("Is null"),
            ),
          );
        }
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (snapshot.hasError) {
        return Scaffold(
          body: Text(snapshot.error.toString()),
        );
      }
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}

// Custom app bar for home screen
class HomeAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  HomeAppBar({
    Key? key,
    required this.selectedLanguage,
    required this.onLangChanged,
    required this.streakCount,
  })  : preferredSize = const Size.fromHeight(200.0),
        super(key: key);
  final String selectedLanguage;
  final Function(String) onLangChanged;
  final int streakCount;
  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  late String lang;

  @override
  void initState() {
    super.initState();
    lang = availableLanguagesAbbr[
        availableLanguages.indexOf(widget.selectedLanguage)];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
              margin: const EdgeInsets.all(10),
              child: SizedBox(
                width: 50,
                height: 50,
                child: DropdownButtonFormField<String>(
                  value: lang,
                  onChanged: (value) {
                    setState(() {
                      lang = value!;
                    });
                    widget.onLangChanged(value!);
                    Networker.setSavedLanguage(availableLanguages[
                        availableLanguagesAbbr.indexOf(value)]);
                  },
                  items: availableLanguagesAbbr
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                ),
              )),
          Container(
            margin: const EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: widget.streakCount > 0 ? Colors.orange : Colors.white,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.streakCount.toString(),
                      style: const TextStyle(fontSize: 20),
                    ))
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

class UnitButton extends StatefulWidget {
  const UnitButton({
    Key? key,
    required this.image,
    required this.unitName,
    required this.unitPath,
    required this.updateParent,
    this.isCompleted = false,
    required this.type,
  }) : super(key: key);
  final Image image;
  final String type;
  final String unitName;
  final String unitPath;
  final bool isCompleted;
  final Function updateParent;

  @override
  State<UnitButton> createState() => _UnitButtonState();
}

class _UnitButtonState extends State<UnitButton> {
  bool tapped = false;
  @override
  Widget build(BuildContext context) {
    navigateToUnitLoader(String unitPath) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UnitLoader(
                    unitPath: unitPath,
                  ))).then((value) => widget.updateParent());
    }

    //The lesson button rendering
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (details) => setState(() {
                tapped = true;
              }),
              onTap: () {
                debugPrint("Tapped");
                navigateToUnitLoader(widget.unitPath);
              },
              onTapCancel: () => setState(() {
                tapped = false;
              }),
              onTapUp: (details) => setState(() {
                tapped = false;
              }),
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(top: CustomTheme.marginBottom3DEffect),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: CustomTheme.borderColor,
                    ),
                  ),
                  AnimatedContainer(
                    duration: CustomTheme.buttonTapAnimationDuration,
                    margin: EdgeInsets.only(
                      bottom: tapped ? 0 : CustomTheme.marginBottom3DEffect,
                      top: tapped ? CustomTheme.marginBottom3DEffect : 0,
                    ),
                    decoration: BoxDecoration(
                        color: CustomTheme.homeScreenButtonColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.yellow[100],
                        borderRadius: BorderRadius.circular(25),
                        child: Ink(
                          child: Container(
                              margin: const EdgeInsets.all(15),
                              child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: widget.isCompleted
                                      ? const Icon(
                                          Icons.check,
                                          size: 50,
                                          color: Colors.white,
                                        )
                                      : widget.image)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: Text(
              widget.unitName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
            ),
          )
        ],
      ),
    );
  }
}
