import 'package:flutter/material.dart';

class ErrorLesson extends StatefulWidget {
  const ErrorLesson({super.key});

  @override
  State<ErrorLesson> createState() => _ErrorLessonState();
}

class _ErrorLessonState extends State<ErrorLesson> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Center(child: Text("Not implemented yet")));
  }
}
