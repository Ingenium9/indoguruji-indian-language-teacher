import 'package:flutter/material.dart';
import 'package:indian_language_teacher/Screens/lessons/audio_from_char.dart';
import 'package:indian_language_teacher/Screens/lessons/audio_from_word.dart';
import 'package:indian_language_teacher/Screens/lessons/char_from_audio.dart';
import 'package:indian_language_teacher/Screens/lessons/english_word_audio_sequence.dart';
import 'package:indian_language_teacher/Screens/lessons/error_lesson.dart';
import 'package:indian_language_teacher/Screens/lessons/indian_word_audio_sequence.dart';
import 'package:indian_language_teacher/Screens/lessons/indian_word_sequence.dart';
import 'package:indian_language_teacher/Screens/lessons/indian_word_sequence_from_audio.dart';
import 'package:indian_language_teacher/Screens/lessons/intro_char.dart';
import 'package:indian_language_teacher/Screens/lessons/intro_word.dart';
import 'package:indian_language_teacher/Screens/lessons/lWord_from_NWord.dart';
import 'package:indian_language_teacher/Screens/lessons/match_words.dart';
import 'package:indian_language_teacher/Screens/lessons/nWord_from_lWord.dart';
import 'package:indian_language_teacher/Screens/lessons/word_from_audio.dart';
import 'package:indian_language_teacher/network/network.dart';
import 'package:indian_language_teacher/theme/theme.dart';
import 'package:indian_language_teacher/widgets/duobutton.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rive/rive.dart';
import 'package:collection/collection.dart';

class UnitManager extends StatefulWidget {
  const UnitManager({super.key, required this.lessons, required this.unitPath});
  final List<dynamic> lessons;
  final String unitPath;
  @override
  State<UnitManager> createState() => _UnitManagerState();
}

class _UnitManagerState extends State<UnitManager> {
  final player = AudioPlayer();
  final ScrollController _lessonScrollController = ScrollController();
  double completionPer = 0.0;
  late List<int> choices = List.filled(widget.lessons.length, -1);
  late List<List<int>> sequenceChoices =
      List.generate(widget.lessons.length, (_) => []);
  late RiveAnimationController _successAnimation;
  int _currentLesson = 0;

  _goToNextLesson(data) {
    _showCorrect(context, data);
  }

  _showCustomModalBottomSheet(bool wrong, BuildContext ctx, {data}) {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (ctx) => Container(
              width: 300,
              height: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: wrong ? Colors.red : Colors.green),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    wrong ? "Wrong" : 'Correct Answer',
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {
                      Navigator.pop(context);
                      if (!wrong) {
                        setState(() {
                          _currentLesson++;
                          completionPer =
                              (_currentLesson / widget.lessons.length)
                                  .toDouble();
                          _lessonScrollController.animateTo(
                              MediaQuery.of(context).size.width *
                                  _currentLesson,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                          if (_currentLesson == data.length) {
                            _playSuccess();
                          }
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: wrong ? Colors.red : Colors.green),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  void _showWrong(BuildContext ctx) {
    player.setUrl("asset:///assets/sounds/failure.mp3");
    player.setVolume(0.2);
    player.play();
    _showCustomModalBottomSheet(true, ctx);
  }

  void _playSuccess() async {
    final player2 = AudioPlayer();
    player2.setUrl("asset:///assets/sounds/unit_completion.mp3");
    player2.setVolume(0.5);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _successAnimation.isActive = true;
      });
    }
    await Future.delayed(const Duration(milliseconds: 500));
    player2.play();
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {
        _successAnimation.isActive = false;
      });
    }
  }

  void _showCorrect(BuildContext context, data) {
    player.setUrl("asset:///assets/sounds/success.mp3");
    player.setVolume(0.2);
    player.play();

    _showCustomModalBottomSheet(false, context, data: data);
  }

  _unitComplete() {
    Networker.updateUnitProgress(widget.unitPath.split("/").last.split(".")[0]);
    Navigator.pop(context);
  }

  checkLesson(BuildContext context) {
    Map<String, dynamic> lesson =
        widget.lessons[_currentLesson] as Map<String, dynamic>;
    final introLessons = [
      "introChar",
      'introWord',
    ];
    final optionBasedLessons = [
      "audioFromChar",
      'charFromAudio',
      'wordFromAudio',
      'audioFromWord',
      'lWordFromNWord',
      'nWordFromLWord'
    ];

    final nonOptionBasedLesson = [
      "indianWordAudioSequence",
      "englishWordAudioSequence",
      'indianWordSequence',
      "indianWordSequenceFromAudio"
    ];

    try {
      if (optionBasedLessons.contains(lesson["lessonType"])) {
        if (lesson["correctOption"] == choices[_currentLesson]) {
          _showCorrect(context, widget.lessons);
          debugPrint(
              "Option: ${lesson["correctOption"] == choices[_currentLesson]}");
        } else {
          _showWrong(context);
        }
      } else if (lesson['lessonType'] == "matchWords") {
        if (choices[_currentLesson] >= 0) {
          _showCorrect(context, widget.lessons);
        } else {
          _showWrong(context);
        }
      } else if (nonOptionBasedLesson.contains(lesson["lessonType"])) {
        if (choices[_currentLesson] >= 0) {
          _showCorrect(context, widget.lessons);
        } else {
          setState(() {
            sequenceChoices[_currentLesson] = [];
          });
          _showWrong(context);
        }
      } else if (introLessons.contains(lesson["lessonType"])) {
        _showCorrect(context, widget.lessons);
      } else {
        _showCorrect(context, widget.lessons);
      }
    } catch (e) {
      debugPrint(e.toString());
      return e;
    }
  }

