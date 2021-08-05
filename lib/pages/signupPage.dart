import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/pages/loginPage.dart';
import 'package:myapp/pages/mainPage.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/sharedPreferenceService.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final PrefService _prefService = PrefService();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmpass = TextEditingController();

  Future signup(BuildContext cont) async {
    if (_username.text == "" || _pass.text == "" || _confirmpass.text == "") {
      Fluttertoast.showToast(
        msg: "Fields should not be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      var url = Uri.parse("http://192.168.1.70/rentalapp/signup.php");
      var response = await http.post(
        url,
        body: {
          "username": _username.text,
          "password": _pass.text,
        },
      );
      var data = json.decode(response.body);
      if (data == "success") {
        _prefService.createCache(_username.text).whenComplete(
          () {
            Fluttertoast.showToast(
              msg: "User registered Successfully",
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
          },
        );
      } else {
        Fluttertoast.showToast(
            msg: "username already exists",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 34,
                          foreground: Paint()..shader = mainTextGradient,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Hi,\nPlease fill up the form for account registration.",
                        style: TextStyle(
                          fontSize: 24,
                          foreground: Paint()..shader = subTextGradient,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formkey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter username";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //password
                      TextFormField(
                        obscureText: true,
                        controller: _pass,
                        decoration: InputDecoration(
                          hintText: "Enter password here",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.blue[200],
                          ),
                        ),
                        validator: (value) {
                          if (value == "" || value!.length <= 6) {
                            return "Invalid Password";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //confirm password
                      TextFormField(
                        controller: _confirmpass,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Confirm password here",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.blue[200],
                          ),
                        ),
                        validator: (value) {
                          if (value!.length <= 6 || value.isEmpty) {
                            return "Invalid Password";
                          } else if (value != _pass.text) {
                            return "Password doesn't match";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        child: Text("Sign up"),
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          signup(context);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Already have an account?"),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Click here to login",
                          style: TextStyle(
                            foreground: Paint()..shader = noticeTextGradient,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
