import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:indian_language_teacher/Screens/bottom_navigation.dart';
import 'package:indian_language_teacher/login_screen.dart';
import 'package:indian_language_teacher/network/network.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

Future<bool> getLogin() async {
  try {
    final token = await Networker.getLocalToken();
    if (token != null) {
      return true;
    } else {
      return false;
    }
  } on Exception catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      debugPrint("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getLogin(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return GlobalLoaderOverlay(
              child: MaterialApp(
                title: "Indo Guruji",
                theme: ThemeData.dark().copyWith(
                    primaryColor: const Color.fromRGBO(188, 206, 248, 1)),
                debugShowCheckedModeBanner: false,
                routes: {
                  "/login": (context) => const LoginScreen(),
                  "/home": (context) => const BottomNavigationHome(),
                },
                initialRoute: snapshot.data == false ? '/login' : '/home',
              ),
            );
          } else {
            return const MaterialApp(
              title: "Indo Guruji",
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }
        }));
  }
}
