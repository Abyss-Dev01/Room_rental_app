import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/pages/loginPage.dart';
import 'package:myapp/screens/searchScreen.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/sharedPreferenceService.dart';

class LogoutScreen extends StatelessWidget {
  final PrefService _prefService = PrefService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Please use the application again. Thank you!",
                    style: TextStyle(
                      fontSize: 22,
                      foreground: Paint()..shader = mainTextGradient,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    onPressed: () async {
                      await _prefService
                          .removeCache("password")
                          .whenComplete(() {
                        Fluttertoast.showToast(
                          msg: "Logged out Successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      });
                    },
                    child: Text("Log out"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
