import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/pages/loginPage.dart';
import 'package:myapp/pages/mainPage.dart';
import 'package:myapp/utils/sharedPreferenceService.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final PrefService _prefService = PrefService();

  @override
  void initState() {
    _prefService.readCache("username").then((value) {
      print(value.toString());
      if (value != null) {
        return Timer(
          Duration(seconds: 2),
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
          ),
        );
      } else {
        return Timer(
          Duration(seconds: 2),
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Icon(
        Icons.app_blocking,
      )),
    );
  }
}
