import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/pages/mainPage.dart';
import 'package:myapp/pages/signupPage.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/sharedPreferenceService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final PrefService _prefService = PrefService();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isHidden = true;
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  Future login(BuildContext cont) async {
    if (_username.text == "" || _password.text == "") {
      Fluttertoast.showToast(
        msg: "Fields should not be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      var url = Uri.parse("http://192.168.1.70/rentalapp/login.php");
      var response = await http.post(
        url,
        body: {
          "username": _username.text,
          "password": _password.text,
        },
      );
      var data = json.decode(response.body);
      if (data == "success") {
        _prefService.createCache(_username.text).whenComplete(() {
          Fluttertoast.showToast(
            msg: "Logged in Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.blueAccent[200],
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
          );
        });
      } else {
        Fluttertoast.showToast(
            msg: "user not in database or incorrect username and password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 34,
                        foreground: Paint()..shader = mainTextGradient,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Hi,\nWelcome to room rental app",
                      style: TextStyle(
                        fontSize: 24,
                        foreground: Paint()..shader = subTextGradient,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Form(
                key: _formkey,
                autovalidateMode: AutovalidateMode.always,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //username
                      TextFormField(
                        controller: _username,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Enter username here",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.blue[200],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //password
                      TextFormField(
                        controller: _password,
                        obscureText: _isHidden,
                        decoration: InputDecoration(
                          hintText: "Enter password here",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.blue[200],
                          ),
                          suffix: InkWell(
                            onTap: () {
                              setState(() {
                                _isHidden = !_isHidden;
                              });
                            },
                            child: Icon(
                              _isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      ElevatedButton(
                        child: Text("Login"),
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          login(context);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Don't have an account?"),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Click here to register",
                          style: TextStyle(
                            foreground: Paint()..shader = noticeTextGradient,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
