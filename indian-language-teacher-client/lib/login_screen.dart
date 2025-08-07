import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indian_language_teacher/network/network.dart';
import 'package:indian_language_teacher/theme/theme.dart';
import 'package:indian_language_teacher/widgets/duobutton.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isInitial = true;
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _otp = TextEditingController();
  String lverificationId = '';
  final _formKey = GlobalKey<FormState>();

  sendOTP() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${_phoneNumber.text}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          debugPrint(e.toString());
          context.loaderOverlay.hide();
        },
        codeSent: (String verificationId, int? resendToken) async {
          setState(() {
            isInitial = false;
            lverificationId = verificationId;
          });
          context.loaderOverlay.hide();
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  goToHome() {
    Navigator.pushReplacementNamed(context, "/home");
  }

  // function to show a an alert dialog
  void _showDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          );
        });
  }

  // a function for showing error only
  void _showError(String content) {
    _showDialog("Error", "Error: $content");
  }

  onSubmit() async {
    context.loaderOverlay.show();
    if (_formKey.currentState!.validate()) {
      if (isInitial) {
        await sendOTP();
      } else {
        // Login user with OTP
        try {
          final PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: lverificationId, smsCode: _otp.text);

          //Signin with firebase
          final UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          try {
            debugPrint(await userCredential.user!.getIdToken());
            final token = (await Networker.getUserToken(
                phoneNumber: _phoneNumber.text,
                firebaseToken:
                    await userCredential.user!.getIdToken()))["token"];
            await Networker.setLocalToken(token);
            goToHome();
          } on DioError catch (e) {
            debugPrint(e.toString());
            //_showError(e.message);
          } catch (e) {
            _showError(e.toString());
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'invalid-verification-code') {
            _showError("Invalid OTP");
          } else {
            _showError(e.toString());
          }
        } catch (e) {
          _showError(e.toString());
        }
        context.loaderOverlay.hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(children: [
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Welcome",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Enter Mobile Number",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.white70),
                        ),
                      ],
                    )
                  ],
                )),
            Expanded(
              child: Column(children: [
                const Spacer(
                  flex: 1,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Mobile Number";
                    }
                    if (value.length != 10) {
                      return "Please enter a valid Mobile Number";
                    }
                    return null;
                  },
                  controller: _phoneNumber,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(fontSize: 25),
                  decoration: const InputDecoration(
                      hintText: "Enter Mobile Number",
                      hintStyle: TextStyle(fontSize: 25)),
                ),
                const SizedBox(
                  height: 50,
                ),
                if (!isInitial)
                  TextFormField(
                    maxLength: 6,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter OTP";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 25),
                    controller: _otp,
                    decoration: const InputDecoration(
                        hintText: "Enter OTP",
                        hintStyle: TextStyle(fontSize: 25)),
                  ),
                const Spacer(
                  flex: 1,
                )
              ]),
            ),
            Expanded(
              flex: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      child: DuoButton(
                          onPressed: () {
                            onSubmit();
                          },
                          foreGroundColor: CustomTheme.borderColor,
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ]),
            )
          ]),
        ),
      ),
    );
  }
}
