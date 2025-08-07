import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:indian_language_teacher/Screens/unit_manager.dart';
import 'package:indian_language_teacher/network/network.dart';

class UnitLoader extends StatefulWidget {
  const UnitLoader({Key? key, required this.unitPath}) : super(key: key);
  final String unitPath;

  @override
  State<UnitLoader> createState() => _UnitLoaderState();
}

class _UnitLoaderState extends State<UnitLoader> {
  List<int> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Response>(
        future: Networker.getUnit(widget.unitPath),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              final data = snapshot.data!.data as Map<String, dynamic>;
              final List<dynamic> lessons = data['lessons'];
              return UnitManager(
                lessons: lessons,
                unitPath: widget.unitPath,
              );
            } else {
              return const Text("Error");
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const Text("Error");
        },
      ),
    );
  }
}
