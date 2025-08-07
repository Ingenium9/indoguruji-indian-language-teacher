import 'package:flutter/material.dart';
import 'package:indian_language_teacher/network/network.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Center(
            child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
            SizedBox(
              height: 250,
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('Settings'),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text("Theme"),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () async {
                      Networker.removeLocalToken();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    },
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