  @override
  void initState() {
    super.initState();
    _successAnimation = OneShotAnimation(
      'Success',
      autoplay: true,
    );
  }

  @override
  void dispose() {
    _successAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close)),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.dark_mode))
                      ]),
                ),
                Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                            height: 20,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  tween: Tween<double>(
                                      begin: 0, end: completionPer),
                                  builder: (context, value, _) =>
                                      LinearProgressIndicator(
                                    color: Color.lerp(CustomTheme.borderColor,
                                        Colors.green, value),
                                    value: value,
                                  ),
                                ),
                              ),
                            )))
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: ListView.builder(
              itemCount: widget.lessons.length + 1,
              itemBuilder: (context, index) {
                if (index < widget.lessons.length) {
                  return widget.lessons.mapIndexed((i, e) {
                    switch (e['lessonType']) {
                      case 'introChar':
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: IntroChar(
                            lessonData: e,
                          ),
                        );
                      case 'audioFromChar':
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: AudioFromChar(
                              lessonData: e,
                              onSelectedUpdated: (int selectedIndex) {
                                setState(() {
                                  choices[i] = selectedIndex;
                                });
                              }),
                        );
                      case 'charFromAudio':
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: CharFromAudio(
                              lessonData: e,
                              onSelectedUpdated: (int selectedIndex) {
                                setState(() {
                                  choices[i] = selectedIndex;
                                });
                              }),
                        );
                      case 'introWord':
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: IntroWord(
                            lessonData: e,
                          ),
                        );
                      case 'wordFromAudio':
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: WordFromAudio(
                              lessonData: e,
                              onSelectedUpdated: (int selectedIndex) {
                                setState(() {
                                  choices[i] = selectedIndex;
                                });
                              }),
                        );
                      case "audioFromWord":
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: AudioFromWord(
                            lessonData: e,
                            onSelectedUpdated: (int selectedIndex) {
                              setState(() {
                                choices[i] = selectedIndex;
                              });
                            },
                          ),
                        );
                      case "lWordFromNWord":
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: LWordFromNWord(
                            lessonData: e,
                            onSelectedUpdate: (int selectedIndex) {
                              setState(() {
                                choices[i] = selectedIndex;
                              });
                            },
                          ),
                        );
                      case 'nWordFromLWord':
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: NWordFromLWord(
                            lessonData: e,
                            onSelectedUpdate: (selectedIndex) {
                              setState(() {
                                choices[i] = selectedIndex;
                              });
                            },
                          ),
                        );
                      case "matchWords":
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: MatchWords(
                            lessonData: e,
                            onSelectionUpdated: (selectedIndex) {
                              setState(() {
                                choices[i] = selectedIndex;
                              });
                            },
                          ),
                        );
                      case "indianWordAudioSequence":
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: IndianWordAudioSequence(
                            lessonData: e,
                            selectedItems: sequenceChoices[i],
                            onSelectedUpdated: (selectedItems, selectedIndex) {
                              setState(() {
                                sequenceChoices[i] = selectedItems;
                                choices[i] = selectedIndex;
                              });
                            },
                          ),
                        );
                      case "englishWordAudioSequence":
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: EnglishWordAudioSequence(
                            lessonData: e,
                            selectedItems: sequenceChoices[i],
                            onSelectedUpdated: (selectedItems, selectedIndex) {
                              setState(() {
                                sequenceChoices[i] = selectedItems;
                                choices[i] = selectedIndex;
                              });
                            },
                          ),
                        );
                      case "indianWordSequence":
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: IndianWordSequence(
                            lessonData: e,
                            selectedItems: sequenceChoices[i],
                            onSelectedUpdate: (selectedItems, selectedIndex) {
                              setState(() {
                                sequenceChoices[i] = selectedItems;
                                choices[i] = selectedIndex;
                              });
                            },
                          ),
                        );
                      case "indianWordSequenceFromAudio":
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: IndianWordSequenceFromAudio(
                            lessonData: e,
                            onSelectedUpdated: (selectedItems, selectedIndex) {
                              setState(() {
                                sequenceChoices[i] = selectedItems;
                                choices[i] = selectedIndex;
                              });
                            },
                            selectedItems: sequenceChoices[i],
                          ),
                        );
                      default:
                        return const ErrorLesson();
                    }
                  }).toList()[index];
                }
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: RiveAnimation.asset(
                          "assets/animations/unit_completion.riv",
                          fit: BoxFit.cover,
                          controllers: [_successAnimation],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Unit Completed",
                                    style: TextStyle(fontSize: 32),
                                  )
                                ]),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              controller: _lessonScrollController,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(35),
                  child: DuoButton(
                    onPressed: () {
                      if (_currentLesson == widget.lessons.length) {
                        _unitComplete();
                      } else {
                        checkLesson(context);
                      }
                    },
                    foreGroundColor: _currentLesson == widget.lessons.length
                        ? Colors.green
                        : CustomTheme.borderColor,
                    child: const Text(
                      "Continue",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
